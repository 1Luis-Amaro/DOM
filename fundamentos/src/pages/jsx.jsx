import Layout from "../components/Layout"

export default function Jsx() {
    const titulo = <h1>JSX é um conceito Central</h1>

    function subtitulo() {
        return <h2>{'muito legal'.toUpperCase()}</h2>
    }

    return (
        <Layout>
            <div>
                {titulo}
                {subtitulo()}
                <p>
                    {JSON.stringify({ nome: 'Luis', idade: "20" })}
                </p>
            </div>
        </Layout>
    )
}