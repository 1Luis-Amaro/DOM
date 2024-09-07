import $ from 'jquery'

const loadHtmlSuccessCallbacks = []

export function onLoadHtmlSucces(callback) {
    if(!loadHtmlSuccessCallbacks.includes(callback)){
        loadHtmlSuccessCallbacks.push(callback)
    }
}

function loadIncludes(parent){
    if(!parent) parent = 'body' // se o parametro parent vir vazio o parent sera o body
    $(parent).find('[wm-include]').each(function(i, e){ //find procure dentro do parent, todos elementos que possuem a propriedade wm-include
        const url = $(e).attr('wm-include') //econtre o atributo atrr dentro do elemento $(e)
        $.ajax({
            url,
            success(data){ //se a função for bem sucedida
                $(e).html(data)//pega o elemento atual e seta os dados data dentro do html
                $(e).removeAttr('wm-include') //removendo evita com que este attr seja processado mais de uma vez

                loadHtmlSuccessCallbacks.forEach(callback => callback (data))
                loadIncludes(e)//funcao recursiva para pegar todos os includes dentro da pagina 
            }
        })
    })
}

loadIncludes()