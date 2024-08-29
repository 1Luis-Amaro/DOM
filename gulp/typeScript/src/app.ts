<<<<<<< HEAD
import { Carro, Vendavel } from './produto'

function exibir(v: Vendavel) {
    console.log(`${v.nome} custa ${v.preco}!`)
}

const c = new Carro
c.nome = 'Civic'
c.preco = 89499.00
=======
import { Carro, Vendavel } from './produto'

function exibir(v: Vendavel) {
    console.log(`${v.nome} custa ${v.preco}!`)
}

const c = new Carro
c.nome = 'Civic'
c.preco = 89499.00
>>>>>>> ec2fe0ed0a0234e021dd53c74b9bd62ec07f1f0f
exibir(c)