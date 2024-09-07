import React from "react"
export function childrenWithProps(props){
    return React.Children.map(props.children, child =>{
         return React.cloneElement(child,{//com o cloneElement consigo clonar um elemento e colocar mais coisas nele 
     ...props, ...child.props //estou pegando todas propriedades do pai, mais as minhas, então uso o meu nome e o sobrenome do pai
   })
 })
 }