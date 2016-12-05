USE Estudantes;
-- 2
DROP TABLE IF EXISTS Candidato;
CREATE TABLE Candidato(
	ID				INTEGER PRIMARY KEY AUTO_INCREMENT,
	Nome			VARCHAR(150) NOT NULL COMMENT 'Nomes Pessoais',
	Apelido			VARCHAR(250) NOT NULL COMMENT 'Nomes de Família',
	Endereco		VARCHAR(200) NOT NULL COMMENT 'Endereço excepto Cidade e Código Postal',
	Cidade			VARCHAR(50) NOT NULL DEFAULT 'Lisboa',
	CodigoPostal	INTEGER NOT NULL CHECK (CodigoPostal BETWEEN 3000 AND 4999),
	DataNascimento	DATE NOT NULL,
	DataCandidatura	DATE,
	NISS			INTEGER UNSIGNED UNIQUE NOT NULL
					COMMENT 'Numero de Identificação da Segurança Social',
	IDCurso			INTEGER NOT NULL,
	NotaCandidatura	FLOAT NOT NULL COMMENT 'Nota final de Candidatura'
					CHECK (NotaCandidatura BETWEEN 0 AND 20),
	FOREIGN KEY CandidatoFK (IDCurso) REFERENCES Curso(ID) ON UPDATE CASCADE
);
-- 3
DROP TRIGGER IF EXISTS DataCandidatura;
CREATE TRIGGER DataCandidatura BEFORE INSERT ON Candidato
FOR EACH ROW SET NEW.DataCandidatura = CURRENT_DATE();

-- 4
INSERT INTO Candidato
	(Nome, Apelido, Endereco, Cidade, CodigoPostal, DataNascimento, NISS, NotaCandidatura, IDCurso)
VALUES
	('Gustavo', 'Gonçalves', 'AV. da Guarda, n. 1', 'Guimarães', 3007, '1982-08-22', 1117, 10.5, 2);

-- 5
SELECT * FROM Candidato;

-- 6
DROP TRIGGER IF EXISTS DataCandidatura;

-- 7, 8, 9
DELIMITER //

CREATE TRIGGER ValidaDadosCandidatos BEFORE INSERT ON Candidato
FOR EACH ROW
BEGIN
	DECLARE DADOS_INVALIDOS CONDITION FOR SQLSTATE '45000';
	IF NEW.NotaCandidatura < 0 OR NEW.NotaCandidatura > 20 THEN
		SIGNAL DADOS_INVALIDOS
		SET MESSAGE_TEXT = 'Nota de Candidatura Invalida';
	END IF;
	IF YEAR(CURRENT_DATE()) - YEAR(NEW.DataNascimento) < 16 THEN
		SIGNAL DADOS_INVALIDOS
		SET MESSAGE_TEXT = 'Idade Invalida. Deve ser maior de 15 anos.';
	END IF;
	SET NEW.DataCandidatura = CURRENT_DATE();
END
//
DELIMITER ;
-- 10
INSERT INTO Candidato
	(Nome, Apelido, Endereco, Cidade, CodigoPostal, DataNascimento, NISS, NotaCandidatura, IDCurso)
VALUES
	('José', 'Junqueira', 'Praça do Japão, n. 1', 'Jolanda', 3010, '1979-08-22', 1120, 13.5, 1),
	('Horácio', 'Honório', 'Rua da Horta, 6', 'Oliveira do Hospital', 3011, '1987-03-29', 1121, 28.5, 3);

-- 11
DELIMITER //
INSERT INTO Candidato
	(Nome, Apelido, Endereco, Cidade, CodigoPostal, DataNascimento, NISS, NotaCandidatura, IDCurso)
VALUES
-- 	('Gustavo', 'Gonçalves', 'Av. da Guarda, n. 1', 'Guimarães', 3007, '1982-08-22', 1117, 10.5, 2),
-- 	('Horácio', 'Honório', 'Rua da Horta, 6', 'Oliveira do Hospital', 3011, '1987-03-29', 1121, 8.5, 3),
	('Isabel', 'Ilídio', 'Av. Igreja, 6', 'Idanha a Nova', 3009, '1990-03-29', 1119, 18.5, 3),
	('Justino', 'Judas', 'Rua Justa', 'Japiruagu', 3010, '1985-09-08', 1120, 15.5, 3),
	('Luís', 'Lopes', 'Praçeta da Liberdade', 'Leiria', 3011, '1988-10-08', 1121, 7.85, 1),
	('Maria', 'Marques', 'Largo da Mouraria', 'Moncorvo', 3012, '1991-01-18', 1122, 17.11, 1)
//
DELIMITER ;
select * from Candidato;

-- 12
DELIMITER //
DROP PROCEDURE IF EXISTS EstudantesPorNome
//
CREATE PROCEDURE EstudantesPorNome (IN NomeEstudante VARCHAR(50))
BEGIN
	SELECT * FROM Estudante WHERE Nome = NomeEstudante;
END
//
DELIMITER ;

-- 13
CALL EstudantesPorNome('Catarina');

-- 14
DELIMITER //
DROP PROCEDURE IF EXISTS InscreveCandidato//
CREATE PROCEDURE InscreveCandidato (IN IDCandidato INTEGER, IN Apaga BOOL)
BEGIN
	DECLARE INSCRICAO_FALHOU CONDITION FOR SQLSTATE '45001';
	DECLARE Nota DECIMAL (4,2) UNSIGNED;

	SELECT NotaCandidatura INTO Nota
	FROM Candidato
	WHERE ID = IDCandidato;

	IF Nota < 10 THEN
		SIGNAL INSCRICAO_FALHOU
		SET MESSAGE_TEXT = 'Nota de Candidatura inferior a nota minima (10).';
	END IF;

	INSERT INTO Estudante
		(Nome, Apelido, Endereco, Cidade, CodigoPostal, DataNascimento, NISS)
	SELECT Nome, Apelido, Endereco, Cidade, CodigoPostal, DataNascimento, NISS
	FROM Candidato
	WHERE ID = IDCandidato;

	IF Apaga IS TRUE THEN
		DELETE FROM Candidato
		WHERE ID = IDCandidato;
	END IF;
END//
DELIMITER ;

CALL InscreveCandidato(1, TRUE);

SELECT * FROM Candidato;
SELECT * FROM Estudante;

DELETE FROM Estudante
WHERE NISS = 1117;