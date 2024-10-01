const express = require('express')
const app = express()
const bodyParser = require ('body-parser')
const usuarioApi = require ('./api/usuario')

require('./api/produto')(app,'com param')

app.post('/usuario', usuarioApi.salvar)
app.get('/usuario', usuarioApi.obter)


const saudacao = require('./saudacaoMid')


app.use(bodyParser.text())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extend: true }))

app.use(saudacao('Guilherme'))

app.use((req, res, next)=>{
    console.log('Antes')
    next()
})

app.get('/clientes/relatorio', (req, res) =>{
    res.send(`Cliente relatorio completo ${req.query.completo} ano = ${req.query.ano}`)
})

app.post('./corpo', (req, res) =>{
    let corpo = ''
    req.on('data', function(parte){
        corpo += parte
    })

    req.on('end', function(){
        res.send(corpo)
    })
})

app.get('/clientes/:id', (req, res, next) =>{
    res.send(`Cliente ${req.params.id} selecionado`)
})




app.get('/opa', (req, res)=>{
    res.json({
        data: [
        {id: 7, name: 'Ana', positio: 1},
        {id: 72, name: 'Bia', positio: 2},
        {id: 31, name: 'Carlos', positio: 3}
    ],
    count: 30,
    skip: 0,
    limit: 3,
    status: 200
    })
})

app.listen(3000, () =>{
    console.log('Backend executando...')
})

