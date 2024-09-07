// NavItems.js
import React from "react"; // Importa a biblioteca React, necessária para usar JSX e criar componentes funcionais
import { Link } from "react-router-dom";

export default props => ( // Exporta um componente funcional que recebe "props" como argumento
  <nav className="menu"> {/* Cria um elemento <nav> com a classe CSS "menu" */}
    <Link to = "/"> {/* Cria um link <a> usando o valor de "props.href1" como o atributo href */}
      <i className={`fa fa-${props.icon1}`}></i> {props.option1} {/* Insere um ícone <i> usando "props.icon1" para definir a classe do ícone, seguido do texto de "props.option1" */}
    </Link>

    <Link to="/users"> {/* Cria um segundo link <a> usando o valor de "props.href2" como o atributo href */}
      <i className={`fa fa-${props.icon2}`}></i> {props.option2} {/* Insere outro ícone <i> usando "props.icon2" para definir a classe do ícone, seguido do texto de "props.option2" */}
    </Link>
  </nav>  /* Fecha o elemento <nav> */
);
