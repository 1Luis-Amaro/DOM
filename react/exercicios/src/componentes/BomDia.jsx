import React from "react"

export default props => [
    <h1 key='h1'>Bom dia {props.nome}!</h1>,
    <h2 key='h2'>Até breve meu amigo!</h2>
]



//React.Fragment serve de tag que evolve meus elementos internos, como se fosse uma div, mas ele não é renderizado 
//no html, então se eu inspencionar nao aparece nada, ou posso importar o Fragment e usar sem o react 

//export default props => 
//<React.Fragment> 
//<h1>bom dia {props.nome}!</h1>
//<h2>Até breve</h2>
//</React.Fragment>