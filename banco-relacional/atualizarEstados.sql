update estados
set nome = 'Maranhãooo'
where sigla = 'MA';

update estados
set nome = 'Paraná', populacao = 11.32
    where sigla = 'PR';

select nome from estados 
where sigla = 'PR'