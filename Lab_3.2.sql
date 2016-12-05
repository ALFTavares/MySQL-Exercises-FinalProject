USE Estudantes;

-- EX2
SELECT	Accao.ID,
		Curso.Nome,
		Accao.Numero,
		Accao.DataInicial,
		Accao.DataFinal,
		Curso.Duracao
FROM	Accao
JOIN	Curso
ON		Accao.IDCurso = Curso.ID;

-- EX3
SELECT	Estudante.Nome, Curso.Nome, Duracao
FROM	Estudante
JOIN	Inscricao
ON		Inscricao.IDEstudante = Estudante.ID
JOIN	Accao
ON		Inscricao.IDAccao = Accao.ID
JOIN	Curso
ON		Accao.IDCurso = Curso.ID;

-- EX4
SELECT	Estudante.Nome, Curso.Nome, Duracao
FROM	Estudante, Inscricao, Accao, Curso
WHERE	Inscricao.IDEstudante = Estudante.ID AND
		Inscricao.IDAccao = Accao.ID AND
		Accao.IDCurso = Curso.ID;

-- EX5
SELECT	Estudante.Nome AS `Nome do Estudante`, Curso.Nome AS `Nome do Curso`, Duracao
FROM	Estudante, Inscricao, Accao, Curso
WHERE	Inscricao.IDEstudante = Estudante.ID AND
		Inscricao.IDAccao = Accao.ID AND
		Accao.IDCurso = Curso.ID;

-- EX6
SELECT	Estudante.Nome, Curso.Nome, Duracao
FROM	Estudante
JOIN	Inscricao
ON		Inscricao.IDEstudante = Estudante.ID
JOIN	Accao
ON		Inscricao.IDAccao = Accao.ID
JOIN	Curso
ON		Accao.IDCurso = Curso.ID
WHERE	Curso.Nome IN ('Biologia', 'Agricultura Aplicada', 'Geologia');

-- EX7a
CREATE VIEW AccaoCurso AS
SELECT	Accao.ID AS IDAccao,
		Curso.Nome AS NomeCurso,
		Accao.Numero,
		Accao.DataInicial,
		Accao.DataFinal,
		Curso.Duracao,
		Curso.Tipo
FROM	Accao
JOIn	Curso
ON		Accao.IDCurso = Curso.ID;

-- EX7b
CREATE VIEW InscricaoEstudante AS
SELECT	Inscricao.ID AS IDInscricao,
		Inscricao.ClassificacaoFinal,
		Inscricao.IDAccao,
		Inscricao.DataInscricao,
		Estudante.ID AS IDEstudante,
		Estudante.Nome AS NomeEstudante,
		Estudante.Apelido AS Apelido
FROM	Inscricao
JOIN	Estudante
ON		Inscricao.IDEstudante = Estudante.ID;

-- EX8
SELECT	NomeEstudante, NomeCurso, Duracao
FROM	AccaoCurso
JOIN	InscricaoEstudante
ON		AccaoCurso.IDAccao = InscricaoEstudante.IDAccao
WHERE	NomeCurso IN ('Biologia', 'Agricultura Aplicada', 'Geologia');

-- EX9
SELECT	Nome, DataEstatuto, NIF
FROM	Estudante, EstudanteTrabalhador
WHERE	Estudante.ID = EstudanteTrabalhador.IDEstudante;

-- EX10
SELECT	NomeEstudante 	AS `Nome estudante`,
		NomeCurso		AS `Curso`,
		DataInscricao	AS `Data de inscricao`,
		NIF
FROM	AccaoCurso, InscricaoEstudante, EstudanteTrabalhador
WHERE	AccaoCurso.IDAccao = InscricaoEstudante.IDAccao AND
		InscricaoEstudante.IDEstudante = EstudanteTrabalhador.IDEstudante;

-- EX11
SELECT	NomeEstudante	AS `Nome estudante`,
		NomeCurso		AS `Curso`,
		DataInscricao	AS `Data de inscricao`,
		NIF
FROM	AccaoCurso AS AC,
		InscricaoEstudante AS IE,
		EstudanteTrabalhador AS ET
WHERE	AC.IDAccao = IE.IDAccao AND
		IE.IDEstudante = ET.IDEstudante;

-- EX12
SELECT	NomeEstudante AS 'Nome Estudante',
		NomeCurso AS 'Curso',
		DataInscricao AS 'Data de inscricao',
		COALESCE(NIF, '<não aplicavel>') AS NIF
FROM	InscricaoEstudante AS IE
JOIN	AccaoCurso AS AC
ON		IE.IDAccao = AC.IDAccao
LEFT OUTER JOIN EstudanteTrabalhador AS ET
ON		IE.IDEstudante = ET.IDEstudante;

-- EX13
SELECT	NomeEstudante,
		ClassificacaoFinal
FROM	InscricaoEstudante
ORDER BY ClassificacaoFinal;

-- EX14
SELECT	NomeEstudante,
		ClassificacaoFinal,
		DataInscricao
FROM	InscricaoEstudante
ORDER BY ClassificacaoFinal DESC, NomeEstudante ASC;

-- EX15a
SELECT	NomeEstudante,
		ClassificacaoFinal,
		DataInscricao
FROM	InscricaoEstudante
ORDER BY ClassificacaoFinal DESC,
		NomeEstudante ASC
LIMIT	5;

-- EX15b
SELECT	NomeEstudante,
		ClassificacaoFinal,
		DataInscricao
FROM	InscricaoEstudante
ORDER BY ClassificacaoFinal DESC,
		NomeEstudante ASC
LIMIT	6, 5;

-- EX16
SELECT	NomeEstudante,
		ClassificacaoFinal
FROM	InscricaoEstudante
ORDER BY ClassificacaoFinal DESC
LIMIT 1, 10;

-- EX17
SELECT	NomeEstudante,
		ClassificacaoFinal
FROM	(SELECT	NomeEstudante,
				ClassificacaoFinal
		FROM	InscricaoEstudante
		ORDER BY ClassificacaoFinal DESC
		LIMIT	1, 10) AS M
ORDER BY	ClassificacaoFinal ASC;

-- EX18
SELECT	IDEstudante,
		IDAccao,
		Estado
FROM	Inscricao
ORDER BY FIELD(Estado, 'activa', 'suspensa', 'concluida');

-- EX19
SELECT	MAX(ClassificacaoFinal),
		MIN(ClassificacaoFinal),
		AVG(ClassificacaoFinal)
FROM	InscricaoEstudante;

-- EX20
SELECT	COUNT(*)
FROM	Estudante;

-- EX21
SELECT	COUNT(*)
FROM	InscricaoEstudante
WHERE	ClassificacaoFinal >= 14;

-- EX22a
SELECT	DISTINCT Duracao
FROM	Curso;

-- EX22b
SELECT	DISTINCT
		Cidade,
		CodigoPostal
FROM	Estudante;

-- EX23
SELECT	NomeCurso,
		COUNT(*) AS NumAccoes
FROM	AccaoCurso
GROUP BY NomeCurso;

-- EX24
SELECT	IDAccao,
		AVG(ClassificacaoFinal) AS Media
FROM	InscricaoEstudante
GROUP BY IDAccao;

-- EX25
SELECT	C.ID, C.Nome, COUNT(I.IDEstudante), AVG(I.ClassificacaoFinal)
FROM	Inscricao AS I
JOIN	Accao	AS A
ON		I.IDAccao = A.ID
JOIN	Curso	AS C
ON		A.IDCurso = C.ID
GROUP BY C.ID;
