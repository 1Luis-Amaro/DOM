Um outer join pode ser Left, Rigth e Center (ou Cross).
Um left join faz uma junção entre A e B onde a projeção serão todos os elementos de A, independente se estão ou não
Quanto ao outer join força a exibição de. todos os dados das duas tabelas caso seja executado na sua.

--
-- Seção 11 
-- Exibindo dados a partir de Múltiplas Tabelas
--
-- Aula 4 - OUTER JOINS

-- LEFT OUTER JOIN

SELECT e.first_name, e.last_name, d.department_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d
     ON (e.department_id = d.department_id) 
ORDER BY d.department_id;

-- RIGHT OUTER JOIN

SELECT d.department_id, d.department_name, e.first_name, e.last_name
FROM employees e RIGHT OUTER JOIN departments d
     ON (e.department_id = d.department_id) 
ORDER BY d.department_id;

-- FULL OUTER JOIN

SELECT d.department_id, d.department_name, e.first_name, e.last_name
FROM   employees e FULL OUTER JOIN departments d
     ON (e.department_id = d.department_id) 
ORDER BY d.department_id;


