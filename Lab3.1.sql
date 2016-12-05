USE Estudantes;

SELECT Curso.ID AS IDCurso, Accao.ID AS Accao
FROM Curso, Accao
WHERE Curso.Nome = 'Contabilidade' AND Accao.ID = 1;

SELECT IDEstudante, ClassificacaoFinal, DataInscricao 
FROM Inscricao
WHERE IDAccao = 3;

SELECT Nome, Endereco, DataNascimento
FROM Estudante
WHERE Cidade = 'Lisboa' OR Cidade = 'Coimbra';

SELECT Nome, Endereco, DataNascimento
FROM Estudante
WHERE Cidade IN ('Lisboa', 'Coimbra');

SELECT Nome, Endereco, DataNascimento
FROM Estudante
WHERE Cidade <> 'Porto';

SELECT Nome, Endereco
FROM Estudante
WHERE Endereco LIKE 'Rua%';

SELECT *
FROM Estudante
WHERE CodigoPostal >= 3002 AND CodigoPostal <= 3005;

SELECT *
FROM Estudante
WHERE CodigoPostal BETWEEN 3002 AND 3005;

SELECT *
FROM Estudante
WHERE CodigoPostal < 3002 OR CodigoPostal > 3005;

SELECT *
FROM Estudante
WHERE NOT(CodigoPostal >= 3002 AND CodigoPostal <= 3005);

SELECT *
FROM Estudante
WHERE CodigoPostal NOT BETWEEN 3002 AND 3005;

SELECT Nome, Apelido, DataNascimento
FROM Estudante
WHERE DataNascimento BETWEEN '1982-01-01' AND '1982-12-31';

SELECT Nome, Apelido, DataNascimento
FROM Estudante
WHERE YEAR(DataNascimento) = 1982;

SELECT * FROM Curso;

SELECT IDEstudante, DATEDIFF(CURDATE(), DataInscricao)
FROM Inscricao
WHERE IDAccao = 1;

SELECT IDEstudante, DataInscricao
FROM Inscricao
WHERE DataInscricao >= CURDATE() - INTERVAL 14 MONTH;

SELECT IDEstudante,
	DAYOFYEAR(DataInscricao) AS Dias,
	DAYOFMONTH(DataInscricao) AS Meses,
	DAYOFWEEK(DataInscricao) AS Semanas
FROM Inscricao;

SELECT CONCAT(Nome, Apelido) AS 'Nome Completo',
	DataNascimento AS 'Data de Nascimento'
FROM Estudante
WHERE YEAR(DataNascimento) = 1982;

SELECT CONCAT(Nome, ' ', Apelido) AS 'Nome Completo',
	DataNascimento AS 'Data de Nascimento'
FROM Estudante
WHERE YEAR(DataNascimento) = 1982;

SELECT * FROM Curso;

CREATE VIEW vEstContab AS
	SELECT IDEstudante,
			DataInscricao
	FROM Inscricao
	WHERE IDAccao = 3;

SELECT * FROM vEstContab;

CREATE VIEW vEstNatureza AS
	SELECT IDEstudante,
			DataInscricao
	FROM Inscricao
	WHERE IDAccao IN (1, 2);

SELECT * FROM vEstNatureza;

CREATE VIEW vMaiores25 AS
SELECT Nome, DataNascimento
FROM Estudante
WHERE DataNascimento <= CURDATE() - INTERVAL 25 YEAR;

SELECT * FROM vMaiores25;

CREATE VIEW vAntonio AS
SELECT CONCAT(Nome, ' ', Apelido) AS `Nome Completo`, DataNascimento
FROM Estudante
WHERE DataNascimento <= CURDATE() - INTERVAL 25 YEAR AND Nome LIKE 'Antonio%';


-- EX1.2
Select LEFT(Nome, 3) AS 3nome
FROM Estudante
WHERE CodigoPostal % 2 = 0;
-- EX1.3
/*SELECT	Nome, RIGHT(CONCAT(REPEAT('_', 15),Apelido),15) AS Apelido
FROM	Estudante;*/

SELECT  Nome, LPAD(Apelido, 15, '_')
FROM	Estudante;
-- EX1.4
SELECT	SUBSTRING_INDEX(Nome, ' ', 1) AS `Primeiro Nome`,
		SUBSTRING_INDEX(Apelido, ' ', -1) AS `Ultimo Apelido`
FROM	Estudante;

-- EX2
SELECT	IDEstudante, DataInscricao
FROM	Inscricao
WHERE	DataInscricao >= CURDATE() - INTERVAL 1 YEAR;

-- EX3
-- SELECT FLOOR(25/10), 25%10;
SELECT	Nome, CONCAT(FLOOR(Duracao/10), 'd', Duracao%10, 'h')
FROM	Curso;

-- EX4
CREATE VIEW vRegiaoEstudanteCase AS
SELECT	Cidade,
		Endereco,
		CodigoPostal,
		CASE 	WHEN Cidade IN ('Braga', 'Guimarães', 'Porto', 'Aveiro', 'Viseu') THEN 'Norte'
				WHEN Cidade IN ('Coimbra', 'Leiria', 'Tomar', 'Lisboa') THEN 'Centro'
				WHEN Cidade IN ('Setúbal', 'Évora', 'Beja', 'Faro') THEN 'SUL'
				ELSE 'Outra_Região'
		END AS 'Localização'
FROM	Estudante;

CREATE VIEW vRegiaoEstudanteIF AS
SELECT	Cidade,
		Endereco,
		CodigoPostal,
		IF(Cidade IN ('Setúbal', 'Évora', 'Beja', 'Faro'),
			'Sul',
			IF(Cidade IN ('Coimbra', 'Leiria', 'Tomar', 'Lisboa'),
				'Centro',
				IF(Cidade IN ('Braga', 'Guimarães', 'Porto', 'Aveiro', 'Viseu'),
					'Norte',
					'Outra_Região'))) AS 'Localização'
FROM	Estudante;