
/* DELETE FROM Pagamento;
DELETE FROM Consulta_Procedimento;
DELETE FROM Consulta;
DELETE FROM Procedimento;
DELETE FROM Dentista;
DELETE FROM Paciente;
DELETE FROM Especialidade; */






-- Criando banco
CREATE DATABASE Clinica

USE Clinica


-- TABELAS:


-- Especialidades
CREATE TABLE Especialidades (
 id_especialidade  INT IDENTITY (1,1) PRIMARY KEY,
 especialidade VARCHAR(100) NOT NULL
 )



SELECT * FROM Especialidades


-- Paciente

CREATE TABLE Paciente(
	id_paciente INT IDENTITY(1,1) PRIMARY KEY,
	nome VARCHAR(150) NOT NULL,
	cpf CHAR(11) NOT NULL UNIQUE,
	data_nascimento DATE NOT NULL,
	telefone VARCHAR(20),
	email VARCHAR(150)


)


-- Dentista
CREATE TABLE Dentista(
	id_dentista  INT IDENTITY(1,1) PRIMARY KEY,
	nome VARCHAR(150) NOT NULL,
	cro VARCHAR(20) NOT NULL UNIQUE,
	id_especialidade INT NOT  NULL,

	CONSTRAINT FK_Dentista_Especialidade
		FOREIGN KEY(id_especialidade)
		REFERENCES Especialidades(id_especialidade)

);



-- Procedimentto
CREATE TABLE Procedimento(
	id_procedimento INT IDENTITY(1,1) PRIMARY KEY,
	procedimento VARCHAR(150) NOT NULL,
	descricao VARCHAR(500),
	valor DECIMAL(10,2) NOT NULL

)


-- Consulta
CREATE TABLE Consulta(
	id_consulta INT IDENTITY(1,1) PRIMARY KEY,
	id_paciente INT NOT NULL,
	id_dentista INT NOT NULL,
	data DATETIME2 NOT NULL,
    status VARCHAR(20) NOT NULL


	CONSTRAINT FK_Consulta_Paciente
		FOREIGN KEY (id_paciente)
		REFERENCES Paciente(id_paciente),



	CONSTRAINT FK_Consulta_Dentista
		FOREIGN KEY (id_dentista)
		REFERENCES Dentista(id_dentista)

)




--- Consulta_Procedimento
CREATE TABLE Consulta_Procedimento (
    id_consulta INT NOT NULL,
    id_procedimento INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    valor_realizado DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_Consulta_Procedimento
        PRIMARY KEY (id_consulta, id_procedimento),

    CONSTRAINT FK_Consulta_Procedimento_Consulta
        FOREIGN KEY (id_consulta)
        REFERENCES Consulta(id_consulta),

    CONSTRAINT FK_Consulta_Procedimento_Procedimento
        FOREIGN KEY (id_procedimento)
        REFERENCES Procedimento(id_procedimento)
);



-- pagamento
CREATE TABLE Pagamento (
    id_pagamento INT IDENTITY(1,1) PRIMARY KEY,
    id_consulta INT NOT NULL,
    data_pagamento DATETIME2,
    valor DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Pagamento_Consulta
        FOREIGN KEY (id_consulta)
        REFERENCES Consulta(id_consulta)
);


SELECT
    fk.name AS nome_fk,
    OBJECT_NAME(fk.parent_object_id) AS tabela_origem,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS coluna_origem,
    OBJECT_NAME(fk.referenced_object_id) AS tabela_referenciada,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS coluna_referenciada
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
ORDER BY tabela_origem;




-- POPULANDO O BANCO


-- Especialidade
INSERT INTO EspecialidadeS (especialidade)
VALUES
    ('Ortodontia'),
    ('Endodontia'),
    ('Implantodontia'),
    ('Periodontia'),
    ('Odontopediatria'),
    ('Clínica Geral');

-- Paciente:
    INSERT INTO Paciente
    (nome, cpf, data_nascimento, telefone, email)
