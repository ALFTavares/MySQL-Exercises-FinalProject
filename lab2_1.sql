CREATE DATABASE ESTUDANTES;

USE ESTUDANTES;

CREATE TABLE Estudante(
	ID				INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomeEstudante	VARCHAR(20),
    Endereco		VARCHAR(50),
    Cidade			VARCHAR(50),
    CodigoPostal	INTEGER,
	DataNascimento	DATE
);

CREATE TABLE Curso(
	ID			INTEGER PRIMARY KEY AUTO_INCREMENT,
    Nome		VARCHAR(20),
    Duracao		INTEGER,
    Tipo		VARCHAR(40)
);

DESCRIBE Estudante;
DESCRIBE Curso;

/*SELECT COLUMN_NAME, COLUMN TYPE, IS_NULLABLE, COLUMN_KEY, COLUMN_DEFAULT, EXTRA
FROM information.schema.columns
WHERE table_name = 'Estudante';

SELECT COLUMN_NAME, COLUMN TYPE, IS_NULLABLE, COLUMN_KEY, COLUMN_DEFAULT, EXTRA
FROM information.schema.columns
WHERE table_name = 'Curso';*/

CREATE TABLE Accao(
	Numero			INTEGER PRIMARY KEY AUTO_INCREMENT,
    Data_Inicial	DATE,
    DataFinal		DATE,
    Coordenador		VARCHAR(20)
);

CREATE TABLE Inscricao(
	DataInscricao		DATE,
    ClassificacaoFinal	DECIMAL
);

INSERT INTO Estudante
	(NomeEstudante, Endereco, Cidade, CodigoPostal, DataNascimento)
VALUES
	('Antonio', 'Rua do Alecrim, n. 1', 'Albufeira', 3001, '1982-08-22'),
    ('Beatriz', 'Rua do Beato, Lote 2', 'Braga', 3002, '1982-02-23'),
    ('Catarina', 'Praça da Constituição, n. 3', 'Coimbra', 3003, '1983-08-10'),
    ('Diogo', 'Avenida Dom Afonso, Lote 4', 'Domelas', 3004, '1980-02-04'),
    ('Eduardo', 'Praça de Espanha, n. 5', 'Évora', 3005, '1987-03-05'),
    ('Filipa', 'Travessa da Ferreirinha, 6', 'Faro', 3006, '1988-02-29');
    
SELECT NomeEstudante, ID FROM Estudante;

SELECT * FROM Estudante;