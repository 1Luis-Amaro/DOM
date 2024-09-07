import React, { Component } from "react"; // Importa a biblioteca React e a classe Component para criar componentes de classe
import axios from 'axios'; // Importa a biblioteca axios para fazer requisições HTTP
import Main from "../template/Main"; // Importa o componente Main, que provavelmente é um layout padrão

const headrProps = { // Define as propriedades para o cabeçalho da página
    icon: 'users', // Define o ícone a ser exibido
    title: 'Usuários', // Define o título da página
    subtitle: 'Cadastro de usuários: Incluir, Listar, Alterar e Excluir!' // Define o subtítulo da página
};

const baseUrl = 'http://localhost:3001/users'; // Define a URL base da API de usuários
const initialState = { // Define o estado inicial do componente
    user: {name: '', email: ''}, // Define um objeto user com campos vazios
    list: [] // Inicializa uma lista vazia para armazenar os usuários
};

export default class UserCrud extends Component { // Cria e exporta o componente de classe UserCrud

    state = {...initialState}; // Inicializa o estado do componente com o estado inicial definido anteriormente

    componentDidMount(){ // Método do ciclo de vida que é chamado após o componente ser montado
        axios(baseUrl).then(resp => { // Faz uma requisição GET à API para obter a lista de usuários
            this.setState({list: resp.data}); // Atualiza o estado com a lista de usuários obtida da API
        });
    }

    clear() { // Método para limpar o formulário
        this.setState({user: initialState.user}); // Reseta o objeto user no estado para os valores iniciais (vazios)
    }

    save() { // Método para salvar um usuário (criar ou atualizar)
        const user = this.state.user; // Obtém o usuário atual do estado
        const method = user.id ? 'put' : 'post'; // Define o método HTTP (PUT para atualizar, POST para criar)
        const url = user.id ? `${baseUrl}/${user.id}` : baseUrl; // Define a URL para a requisição (inclui o ID se for PUT)
        axios[method](url, user) // Faz a requisição HTTP com o método e a URL apropriados
            .then(resp => { // Quando a resposta for recebida
                const list = this.getUpdatedList(resp.data); // Atualiza a lista com o usuário salvo
                this.setState({user: initialState.user, list}); // Reseta o formulário e atualiza a lista no estado
            });
    }

    getUpdatedList(user, add = true){ // Método para obter a lista atualizada de usuários
        const list = this.state.list.filter(u => u.id !== user.id); // Remove o usuário da lista pelo ID
        if (add) list.unshift(user); // Se 'add' for verdadeiro, adiciona o usuário ao início da lista
        return list; // Retorna a lista atualizada
    }

    updateField(event) { // Método para atualizar o campo do formulário com os valores inseridos pelo usuário
        const user = {...this.state.user}; // Cria uma cópia do objeto user do estado
        user[event.target.name] = event.target.value; // Atualiza o campo apropriado com o valor do input
        this.setState({user}); // Atualiza o estado com o novo valor do user
    }

