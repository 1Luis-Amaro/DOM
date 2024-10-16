const queries = require('./queries') // Importa um módulo de consultas SQL que pode ser usado mais tarde no código.

module.exports = app => { // Exporta uma função que recebe o objeto app, permitindo que outras partes do código usem essa função.
    const { existsOrError } = app.api.validation // Desestrutura a função existsOrError do objeto de validação do app.

    const save = (req, res) => { // Define a função save que recebe a requisição (req) e a resposta (res).
        const article = { ...req.body } // Cria um novo objeto article a partir do corpo da requisição.
        if(req.params.id) article.id = req.params.id // Se houver um id nos parâmetros da requisição, adiciona ao objeto article.

        try { // Inicia um bloco de tentativa para validação dos dados.
            existsOrError(article.name, 'Nome não informado') // Verifica se o nome do artigo existe; se não, lança um erro.
            existsOrError(article.description, 'Descrição não informada') // Valida a descrição.
            existsOrError(article.categoryId, 'Categoria não informada') // Valida a categoria.
            existsOrError(article.userId, 'Autor não informado') // Valida o autor do artigo.
            existsOrError(article.content, 'Conteúdo não informado') // Valida o conteúdo.
        } catch(msg) { // Se ocorrer um erro na validação, captura a mensagem.
            res.status(400).send(msg) // Retorna um status 400 (Bad Request) com a mensagem de erro.
        }

        if(article.id) { // Verifica se o artigo já tem um id (significa que é uma atualização).
            app.db('articles') // Acessa a tabela 'articles' no banco de dados.
                .update(article) // Atualiza o artigo com os novos dados.
                .where({ id: article.id }) // Define a condição para atualizar apenas o artigo com o id correspondente.
                .then(_ => res.status(204).send()) // 'then' é usado para lidar com o resultado quando a operação é concluída; se a atualização for bem-sucedida, retorna um status 204 (No Content).
                .catch(err => res.status(500).send(err)) // 'catch' captura erros; se ocorrer um erro, retorna um status 500 (Internal Server Error) com o erro.
        } else { // Se não houver um id, significa que é uma inserção de um novo artigo.
            app.db('articles') // Acessa a tabela 'articles' no banco de dados.
                .insert(article) // Insere um novo artigo.
                .then(_ => res.status(204).send()) // 'then' trata o resultado da operação; se a inserção for bem-sucedida, retorna um status 204.
                .catch(err => res.status(500).send(err)) // Se ocorrer um erro, 'catch' retorna um status 500.
        }
    }

    const remove = async (req, res) => { // Define a função remove como assíncrona (async), permitindo o uso de 'await' para esperar resultados de operações assíncronas.
        try {
            const rowsDeleted = await app.db('articles') // 'await' espera que a operação de deleção na tabela 'articles' seja concluída.
                .where({ id: req.params.id }).del() // Define a condição para deletar o artigo com o id correspondente.
            
            try {
                existsOrError(rowsDeleted, 'Artigo não foi encontrado.') // Verifica se algum artigo foi deletado; se não, lança um erro.
            } catch(msg) {
                return res.status(400).send(msg) // Se não houver artigo deletado, retorna um status 400.
            }

            res.status(204).send() // Se a remoção for bem-sucedida, retorna um status 204.
        } catch(msg) {
            res.status(500).send(msg) // Se ocorrer um erro, retorna um status 500.
        }
    }

    const limit = 10 // Define um limite de 10 para paginação.
    const get = async (req, res) => { // Define a função get como assíncrona (async), permitindo o uso de 'await' dentro da função.
        const page = req.query.page || 1 // Obtém o número da página da requisição, ou usa 1 se não estiver definido.

        const result = await app.db('articles').count('id').first() // 'await' espera o resultado da contagem de artigos.
        const count = parseInt(result.count) // Converte o resultado da contagem para um número inteiro.

        app.db('articles') // Acessa a tabela 'articles'.
            .select('id', 'name', 'description') // Seleciona os campos id, name e description dos artigos.
            .limit(limit).offset(page * limit - limit) // Aplica a paginação usando limit e offset.
            .then(articles => res.json({ data: articles, count, limit })) // 'then' lida com o resultado; retorna os artigos em formato JSON se a consulta for bem-sucedida.
            .catch(err => res.status(500).send(err)) // Se ocorrer um erro, 'catch' retorna um status 500.
    }

    const getById = (req, res) => { // Define a função getById para obter um artigo específico pelo id.
        app.db('articles') // Acessa a tabela 'articles'.
            .where({ id: req.params.id }) // Define a condição para obter o artigo com o id correspondente.
            .first() // Obtém o primeiro resultado que corresponde à condição.
            .then(article => { // 'then' lida com o resultado da consulta; executa a função com o artigo retornado.
                article.content = article.content.toString() // Converte o conteúdo do artigo para string.
                return res.json(article) // Retorna o artigo em formato JSON.
            })
            .catch(err => res.status(500).send(err)) // Se ocorrer um erro, 'catch' retorna um status 500.
    }

    const getByCategory = async (req, res) => { // Define a função getByCategory como assíncrona (async).
        const categoryId = req.params.id // Obtém o id da categoria dos parâmetros da requisição.
        const page = req.query.page || 1 // Obtém o número da página da requisição, ou usa 1 se não estiver definido.
        const categories = await app.db.raw(queries.categoryWithChildren, categoryId) // 'await' espera o resultado da consulta SQL para obter categorias e suas subcategorias.
        const ids = categories.rows.map(c => c.id) // Mapeia as categorias para obter apenas os ids.

        app.db({a: 'articles', u: 'users'}) // Acessa as tabelas 'articles' e 'users' usando um alias.
            .select('a.id', 'a.name', 'a.description', 'a.imageUrl', { author: 'u.name' }) // Seleciona os campos desejados.
            .limit(limit).offset(page * limit - limit) // Aplica a paginação usando limit e offset.
            .whereRaw('?? = ??', ['u.id', 'a.userId']) // Faz uma junção entre as tabelas onde o id do usuário é igual ao userId do artigo.
            .whereIn('categoryId', ids) // Filtra os artigos pela categoria usando os ids obtidos.
            .orderBy('a.id', 'desc') // Ordena os resultados pelo id do artigo em ordem decrescente.
            .then(articles => res.json(articles)) // 'then' lida com o resultado; se a consulta for bem-sucedida, retorna os artigos em formato JSON.
            .catch(err => res.status(500).send(err)) // Se ocorrer um erro, 'catch' retorna um status 500.
    }

    return {save, remove, get, getById, getByCategory} // Retorna as funções definidas para que possam ser utilizadas fora.
}
