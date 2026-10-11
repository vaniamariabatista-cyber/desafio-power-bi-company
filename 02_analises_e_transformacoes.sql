-- Consultas para análise e transformação da base Company
-- Execute depois de sql/01_criar_base_company.sql
USE company_constraints;

-- 1. Conferir estrutura, cabeçalhos e tipos de dados.
SHOW TABLES;
DESCRIBE employee;
DESCRIBE departament;
DESCRIBE dept_locations;
DESCRIBE project;
DESCRIBE works_on;
DESCRIBE dependent;

-- 2. Verificar tipo e distribuição de salários (Salary já é DECIMAL(10,2)).
SELECT MIN(Salary) AS menor_salario,
       MAX(Salary) AS maior_salario,
       AVG(Salary) AS media_salarial
FROM employee;

-- 3. Inspecionar valores nulos nas colunas mais relevantes para o desafio.
SELECT 'employee.Super_ssn' AS campo, COUNT(*) AS nulos
FROM employee WHERE Super_ssn IS NULL
UNION ALL
SELECT 'departament.Mgr_ssn', COUNT(*)
FROM departament WHERE Mgr_ssn IS NULL
UNION ALL
SELECT 'works_on.Hours', COUNT(*)
FROM works_on WHERE Hours IS NULL
UNION ALL
SELECT 'employee.Salary', COUNT(*)
FROM employee WHERE Salary IS NULL;

-- Funcionários sem supervisor cadastrado. Na amostra original, o resultado identifica James Borg.
SELECT Ssn, CONCAT(Fname, ' ', Lname) AS colaborador, Dno
FROM employee
WHERE Super_ssn IS NULL;

-- Departamentos sem gerente cadastrado.
SELECT Dnumber, Dname, Mgr_ssn
FROM departament
WHERE Mgr_ssn IS NULL;

-- 4. Verificar horas registradas por projeto e colaborador.
SELECT p.Pnumber, p.Pname,
       CONCAT(e.Fname, ' ', e.Lname) AS colaborador,
       w.Hours
FROM works_on AS w
JOIN project AS p ON p.Pnumber = w.Pno
JOIN employee AS e ON e.Ssn = w.Essn
ORDER BY p.Pnumber, colaborador;

-- Total de horas por projeto.
SELECT p.Pnumber, p.Pname, SUM(w.Hours) AS total_horas
FROM project AS p
LEFT JOIN works_on AS w ON w.Pno = p.Pnumber
GROUP BY p.Pnumber, p.Pname
ORDER BY p.Pnumber;

-- 5. Separar a coluna Address para demonstrar a decomposição de um campo complexo.
-- A amostra usa o formato numero-rua-cidade-estado.
SELECT Address,
       SUBSTRING_INDEX(Address, '-', 1) AS numero,
       SUBSTRING_INDEX(SUBSTRING_INDEX(Address, '-', 2), '-', -1) AS rua,
       SUBSTRING_INDEX(SUBSTRING_INDEX(Address, '-', 3), '-', -1) AS cidade,
       SUBSTRING_INDEX(Address, '-', -1) AS estado
FROM employee;

-- 6. Mesclar employee e departament: a tabela-base é employee (LEFT JOIN preserva os colaboradores).
SELECT e.Ssn,
       CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS nome_colaborador,
       d.Dname AS departamento,
       e.Salary AS salario
FROM employee AS e
LEFT JOIN departament AS d ON d.Dnumber = e.Dno
ORDER BY nome_colaborador;

-- 7. Mesclar colaborador e nome do respectivo gerente por autojunção.
SELECT CONCAT(e.Fname, ' ', e.Lname) AS colaborador,
       COALESCE(CONCAT(g.Fname, ' ', g.Lname), 'Sem gerente cadastrado') AS gerente
FROM employee AS e
LEFT JOIN employee AS g ON g.Ssn = e.Super_ssn
ORDER BY gerente, colaborador;

-- 8. Combinar departamento e localização: cada par departamento-local fica identificável.
SELECT d.Dnumber,
       CONCAT(d.Dname, ' - ', l.Dlocation) AS departamento_local,
       CONCAT(m.Fname, ' ', m.Lname) AS gerente
FROM departament AS d
JOIN dept_locations AS l ON l.Dnumber = d.Dnumber
LEFT JOIN employee AS m ON m.Ssn = d.Mgr_ssn
ORDER BY d.Dnumber, l.Dlocation;

-- 9. Quantidade de colaboradores por gerente.
SELECT COALESCE(CONCAT(g.Fname, ' ', g.Lname), 'Sem gerente cadastrado') AS gerente,
       COUNT(e.Ssn) AS quantidade_colaboradores
FROM employee AS e
LEFT JOIN employee AS g ON g.Ssn = e.Super_ssn
GROUP BY g.Ssn, g.Fname, g.Lname
ORDER BY quantidade_colaboradores DESC, gerente;

-- 10. Exemplo de seleção apenas das colunas necessárias para um relatório resumido.
-- A remoção de colunas da consulta de saída é preferível a alterar a tabela bruta de origem.
SELECT e.Ssn,
       CONCAT(e.Fname, ' ', e.Lname) AS colaborador,
       d.Dname AS departamento,
       e.Salary AS salario
FROM employee AS e
LEFT JOIN departament AS d ON d.Dnumber = e.Dno;

-- Explicação conceitual para README:
-- Mesclar consultas combina tabelas com base em uma chave (por exemplo Dno = Dnumber)
-- e acrescenta atributos relacionados às linhas. Acrescentar consultas empilha linhas de tabelas
-- com estruturas compatíveis; não substitui a junção entre funcionário e departamento.
