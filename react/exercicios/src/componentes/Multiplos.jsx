import React from 'react'

const BoaTarde = props => <h1>Boa tarde {props.nome}</h1>
const BoaNoite = props => <h1>Boa noite {props.nome}</h1>

//export const BoaNoite = props => <h1>Boa noite {props.nome}</h1> //posso exportar dessa forma como em vez de colocar um const colocar um default

export {BoaTarde, BoaNoite}// posso exportar assim também, deixando apenas const e exportando depois
export default {BoaTarde, BoaNoite}//outra forma de exportar mais de um componente 