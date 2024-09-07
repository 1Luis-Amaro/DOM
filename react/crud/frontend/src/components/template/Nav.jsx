// Nav.js
import './Nav.css' // Importa o arquivo CSS para estilizar o menu
import React from "react"; // Importa a biblioteca React, necessária para usar JSX e criar componentes funcionais
import NavItems from './NavItems'; // Importa o componente NavItems para reutilização

export default props => (
    <aside className="menu-area"> {/* Cria um elemento <aside> com a classe CSS "menu-area", usado para agrupar o menu de navegação */}
        
        <NavItems 
            icon1="home" option1="Início"  // Passa as propriedades icon1, option1, e href1 para o primeiro link
            icon2="user" option2="Usuários"  // Passa as propriedades icon2, option2, e href2 para o segundo link
        />

    </aside> /* Fecha o elemento <aside> */
);
