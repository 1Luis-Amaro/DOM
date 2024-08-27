import $ from 'jquery' // Importa a biblioteca jQuery para uso no script

import { onLoadHtmlSucces } from '../core/includes'

const duration = 300 // Define uma constante 'duration' com o valor de 600 milissegundos, que será usada para animações

function filterByCity(city){ // Declara uma função chamada 'filterByCity' que recebe um parâmetro 'city'
    $('[wm-city]').each(function(i,e){ // Seleciona todos os elementos com o atributo 'wm-city' e itera sobre eles usando a função 'each'
        const isTarget = $(this).attr('wm-city') === city // Verifica se o valor do atributo 'wm-city' do elemento atual é igual à cidade passada
            || city === null // Ou se a cidade é nula, o que significa que todos os elementos devem ser exibidos
            if(isTarget) { // Se o elemento corresponder à cidade ou se a cidade for nula
                $(this).parent().removeClass('d-none') // Remove a classe 'd-none' do elemento pai (para que fique visível)
                $(this).fadeIn(duration) // Exibe o elemento com um efeito de fade-in durante a duração especificada
            } else{ // Caso contrário, se o elemento não corresponder à cidade
                $(this).fadeOut(duration, () => { // Oculta o elemento com um efeito de fade-out durante a duração especificada
                    $(this).parent().addClass('d-none') // Após o fade-out, adiciona a classe 'd-none' ao elemento pai (para que fique oculto)
                }) 
            }
    })
}

$.fn.cityButtons = function () { // Define um método customizado 'cityButtons' para objetos jQuery
    const cities = new Set // Cria um novo Set para armazenar as cidades únicas
    $('[wm-city]').each(function(i, e){ // Itera sobre todos os elementos com o atributo 'wm-city'
        cities.add($(e).attr('wm-city')) // Adiciona o valor do atributo 'wm-city' ao Set, garantindo que as cidades sejam únicas
    })

    const btns = Array.from(cities).map(city => { // Converte o Set de cidades em um array e mapeia cada cidade para criar botões
        const btn = $('<button>') // Cria um novo botão
            .addClass(['btn', 'btn-info']).html(city) // Adiciona as classes 'btn' e 'btn-info' ao botão e define o texto como o nome da cidade
        btn.click(e => filterByCity(city)) // Adiciona um evento de clique ao botão que chama a função 'filterByCity' passando a cidade correspondente
        return btn // Retorna o botão criado
    })

    const btnAll = $('<button>') // Cria um botão adicional para mostrar todas as cidades
        .addClass(['btn','btn-info','active']).html('Todas') // Adiciona as classes 'btn', 'btn-info', e 'active' ao botão e define o texto como 'Todas'
    btnAll.click(e=> filterByCity(null)) // Adiciona um evento de clique ao botão que chama a função 'filterByCity' passando null (para mostrar todas as cidades)
    btns.push(btnAll) // Adiciona o botão "Todas" ao array de botões

    const btnGroup = $('<div>').addClass(['btn-group']) // Cria um div com a classe 'btn-group' para agrupar os botões
    btnGroup.append(btns) // Adiciona todos os botões ao grupo de botões

    $(this).html(btnGroup) // Substitui o conteúdo do elemento atual com o grupo de botões
    return this // Retorna o objeto jQuery para permitir encadeamento de métodos
}

onLoadHtmlSucces(function(){
    $('[wm-city-buttons]').cityButtons() // Chama a função 'cityButtons' em todos os elementos que têm o atributo 'wm-city-buttons'

})

