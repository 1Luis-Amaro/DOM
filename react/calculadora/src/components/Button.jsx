import React from "react";
import './Button.css'

export default props => { //se a propriedade tiver definida eu coloca a classe operation senão eu não coloco nada '' linh 7
  
    let classes = 'button '
    classes += props.operation ? 'operation' : ''    
    classes += props.double ? 'double' : ''    
    classes += props.triple ? 'triple' : ''
    
    return (
        <button
            onClick={e => props.click && props.click(props.label)}
            className={classes}>
            {props.label}
            </button>
            
        )
    }
