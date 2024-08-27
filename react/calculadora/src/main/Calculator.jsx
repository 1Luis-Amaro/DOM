import React, { Component } from 'react' /* Importa o React e o componente base 'Component' para criar a classe do componente. */

import './Calculator.css'  //Importa o arquivo CSS específico para estilizar o componente Calculator. */

import Button from '../components/Button' ///* Importa o componente 'Button' de outro arquivo para ser utilizado na calculadora. */

import Display from '../components/Display' /* Importa o componente 'Display' de outro arquivo para mostrar os valores na calculadora. */

const initialState = { /* Define o estado inicial da calculadora, armazenando os valores e a operação corrente. */
    displayValue: '0', /* Valor inicial mostrado no display da calculadora. */
    clearDisplay: false, /* Indica se o display deve ser limpo no próximo dígito. */
    operation: null, /* Operação atual (ex: +, -, *, /). */
    values: [0, 0], /* Array que guarda os dois valores que serão usados na operação. */
    current: 0 /* Índice que indica qual dos dois valores está sendo digitado (0 ou 1). */
}

export default class Calculator extends Component { /* Define e exporta a classe Calculator, que é um componente React. */

    state = { ...initialState } /* Inicializa o estado do componente com uma cópia do estado inicial definido acima. */

    constructor(props) { /* Construtor do componente. */
        super(props) /* Chama o construtor da classe pai (Component) para inicializar o componente. */

        this.clearMemory = this.clearMemory.bind(this) /* Liga o método 'clearMemory' ao contexto da classe. */
        this.setOperation = this.setOperation.bind(this) /* Liga o método 'setOperation' ao contexto da classe. */
        this.addDigit = this.addDigit.bind(this) /* Liga o método 'addDigit' ao contexto da classe. */
    }

    clearMemory() { /* Método para limpar a memória da calculadora. */
        this.setState({ ...initialState }) /* Restaura o estado da calculadora para o estado inicial, essencialmente limpando-a. */
    }

    setOperation(operation) { /* Método para definir a operação matemática. */
        if (this.state.current === 0) { /* Se estiver digitando o primeiro número. */
            this.setState({ operation, current: 1, clearDisplay: true }) /* Define a operação, muda para o segundo número e indica para limpar o display. */
        } else { /* Se estiver digitando o segundo número e precisa calcular o resultado. */
            const equals = operation === '=' /* Verifica se a operação é '=' para calcular o resultado. */
            const currentOperation = this.state.operation /* Obtém a operação atual armazenada no estado. */

            const values = [...this.state.values] /* Cria uma cópia dos valores atuais do estado. */
            try {
                values[0] = eval(`${values[0]} ${currentOperation} ${values[1]}`) //* Avalia a expressão matemática e atualiza o primeiro valor com o resultado. */
                if (isNaN(values[0]) || !isFinite(values[0])){
                    this.clearMemory()
                }
            } catch(e) {
                values[0] = this.state.values[0] /* Se houver um erro na avaliação, mantém o valor original. */
            }

            values[1] = 0 /* Reseta o segundo valor para 0. */

            this.setState({ /* Atualiza o estado com os novos valores e configurações. */
                displayValue: values[0], /* Atualiza o valor mostrado no display. */
                operation: equals ? null : operation, /* Se a operação for '=', limpa a operação; senão, define a nova operação. */
                current: equals ? 0 : 1, /* Se a operação for '=', volta para o primeiro número; senão, permanece no segundo. */
                clearDisplay: !equals, /* Limpa o display se a operação não for '='. */
                values /* Atualiza o array de valores no estado. */
            })
        }
    }

    addDigit(n) { /* Método para adicionar um dígito ao display. */
        if (n === '.' && this.state.displayValue.includes('.')) { /* Se o dígito for '.' e já houver um '.' no display. */
            return /* Ignora a adição para evitar múltiplos pontos decimais. */
        }

        const clearDisplay = this.state.displayValue === '0' || this.state.clearDisplay /* Determina se o display deve ser limpo antes de adicionar o dígito. */
        const currentValue = clearDisplay ? '' : this.state.displayValue /* Define o valor atual a ser mostrado no display. */
        const displayValue = currentValue + n /* Concatena o novo dígito ao valor atual do display. */
        this.setState({ displayValue, clearDisplay: false }) /* Atualiza o estado com o novo valor do display e indica para não limpar no próximo dígito. */

        if (n !== '.') { /* Se o dígito não for um ponto decimal. */
            const i = this.state.current /* Obtém o índice atual (0 ou 1) do valor a ser atualizado. */
            const newValue = parseFloat(displayValue) /* Converte o valor do display para um número. */
            const values = [...this.state.values] /* Cria uma cópia do array de valores do estado. */
            values[i] = newValue /* Atualiza o valor no índice atual com o novo número. */
            this.setState({ values }) /* Atualiza o estado com o novo array de valores. */
            console.log(values) /* Exibe no console os valores atuais (para depuração). */
        }
    }

    render() { /* Método de renderização do componente. */
        return (
            <div className="calculator"> {/* Elemento principal da calculadora com classe 'calculator'. */}
                <Display value={this.state.displayValue} /> {/* Renderiza o componente Display com o valor atual do display. */}
                <Button label="AC" click={this.clearMemory} triple /> {/* Botão 'AC' para limpar a memória, com estilo 'triple'. */}
                <Button label="/" click={this.setOperation} operation /> 
                <Button label="7" click={this.addDigit} />
                <Button label="8" click={this.addDigit} /> 
                <Button label="9" click={this.addDigit} /> 
                <Button label="*" click={this.setOperation} operation /> 
                <Button label="4" click={this.addDigit} /> 
                <Button label="5" click={this.addDigit} /> 
                <Button label="6" click={this.addDigit} /> 
                <Button label="-" click={this.setOperation} operation /> 
                <Button label="1" click={this.addDigit} /> 
                <Button label="2" click={this.addDigit} />
                <Button label="3" click={this.addDigit} /> 
                <Button label="+" click={this.setOperation} operation />
                <Button label="0" click={this.addDigit} double /> 
                <Button label="." click={this.addDigit} /> 
                <Button label="=" click={this.setOperation} operation /> 
            </div>
        )
    }
}
