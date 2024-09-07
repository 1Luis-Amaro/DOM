export default function cliente(req, res){

    if(req.method === GET){
        handleGet(req, res)
    } else {
        res.status(405).send()
    }
}

function handleGET(){
    res.status(200).json({
        id: 3,
        nome: 'Maria',
        email: 'mariamariana@gmail.com'
    })

}