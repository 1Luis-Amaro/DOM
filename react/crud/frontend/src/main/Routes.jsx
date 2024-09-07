import React from 'react'; // Importa a biblioteca React, necessária para criar componentes
import { Routes, Route } from "react-router-dom"; // Importa as funções Routes e Route para definir as rotas da aplicação

import Home from '../components/home/Home'; // Importa o componente Home, que será renderizado na rota principal
import UserCrud from '../components/user/UserCrud'; // Importa o componente UserCrud, que será renderizado na rota de usuários

export default props => // Exporta uma função que renderiza as rotas definidas
    <Routes> {/* Define um conjunto de rotas para a aplicação */}
        <Route exact path="/" element={<Home />} /> {/* Rota para a página inicial ("/"), renderiza o componente Home */}
        {/* O exact significa que esta rota só será usada quando o caminho for exatamente "/" */}
        {/* Sem o exact, caminhos como "/users" também poderiam corresponder à rota "/" */}
        <Route path="/users/" element={<UserCrud />} /> {/* Rota para "/users", renderiza o componente UserCrud */}
        <Route path="*" element={<Home />} /> {/* Rota curinga para qualquer caminho não definido ("*"), renderiza o componente Home */}
        {/* Isso garante que, se o usuário tentar acessar uma rota que não existe, ele será redirecionado para a página inicial */}
    </Routes>;
