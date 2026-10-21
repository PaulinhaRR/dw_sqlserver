# Data Warehouse - Clínica Odontológica



📌 Sobre o projeto

Este projeto apresenta a construção simples de um Data Warehouse para uma clínica odontológica, com dados sintéticos, com o objetivo de organizar
dados operacionais e transformá-los em informações para análise e apoio.
A solução utilizada SQL Server para estruturar os bancos de dados e realizar a carga dos dados para o DW, além do Power Bi para uma demonstração de um
dashboard analítico.

🎯 Objetivos

- Modelar um banco de dados pequeno operacional e um Data Warehouse.
- Organizar os dados em dimensões e tabelas fato.
- Utilizar SQL para consultas e análises.
- Desenvolver indicadores e visualização no Power BI
- Analisar o faturamento, o volume de consultas e o desempenho da clínica.
  
 🛠️ Tecnologias utilizadas

  - Microsoft SQL Server
  - SQL
  - Power BI
  - Git

🏗️ Arquitetura da solução

O projeto esta organizado em duas partes principais:

1 - Banco operacional (OLTP)
 
Banco simples com dados sintéticos, responsável por armazenar os dados operacionais da clínica, incluindo pacientes, dentistas, especialidades, procedimentos,
consultas e pagamentos.

2 - Data Warehouse

Banco ClinicaDW, estruturado para facilitar consultas analíticas por meio de dimensões e tabelas fato.


Modelo dimensional

Dimensões:
- DimData
- DimPaciente
- DimEspecialidades
- DimProcedimento

Tabela Fato:

- FatoConsulta
- FatoProcedimento


📊 Dashboard no Power BI

-O relatório permite analisar indicadores como:
- Faturamento total
- Total de consultas
- Evolução mensal do faturamento
- Faturamento por dentista
- Distribuição das consultas por status


🚀 Como executar o projeto

Instale o Microsoft SQL Server e uma ferramenta para executar scripts SQL, como o SQL Server Management Studio (SSMS).
Execute o script Estrutura_banco_OLTP.sql para criar a estrutura do banco operacional.
Execute o script Estrutura_banco_DW.sql para criar a estrutura do Data Warehouse.
Realize a carga dos dados nas tabelas, conforme os scripts e procedimentos utilizados no projeto.
Abra Analise_Clinica.pbix no Power BI Desktop.
Configure a conexão com o SQL Server e ajuste as fontes de dados, se necessário.


👩‍💻 Autoria

Projeto desenvolvido para fins de estudo e portfólio na área de Dados, SQL e Business Intelligence.
