module.exports = app => { // Exporta uma função que recebe o objeto app, permitindo que as rotas e funções do controlador sejam usadas em outros arquivos
    const { existsOrError, notExistsOrError } = app.api.validation // Desestrutura funções de validação do módulo de validação do app, usadas para checar condições em categorias

    const save = (req, res) => { // Define a função save que lida com requisições de criação ou atualização de categorias
        const category = { // Cria um objeto category a partir dos dados enviados na requisição
            id: req.body.id, // Atribui o id da categoria, se fornecido, vindo do corpo da requisição
            name: req.body.name, // Atribui o nome da categoria, deve ser fornecido no corpo da requisição
            parentId: req.body.parentId // Atribui o parentId, que indica se a categoria é filha de outra
        }
        
        if(req.params.id) category.id = req.params.id // Se um id for passado nos parâmetros da URL, ele é usado para atualização

        try {
            existsOrError(category.name, 'Nome não informado') // Valida se o nome da categoria foi fornecido, lançando erro se não
        } catch(msg) {
            return res.status(400).send(msg) // Se houver erro na validação, retorna um erro 400 (Bad Request) com a mensagem
        }

        if(category.id) { // Verifica se a categoria já possui um id (ou seja, está sendo atualizada)
            app.db('categories') // Acessa a tabela 'categories' no banco de dados
                .update(category) // Chama o método de atualização, passando o objeto category
                .where({ id: category.id }) // Especifica que a atualização deve ocorrer onde o id da categoria é igual ao id fornecido
                .then(_ => res.status(204).send()) // Se a atualização for bem-sucedida, retorna um status 204 (sem conteúdo)
                .catch(err => res.status(500).send(err)) // Se ocorrer um erro, retorna um status 500 (Internal Server Error) com a mensagem de erro
        } else { // Se a categoria não possui um id, significa que é uma nova categoria
            app.db('categories') // Acessa a tabela 'categories'
                .insert(category) // Chama o método de inserção, passando o objeto category
                .then(_ => res.status(204).send()) // Se a inserção for bem-sucedida, retorna um status 204
                .catch(err => res.status(500).send(err)) // Se ocorrer um erro, retorna um status 500 com a mensagem de erro
        }
    }

    const remove = async (req, res) => { // Define a função remove para lidar com requisições de remoção de categorias
        try {
            existsOrError(req.params.id, 'Código da Categoria não informado.') // Verifica se o id da categoria está presente nos parâmetros

            const subcategory = await app.db('categories') // Busca subcategorias associadas à categoria a ser removida
                .where({ parentId: req.params.id }) // Filtra categorias onde parentId corresponde ao id fornecido
            notExistsOrError(subcategory, 'Categoria possui subcategorias.') // Valida se não existem subcategorias; lança erro se existirem

            const articles = await app.db('articles') // Busca artigos que estão associados à categoria a ser removida
                .where({ categoryId: req.params.id }) // Filtra artigos onde categoryId corresponde ao id fornecido
            notExistsOrError(articles, 'Categoria possui artigos.') // Valida se não existem artigos associados; lança erro se existirem

            const rowsDeleted = await app.db('categories') // Tenta remover a categoria do banco de dados
                .where({ id: req.params.id }).del() // Especifica que a remoção deve ocorrer onde o id da categoria é igual ao id fornecido
            existsOrError(rowsDeleted, 'Categoria não foi encontrada.') // Verifica se a categoria foi realmente removida; lança erro se não foi

            res.status(204).send() // Se a remoção for bem-sucedida, retorna um status 204
        } catch(msg) {
            res.status(400).send(msg) // Se houver erro em qualquer validação, retorna um status 400 com a mensagem de erro
        }
    }

    const withPath = categories => { // Define uma função para adicionar um caminho hierárquico às categorias
        const getParent = (categories, parentId) => { // Define uma função interna que encontra o pai de uma categoria dada
            const parent = categories.filter(parent => parent.id === parentId) // Filtra as categorias para encontrar a que corresponde ao parentId
            return parent.length ? parent[0] : null // Se um pai for encontrado, retorna-o; caso contrário, retorna null
        }

        const categoriesWithPath = categories.map(category => { // Mapeia cada categoria para incluir seu caminho hierárquico
            let path = category.name // Inicializa o caminho com o nome da categoria
            let parent = getParent(categories, category.parentId) // Busca o pai da categoria atual

            while(parent) { // Enquanto houver um pai
                path = `${parent.name} > ${path}` // Adiciona o nome do pai ao início do caminho
                parent = getParent(categories, parent.parentId) // Atualiza o pai para o próximo nível na hierarquia
            }

            return { ...category, path } // Retorna a categoria original, mas agora inclui o caminho
        })

        categoriesWithPath.sort((a, b) => { // Ordena as categorias com base no caminho
            if(a.path < b.path) return -1 // Se o caminho da categoria 'a' é lexicograficamente menor que 'b', retorna -1
            if(a.path > b.path) return 1 // Se o caminho da categoria 'a' é maior, retorna 1
            return 0 // Se os caminhos são iguais, retorna 0
        })

        return categoriesWithPath // Retorna a lista de categorias agora enriquecida com os caminhos
    }

    const get = (req, res) => { // Define a função get que busca e retorna todas as categorias
        app.db('categories') // Acessa a tabela 'categories'
            .then(categories => res.json(withPath(categories))) // Retorna as categorias com seus caminhos em formato JSON
            .catch(err => res.status(500).send(err)) // Se ocorrer um erro, retorna um status 500 com a mensagem de erro
    }

    const getById = (req, res) => { // Define a função getById para buscar uma categoria específica com base no id
        app.db('categories') // Acessa a tabela 'categories'
            .where({ id: req.params.id }) // Busca a categoria cujo id corresponde ao id fornecido nos parâmetros
            .first() // Retorna o primeiro resultado encontrado
            .then(category => res.json(category)) // Retorna a categoria encontrada em formato JSON
            .catch(err => res.status(500).send(err)) // Se ocorrer um erro, retorna um status 500 com a mensagem de erro
    }

    const toTree = (categories, tree) => { // Define uma função para transformar categorias em uma estrutura de árvore hierárquica
        if(!tree) tree = categories.filter(c => !c.parentId) // Se não houver uma árvore fornecida, pega as categorias que não têm pai (raiz da árvore)
        tree = tree.map(parentNode => { // Mapeia cada nó pai
            const isChild = node => node.parentId == parentNode.id // Define uma função para identificar se um nó é filho do nó pai atual
            parentNode.children = toTree(categories, categories.filter(isChild)) // Recursivamente define os filhos do nó pai
            return parentNode // Retorna o nó pai com a lista de seus filhos
        })
        return tree // Retorna a árvore construída
    }

    const getTree = (req, res) => { // Define a função getTree que busca a estrutura hierárquica das categorias
        app.db('categories') // Acessa a tabela 'categories'
            .then(categories => res.json(toTree(categories))) // Retorna a estrutura em formato JSON usando a função toTree
            .catch(err => res.status(500).send(err)) // Se ocorrer um erro, retorna um status 500 com a mensagem de erro
    }

    return { save, remove, get, getById, getTree } // Retorna um objeto com as funções definidas para serem usadas em rotas do app
}