SELECT
    CONCAT('Paciente ', n),
    RIGHT('00000000000' + CAST(10000000000 + n AS VARCHAR(11)), 11),
    DATEADD(
        DAY,
        -((18 * 365) + (n * 37)),
        CAST('2026-01-01' AS DATE)
    ),
    CONCAT('1699', RIGHT('00000000' + CAST(n AS VARCHAR(8)), 8)),
    CONCAT('paciente', n, '@email.com')
FROM (
    SELECT TOP 100
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
) AS Numeros;



SELECT *
FROM Paciente
ORDER BY id_paciente;



-- Dentista
INSERT INTO Dentista
    (nome, cro, id_especialidade)
VALUES
    ('Marcos Almeida', 'CRO-SP-10001', 1),
    ('Juliana Martins', 'CRO-SP-10002', 1),
    ('Ricardo Ferreira', 'CRO-SP-10003', 1),
    ('Patricia Gomes', 'CRO-SP-10004', 2),
    ('Eduardo Ribeiro', 'CRO-SP-10005', 2),
    ('Camila Souza', 'CRO-SP-10006', 3),
    ('Felipe Oliveira', 'CRO-SP-10007', 3),
    ('Renata Lima', 'CRO-SP-10008', 3),
    ('Bruno Costa', 'CRO-SP-10009', 4),
    ('Amanda Santos', 'CRO-SP-10010', 4),
    ('Daniela Rocha', 'CRO-SP-10011', 5),
    ('Lucas Mendes', 'CRO-SP-10012', 5),
    ('Carolina Alves', 'CRO-SP-10013', 6),
    ('Thiago Pereira', 'CRO-SP-10014', 6),
    ('Fernanda Carvalho', 'CRO-SP-10015', 6);



-- consulta
INSERT INTO Consulta
    (id_paciente, id_dentista, data, status)
SELECT TOP 500
    ((n - 1) % 100) + 1 AS id_paciente,
    ((n - 1) % 15) + 1 AS id_dentista,
    DATEADD(
        MINUTE,
        (n % 20) * 30,
        DATEADD(
            DAY,
            -((n * 2) % 600),
            CAST('2026-10-08' AS DATETIME2)
        )
    ) AS data,
    CASE
        WHEN n % 10 IN (0, 1) THEN 'Cancelada'
        WHEN n % 10 = 2 THEN 'Faltou'
        WHEN n % 10 IN (3, 4) THEN 'Agendada'
        ELSE 'Realizada'
    END AS status
FROM (
    SELECT TOP 500
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
) AS Numeros;



-- Procedimento
INSERT INTO Procedimento
    (procedimento, descricao, valor)
VALUES
    ('Limpeza', 'Limpeza e profilaxia dental', 150.00),
    ('Restauração', 'Restauração de dente', 200.00),
    ('Clareamento', 'Clareamento dental', 800.00),
    ('Tratamento de Canal', 'Tratamento endodôntico', 900.00),
    ('Implante', 'Implante dentário', 2500.00),
    ('Avaliação Odontológica', 'Consulta de avaliação', 100.00),
    ('Extração', 'Extração dentária', 300.00);



-- Consulta_Procedimento
INSERT INTO Consulta_Procedimento
    (id_consulta, id_procedimento, quantidade, valor_realizado)
SELECT
    c.id_consulta,
    p.id_procedimento,
    1,
    p.valor
FROM Consulta c
INNER JOIN Procedimento p
    ON p.id_procedimento = ((c.id_consulta - 1) % 7) + 1
WHERE c.status = 'Realizada';




-- Pagamento
INSERT INTO Pagamento
    (id_consulta, data_pagamento, valor, forma_pagamento, status)
SELECT
    cp.id_consulta,
    DATEADD(DAY, 1, c.data) AS data_pagamento,
    SUM(cp.quantidade * cp.valor_realizado) AS valor,
    CASE
        WHEN c.id_consulta % 4 = 0 THEN 'Pix'
        WHEN c.id_consulta % 4 = 1 THEN 'Cartão de Crédito'
        WHEN c.id_consulta % 4 = 2 THEN 'Cartão de Débito'
        ELSE 'Dinheiro'
    END AS forma_pagamento,
    'Pago' AS status
