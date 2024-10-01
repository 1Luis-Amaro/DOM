    --as renomeia o nome da coluna, no banco oracle colo "", ou so coloco um nome mesmo
    select sigla, nome as 'Nome do Estado' from estados
    where populacao >= 10
    order by populacao desc