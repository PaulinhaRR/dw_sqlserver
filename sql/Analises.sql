



-- 1. Liste o nome, CPF e telefone de todos os pacientes.

SELECT * FROM Paciente



-- 2. Liste todos os procedimentos mostrando:

SELECT * FROM Procedimento


-- 3. Liste somente as consultas que foram Realizadas.
SELECT * FROM Consulta
where status= 'Realizada' 



-- 4. Liste os procedimentos com valor maior que R$ 500.
SELECT  * FROM Procedimento
WHERE valor > 500 


-- 5. Mostre as consultas realizadas com: nome do paciente, nome do dentista, data da consultta

SELECT 
	p.nome AS 'Paciente',
	d.nome AS 'Dentista',
	c.data AS 'DATA_CONSULTA',
	c.status AS 'Status'

FROM Consulta c
JOIN Paciente p
	on c.id_paciente = p.id_paciente
	join Dentista d
		on c.id_dentista = d.id_dentista

WHERE status = 'Realizada'




-- 6. Mostre os dentistas e suas respectivas especialidades.
SELECT 
	d.nome AS 'Dentista',
	e.especialidade AS 'especidalidade'

FROM Dentista d
join Especialidades e
on d.id_especialidade = e.id_especialidade


-- 7. Quantas consultas foram realizadas por dentista?

SELECT
	d.nome AS 'Dentista',
	COUNT(id_consulta) AS 'QTD Consultas'

	
FROM Consulta c
join dentista d
on c.id_dentista = d.id_dentista
where c.status = 'Realizada'
group by d.nome


-- 8. Qual procedimento foi realizado mais vezes?
SELECT
	COUNT(cp.id_procedimento) AS 'QTD Procedimentos',
	p.procedimento AS 'Procedimento',
	p.descricao AS 'Descricao'

FROM Consulta_Procedimento cp
join Procedimento p
on cp.id_procedimento = p.id_procedimento
GROUP BY p.procedimento, p.descricao
ORDER BY [QTD Procedimentos]






-- 9. Qual foi o faturamento total da clínica?
SELECT  
	SUM(valor) AS 'TOTAL FATURAMENTO'

FROM Pagamento


-- 10. Qual foi o faturamento por forma de pagamento?
SELECT  
	forma_pagamento AS 'Forma_Pgto',
	SUM(valor) AS 'Total'
	

FROM Pagamento
GROUP BY forma_pagamento


-- 11. Quero saber qual dentista gerou o maior faturamento.
SELECT 
	d.nome AS 'DENTISTA',
	SUM(valor) AS 'TOTAL'

FROM Dentista d
JOin Consulta c
on d.id_dentista = c.id_dentista
JOIN Pagamento p
on c.id_consulta = p.id_consulta

group by d.nome
order by TOTAL DESC 

 







 ---------ANÁLISE CLINICA_DW


 /*
Qual foi o faturamento total da clínica?
Qual procedimento foi mais realizado?
Qual dentista realizou mais consultas?
Como o faturamento varia por mês?

*/


-- Faturamento total da Clínica
SELECT
	
	SUM(valor_pago)  AS 'Total_Faturamento'
FROM FatoConsulta



--- Faturamento por mês
SELECT 
	SUM(c.valor_pago) AS 'Total_Faturamento',
	d.mes AS 'Mês',
	d.ano AS 'Ano'

FROM FatoConsulta c
JOIN DimData d
	on c.id_data = d.id_data
GROUP BY mes,ano 
ORDER BY d.ano DESC, d.mes ASC;



-- Faturamento por dentista

SELECT
	d.nome AS 'Dentista',
	d.cro AS 'CRO',
	e.especialidade AS 'Especialidade',
	SUM(c.valor_pago) AS 'Faturamento'

FROM Fatoconsulta c
JOIN DimDentista d 
	on c.id_dentista = d.id_dentista
JOIN DimEspecialidade e
	on d.id_especialidade = e.id_especialidade
GROUP BY d.nome, d.cro, e.especialidade
ORDER BY Faturamento DESC



-- Procedimentos mais realizados
SELECT 
	SUM(p.quantidade) AS 'QTd_Procedimento',
	dp.procedimento AS 'Procedimento'

FROM FatoProcedimento p
JOIN DimProcedimento dp
ON p.id_procedimento = dp.id_procedimento
GROUP BY Procedimento
ORDER BY QTd_Procedimento DESC



-- Faturamento total de cada Procedimento

SELECT 
	SUM(p.valor_realizado) AS 'Faturamento',
	dp.procedimento AS 'Procedimento'

FROM FatoProcedimento p
JOIN DimProcedimento dp
ON p.id_procedimento = dp.id_procedimento
GROUP BY Procedimento
ORDER BY Faturamento DESC
	


	



