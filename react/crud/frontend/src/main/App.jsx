import 'bootstrap/dist/css/bootstrap.min.css'; // Importa o arquivo CSS do Bootstrap para estilizar a aplicação
import 'font-awesome/css/font-awesome.min.css'; // Importa o arquivo CSS do Font Awesome para usar ícones na aplicação
import './App.css'; // Importa o arquivo CSS específico da aplicação, onde estão os estilos personalizados

import React from 'react'; // Importa a biblioteca React, necessária para criar componentes
import { BrowserRouter } from 'react-router-dom'; // Importa o BrowserRouter do react-router-dom, usado para gerenciar as rotas da aplicação

import Logo from '../components/template/Logo'; // Importa o componente Logo, que exibe o logotipo da aplicação
import Nav from '../components/template/Nav'; // Importa o componente Nav, que representa a barra de navegação
import Routes from './Routes'; // Importa o componente Routes, onde estão definidas as rotas da aplicação
import Footer from '../components/template/Footer'; // Importa o componente Footer, que representa o rodapé da aplicação

export default props => // Exporta uma função que renderiza a estrutura da aplicação
    <BrowserRouter> {/* Envolve a aplicação com o BrowserRouter para habilitar o gerenciamento de rotas */}
        <div className="app"> {/* Define um contêiner div com a classe "app", que pode ser usada para aplicar estilos específicos */}
            <Logo /> {/* Renderiza o componente Logo na aplicação */}
            <Nav /> {/* Renderiza o componente Nav (barra de navegação) na aplicação */}
            <Routes /> {/* Renderiza o componente Routes, que contém as rotas da aplicação */}
            <Footer /> {/* Renderiza o componente Footer (rodapé) na aplicação */}
        </div>
    </BrowserRouter>; {/* Finaliza o BrowserRouter, que está gerenciando a navegação dentro da aplicação */}
