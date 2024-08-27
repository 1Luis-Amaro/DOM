import React, { Component } from "react";
import axios from 'axios'
import Main from "../template/Main";

const headrProps = {
    icon: 'users',
    title: 'Usuários',
    subtitle: 'Cadastro de usuários: Incluir, Listar, Alterar e Excluir!'
}

const baseUrl = 'http:localhost:3001/users'
const initialSate = {
    user: {name: '', email: ''},
    list: []
}

export default class UserCrud extends Component {
    render() {
        return (
            <Main {...headrProps}>
                Cadastro de Usuário s
            </Main>
        )
    }
}