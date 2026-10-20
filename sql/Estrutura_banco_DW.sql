CREATE DATABASE ClinicaDW;

USE ClinicaDW

CREATE TABLE DimData(
    id_data INT PRIMARY KEY,
    data DATE NOT NULL,
    dia INT NOT NULL,
    mes INT NOT NULL,
    nome_mes VARCHAR(20) NOT NULL, 
    trimestre INT NOT NULL,
    ano INT NOT NULL
)

CREATE TABLE DimPaciente (
    id_paciente INT PRIMARY KEY,
    nome VARCHAR(100),
    cpf VARCHAR(14),
    data_nascimento DATE
);



CREATE TABLE DimDentista (
    id_dentista INT PRIMARY KEY,
    nome VARCHAR(100),
    cro VARCHAR(20),
    id_especialidade INT
);


CREATE TABLE DimEspecialidade (
    id_especialidade INT PRIMARY KEY,
    especialidade VARCHAR(100)
);


CREATE TABLE DimProcedimento (
    id_procedimento INT PRIMARY KEY,
    procedimento VARCHAR(100),
    descricao VARCHAR(255),
    valor DECIMAL(10,2)
);



/* Uma consulta pode ter mais de um procedimento. Para evitar duplicar consultas e valores de pagamento, trataremos os procedimentos em uma tabela fato separada.*/

CREATE TABLE FatoConsulta (
    id_consulta INT PRIMARY KEY,
    id_data INT NOT NULL,
    id_paciente INT NOT NULL,
    id_dentista INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    valor_pago DECIMAL(10,2),

    FOREIGN KEY (id_data) REFERENCES DimData(id_data),
    FOREIGN KEY (id_paciente) REFERENCES DimPaciente(id_paciente),
    FOREIGN KEY (id_dentista) REFERENCES DimDentista(id_dentista)
);




/* uma consulta pode ter vários procedimentos, e um mesmo procedimento pode aparecer em várias consultas. */


-- FatoProcedimento
CREATE TABLE FatoProcedimento (
    id_consulta INT NOT NULL,
    id_procedimento INT NOT NULL,
    quantidade INT NOT NULL,
    valor_realizado DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (id_consulta, id_procedimento),

    FOREIGN KEY (id_consulta)
        REFERENCES FatoConsulta(id_consulta),

    FOREIGN KEY (id_procedimento)
        REFERENCES DimProcedimento(id_procedimento)
);




-- Carga


-- DimEspecialidade
INSERT INTO DimEspecialidade
(id_especialidade, especialidade)

SELECT 
    id_especialidade,
    especialidade
FROM Clinica.dbo.Especialidades

SELECT * FROM DimEspecialidade


-- DimDentista

INSERT INTO DimDentista
    (id_dentista, nome, cro, id_especialidade)

SELECT
    id_dentista,
    nome,
    cro,
    id_especialidade
FROM Clinica.dbo.Dentista

SELECT * FROM DimDentista


-- DimPaciente
INSERT INTO DimPaciente
    (id_paciente, nome, cpf, data_nascimento)

SELECT 
    id_paciente,
    nome,
    cpf,
    data_nascimento
FROM Clinica.dbo.Paciente;

SELECT * FROM DimPaciente



-- FacProcedimento

INSERT INTO ClinicaDW.dbo.DimProcedimento
    (id_procedimento, procedimento, descricao, valor)
SELECT
    id_procedimento,
    procedimento,
    descricao,
    valor
FROM Clinica.dbo.Procedimento;


SELECT * FROM DimProcedimento



-- DimData
/* 
CAST: converte o tipo de dado.
CONVERT: também converte o tipo e permite especificar o formato.
CHAR(8): texto com 8 caracteres.
112: formato de data AAAAMMDD.
INT: número inteiro.
*/


USE Clinica
SELECT TOP(4) * FROM Consulta


USE ClinicaDW
INSERT INTO DimData
    (id_data, data, dia, mes, nome_mes, trimestre, ano)

SELECT DISTINCT
    CONVERT(INT, CONVERT(CHAR(8), CAST(data AS DATE), 112)),
    CAST(data AS DATE),
    DAY(data),
    MONTH(data),
    DATENAME(MONTH, data),
    DATEPART(QUARTER, data),
    YEAR(data)
FROM Clinica.dbo.Consulta



SELECT * FROM DimData



-- FatoConsulta

INSERT INTO FatoConsulta 
    (id_consulta,id_data,id_paciente,id_dentista,status,valor_pago)

SELECT 
    c.id_consulta,
    d.id_data,
    c.id_paciente,
    c.id_dentista,
    c.status,
    p.valor

FROM Clinica.dbo.Consulta as c
JOIN ClinicaDW.dbo.DimData as d
    on d.data = CAST(c.data AS DATE)
LEFT JOIN Clinica.dbo.Pagamento as p      -- mantém consultas mesmo quando não há pagamento.
    on p.id_consulta = c.id_consulta

    
SELECT * FROM FatoConsulta



-- FatoProcedimento  -> copiar os dados da tabela consulta_procedimento
INSERT INTO FatoProcedimento
    (id_consulta, id_procedimento, quantidade, valor_realizado)

SELECT 
    id_consulta,
    id_procedimento,
    quantidade,
    valor_realizado
FROM Clinica.dbo.Consulta_Procedimento 


SELECT COUNT(*) as total_procedimentos
from FatoProcedimento








--- VERIRICAR DADOS 

SELECT 'DimData' AS tabela, COUNT(*) AS total FROM DimData
UNION ALL
SELECT 'DimPaciente', COUNT(*) FROM DimPaciente
UNION ALL
SELECT 'DimDentista', COUNT(*) FROM DimDentista
UNION ALL
SELECT 'DimEspecialidade', COUNT(*) FROM DimEspecialidade
UNION ALL
SELECT 'DimProcedimento', COUNT(*) FROM DimProcedimento
UNION ALL
SELECT 'FatoConsulta', COUNT(*) FROM FatoConsulta
UNION ALL
SELECT 'FatoProcedimento', COUNT(*) FROM FatoProcedimento;



SELECT COUNT(*) AS consultas_sem_data
FROM FatoConsulta f
LEFT JOIN DimData d
    ON f.id_data = d.id_data
WHERE d.id_data IS NULL;


SELECT COUNT(*) AS consultas_sem_paciente
FROM FatoConsulta f
LEFT JOIN DimPaciente p
    ON f.id_paciente = p.id_paciente
WHERE p.id_paciente IS NULL;

SELECT COUNT(*) AS consultas_sem_dentista
FROM FatoConsulta f
LEFT JOIN DimDentista d
    ON f.id_dentista = d.id_dentista
WHERE d.id_dentista IS NULL;


SELECT COUNT(*) AS procedimentos_sem_cadastro
FROM FatoProcedimento fp
LEFT JOIN DimProcedimento dp
    ON fp.id_procedimento = dp.id_procedimento
WHERE dp.id_procedimento IS NULL;