FROM Consulta_Procedimento cp
INNER JOIN Consulta c
    ON c.id_consulta = cp.id_consulta
GROUP BY
    cp.id_consulta,
    c.data,
    c.id_consulta;





SELECT 'Especialidades' AS tabela, COUNT(*) AS quantidade FROM Especialidades
UNION ALL
SELECT 'Paciente', COUNT(*) FROM Paciente
UNION ALL
SELECT 'Dentista', COUNT(*) FROM Dentista
UNION ALL
SELECT 'Procedimento', COUNT(*) FROM Procedimento
UNION ALL
SELECT 'Consulta', COUNT(*) FROM Consulta
UNION ALL
SELECT 'Consulta_Procedimento', COUNT(*) FROM Consulta_Procedimento
UNION ALL
SELECT 'Pagamento', COUNT(*) FROM Pagamento;

















--- mais um pouco de dados

INSERT INTO Paciente
    (nome, cpf, data_nascimento, telefone, email)
SELECT
    CONCAT('Paciente ', n),
    RIGHT('00000000000' + CAST(10000000000 + n AS VARCHAR(11)), 11),
    DATEADD(
        DAY,
        -((18 * 365) + (n * 37)),
        CAST('2026-01-01' AS DATE)
    ),
    CONCAT('1699', RIGHT('00000000' + CAST(n AS VARCHAR(8)), 8)),
    CONCAT('paciente', n, '@email.com')
FROM (
    SELECT TOP 400
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + 100 AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
) AS Numeros;





INSERT INTO Consulta
    (id_paciente, id_dentista, data, status)
SELECT
    ((n - 1) % 500) + 1 AS id_paciente,
    ((n - 1) % 15) + 1 AS id_dentista,

    DATEADD(
        MINUTE,
        (n % 20) * 30,
        DATEADD(
            DAY,
            -(n % 700),
            CAST('2026-10-08' AS DATETIME2)
        )
    ) AS data,

    CASE
        WHEN n % 10 IN (0, 1) THEN 'Cancelada'
        WHEN n % 10 = 2 THEN 'Faltou'
        WHEN n % 10 IN (3, 4) THEN 'Agendada'
        ELSE 'Realizada'
    END AS status

FROM (
    SELECT TOP 4500
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + 500 AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
) AS Numeros;



SELECT
    status,
    COUNT(*) AS quantidade
FROM Consulta
GROUP BY status
ORDER BY quantidade DESC;




INSERT INTO Consulta_Procedimento
    (id_consulta, id_procedimento, quantidade, valor_realizado)
SELECT
    c.id_consulta,
    ((c.id_consulta - 1) % 7) + 1 AS id_procedimento,
    1 AS quantidade,
    p.valor AS valor_realizado
FROM Consulta c
INNER JOIN Procedimento p
    ON p.id_procedimento = ((c.id_consulta - 1) % 7) + 1
WHERE c.status = 'Realizada'
  AND NOT EXISTS (
      SELECT 1
      FROM Consulta_Procedimento cp
      WHERE cp.id_consulta = c.id_consulta
  );



  INSERT INTO Pagamento
    (id_consulta, data_pagamento, valor, forma_pagamento, status)
SELECT
    c.id_consulta,
    DATEADD(DAY, 1, c.data) AS data_pagamento,
    SUM(cp.quantidade * cp.valor_realizado) AS valor,

    CASE
        WHEN c.id_consulta % 4 = 0 THEN 'Pix'
        WHEN c.id_consulta % 4 = 1 THEN 'Cartão de Crédito'
        WHEN c.id_consulta % 4 = 2 THEN 'Cartão de Débito'
        ELSE 'Dinheiro'
    END AS forma_pagamento,

    'Pago' AS status

FROM Consulta c

INNER JOIN Consulta_Procedimento cp
    ON cp.id_consulta = c.id_consulta

WHERE c.status = 'Realizada'

  AND NOT EXISTS (
      SELECT 1
      FROM Pagamento pg
      WHERE pg.id_consulta = c.id_consulta
  )

GROUP BY
    c.id_consulta,
    c.data;