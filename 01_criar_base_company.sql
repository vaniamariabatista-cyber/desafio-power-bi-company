-- Base Company para o desafio de Processamento e Transformação de Dados com Power BI
-- Adaptado para MariaDB a partir dos scripts públicos da formação Power BI Analyst:
-- https://github.com/julianazanelatto/power_bi_analyst/tree/main/M%C3%B3dulo%203/Desafio%20de%20Projeto
-- Observação: esta versão usa a amostra publicada de 8 funcionários. Compare com a base usada na aula,
-- pois os materiais visuais podem mostrar uma versão diferente dos dados.

CREATE DATABASE IF NOT EXISTS company_constraints
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE company_constraints;

-- Este script recria as tabelas desta base de estudo. Execute apenas no schema do desafio.
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS dependent;
DROP TABLE IF EXISTS works_on;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS dept_locations;
DROP TABLE IF EXISTS departament;
DROP TABLE IF EXISTS employee;
SET FOREIGN_KEY_CHECKS = 1;

-- Criamos primeiro as tabelas e carregamos os dados; as chaves estrangeiras circulares
-- são adicionadas no final para permitir carregar a hierarquia de supervisão corretamente.
CREATE TABLE employee (
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR(1),
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) NOT NULL,
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR(1),
    Salary DECIMAL(10,2),
    Super_ssn CHAR(9),
    Dno INT NOT NULL DEFAULT 1,
    CONSTRAINT pk_employee PRIMARY KEY (Ssn),
    CONSTRAINT chk_salary_employee CHECK (Salary > 2000.00)
) ENGINE=InnoDB;

CREATE TABLE departament (
    Dname VARCHAR(15) NOT NULL,
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(9) NOT NULL,
    Mgr_start_date DATE,
    Dept_create_date DATE,
    CONSTRAINT pk_dept PRIMARY KEY (Dnumber),
    CONSTRAINT unique_name_dept UNIQUE (Dname),
    CONSTRAINT chk_date_dept CHECK (Dept_create_date < Mgr_start_date)
) ENGINE=InnoDB;

CREATE TABLE dept_locations (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    CONSTRAINT pk_dept_locations PRIMARY KEY (Dnumber, Dlocation)
) ENGINE=InnoDB;

CREATE TABLE project (
    Pname VARCHAR(15) NOT NULL,
    Pnumber INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    CONSTRAINT pk_project PRIMARY KEY (Pnumber),
    CONSTRAINT unique_project UNIQUE (Pname)
) ENGINE=InnoDB;

CREATE TABLE works_on (
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(3,1) NOT NULL,
    CONSTRAINT pk_works_on PRIMARY KEY (Essn, Pno)
) ENGINE=InnoDB;

CREATE TABLE dependent (
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(8),
    CONSTRAINT pk_dependent PRIMARY KEY (Essn, Dependent_name)
) ENGINE=InnoDB;

INSERT INTO employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES
('John', 'B', 'Smith', '123456789', '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000.00, '333445555', 5),
('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638-Voss-Houston-TX', 'M', 40000.00, '888665555', 5),
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000.00, '987654321', 4),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000.00, '888665555', 4),
('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000.00, '333445555', 5),
('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000.00, '333445555', 5),
('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000.00, '987654321', 4),
('James', 'E', 'Borg', '888665555', '1937-11-10', '450-Stone-Houston-TX', 'M', 55000.00, NULL, 1);

INSERT INTO departament (Dname, Dnumber, Mgr_ssn, Mgr_start_date, Dept_create_date) VALUES
('Research', 5, '333445555', '1988-05-22', '1986-05-22'),
('Administration', 4, '987654321', '1995-01-01', '1994-01-01'),
('Headquarters', 1, '888665555', '1981-06-19', '1980-06-19');

INSERT INTO dept_locations (Dnumber, Dlocation) VALUES
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

INSERT INTO project (Pname, Pnumber, Plocation, Dnum) VALUES
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

INSERT INTO works_on (Essn, Pno, Hours) VALUES
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, 0.0);

INSERT INTO dependent (Essn, Dependent_name, Sex, Bdate, Relationship) VALUES
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son'),
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse');

-- Chaves estrangeiras são criadas após a carga dos dados.
ALTER TABLE employee
  ADD CONSTRAINT fk_employee_supervisor FOREIGN KEY (Super_ssn) REFERENCES employee(Ssn)
  ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE departament
  ADD CONSTRAINT fk_dept_manager FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn)
  ON UPDATE CASCADE;

ALTER TABLE dept_locations
  ADD CONSTRAINT fk_dept_locations FOREIGN KEY (Dnumber) REFERENCES departament(Dnumber)
  ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE project
  ADD CONSTRAINT fk_project_department FOREIGN KEY (Dnum) REFERENCES departament(Dnumber)
  ON UPDATE CASCADE;

ALTER TABLE works_on
  ADD CONSTRAINT fk_employee_works_on FOREIGN KEY (Essn) REFERENCES employee(Ssn),
  ADD CONSTRAINT fk_project_works_on FOREIGN KEY (Pno) REFERENCES project(Pnumber);

ALTER TABLE dependent
  ADD CONSTRAINT fk_dependent_employee FOREIGN KEY (Essn) REFERENCES employee(Ssn);

-- Conferência rápida pós-carga: cada consulta deve retornar a quantidade de registros inseridos.
SELECT 'employee' AS tabela, COUNT(*) AS total FROM employee
UNION ALL SELECT 'departament', COUNT(*) FROM departament
UNION ALL SELECT 'dept_locations', COUNT(*) FROM dept_locations
UNION ALL SELECT 'project', COUNT(*) FROM project
UNION ALL SELECT 'works_on', COUNT(*) FROM works_on
UNION ALL SELECT 'dependent', COUNT(*) FROM dependent;