    renderForm(){ // Método para renderizar o formulário de usuário
        return(
            <div className="form"> {/* Div que contém o formulário */}
                <div className="row"> {/* Linha do formulário */}
                    <div className="col-12 col-md-6"> {/* Coluna que ocupa 6 espaços em telas médias e 12 em telas pequenas */}
                        <div className="form-group"> {/* Agrupamento do input do nome */}
                            <label >Nome</label> {/* Rótulo do input de nome */}
                            <input type="text" className="form-control" 
                            name="name" // Define o nome do input
                            value={this.state.user.name} // Define o valor do input como o nome do usuário no estado
                            onChange={e => this.updateField(e)} // Chama o método updateField quando o valor do input mudar
                            placeholder="Digite o nome..."/> {/* Placeholder para o input de nome */}
                        </div>
                    </div>

                    <div className="col-12 col-md-6"> {/* Coluna que ocupa 6 espaços em telas médias e 12 em telas pequenas */}
                        <div className="form-group"> {/* Agrupamento do input do e-mail */}
                            <label>E-mail</label> {/* Rótulo do input de e-mail */}
                            <input type="text" className="form-control" 
                            name="email" // Define o nome do input
                            value={this.state.user.email} // Define o valor do input como o e-mail do usuário no estado
                            onChange={e => this.updateField(e)} // Chama o método updateField quando o valor do input mudar
                            placeholder="Digite o e-mail"/> {/* Placeholder para o input de e-mail */}
                        </div>
                    </div>
                </div>

                <hr/> {/* Linha horizontal para separar o formulário dos botões */}
                <div className="row"> {/* Linha para os botões */}
                    <div className="col-12 d-flex justify-content-end"> {/* Coluna que alinha os botões à direita */}
                        <button className="btn btn-primary"
                        onClick={e => this.save(e)}> {/* Botão de salvar que chama o método save */}
                            Salvar
                        </button>

                        <button className="btn btn-secondary ml-2"
                        onClick={e => this.clear(e)}> {/* Botão de cancelar que chama o método clear */}
                            Cancelar
                        </button>
                    </div>
                </div>
            </div>
        );
    }

    load(user) { // Método para carregar um usuário para edição
        this.setState({user}); // Atualiza o estado com o usuário selecionado
    }

    remove(user){ // Método para remover um usuário
        axios.delete(`${baseUrl}/${user.id}`).then(resp => { // Faz uma requisição DELETE à API para remover o usuário
            const list = this.state.list.filter(u => u.id !== user.id); // Atualiza a lista no estado removendo o usuário pelo ID
            this.setState({list}); // Atualiza o estado com a nova lista
        });
    }
    
    renderTable(){ // Método para renderizar a tabela de usuários
        return (
            <table className="table mt-4"> {/* Tabela com margem superior */}
                <thead> {/* Cabeçalho da tabela */}
                    <tr>
                        <th>ID</th> {/* Cabeçalho da coluna ID */}
                        <th>Nome</th> {/* Cabeçalho da coluna Nome */}
                        <th>E-mail</th> {/* Cabeçalho da coluna E-mail */}
                        <th>Ações</th> {/* Cabeçalho da coluna Ações */}
                    </tr>
                </thead>

                <tbody> {/* Corpo da tabela */}
                    {this.renderRows()} {/* Chama o método renderRows para renderizar as linhas */}
                </tbody>
            </table>
        );
    }

    renderRows() { // Método para renderizar as linhas da tabela
        return this.state.list.map(user => { // Mapeia cada usuário na lista para uma linha da tabela
            return (
                <tr key={user.id}> {/* Define a linha com uma chave única baseada no ID do usuário */}
                    <td>{user.id}</td> {/* Exibe o ID do usuário */}
                    <td>{user.name}</td> {/* Exibe o nome do usuário */}
                    <td>{user.email}</td> {/* Exibe o e-mail do usuário */}
                    <td> {/* Coluna para as ações */}
                        <button className="btn btn-warning"
                            onClick={() => this.load(user)}> {/* Botão de editar que carrega o usuário */}
                            <i className="fa fa-pencil"></i> {/* Ícone de lápis (edição) */}
                        </button>
                        <button className="btn btn-danger ml-2"
                            onClick={() => this.remove(user)}> {/* Botão de remover que chama o método remove */}
                            <i className="fa fa-trash"></i> {/* Ícone de lixo (remoção) */}
                        </button>
                    </td>
                </tr>
            );
        });
    }
    
    render() { // Método principal para renderizar o componente
        return (
            <Main {...headrProps}> {/* Renderiza o componente Main com as propriedades do cabeçalho */}
               {this.renderForm()} {/* Renderiza o formulário de usuário */}
               {this.renderTable()} {/* Renderiza a tabela de usuários */}
            </Main>
        );
    }
}
