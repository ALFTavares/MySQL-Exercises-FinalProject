CREATE DATABASE ESTUDANTES_BD;
USE ESTUDANTES;

/*criação da tabelas de dados*/

CREATE TABLE Estudante (
			ID								INTEGER PRIMARY KEY AUTO_INCREMENT,
			NomeEstudante				VARCHAR(20),
			Endereco						VARCHAR(50),
			Cidade						VARCHAR(50),
			CodigoPostal				INTEGER,
			DataNascimento				DATE
);

CREATE TABLE Curso (
			ID								INTEGER PRIMARY KEY AUTO_INCREMENT,	
			Nome							VARCHAR(20),
			Duracao						INTEGER,
			Tipo							VARCHAR(40)
);

CREATE TABLE Accao (
			Numero 						INTEGER PRIMARY KEY AUTO_INCREMENT,
			DataInicial 				DATE,
			DataFinal 					DATE,
			Coordenador 				VARCHAR(20)
);

CREATE TABLE Inscricao (
			DataInscricao				 DATE,
			ClassificacaoFinal		 DECIMAL
);


/*fazer a seleção da belela e tipos especificos*/

SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY, COLUMN_DEFAULT, EXTRA
FROM information_schema.columns
WHERE table_name = 'Estudante';

SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY, COLUMN_DEFAULT, EXTRA
FROM information_schema.columns
WHERE table_name = 'Curso';

/*inserir dados nas tabelas*/

INSERT INTO Estudante
				(NomeEstudante, Endereco, Cidade, CodigoPostal, DataNascimento)
VALUES
				('Antonio', 'Rua do Alecrim, n. 1', 'Albufeira', 3001, '1982-08-22'),
				('Beatriz', 'Rua do Beato, lote 2', 'Braga', 3002, '1982-02-23'),
				('Catarina', 'Praça da Constituição n. 3', 'Coimbra', 3003, '1983-08-10'),
				('Diogo', 'Avenida Dom Afonso, lote 4', 'Domelas', 3004, '1980-02-04'),
				('Eduardo', 'Praça de Espanha, n. 5', 'Évora', 3005, '1987-03-05'),
				('Filipa', 'Travessa da Ferreirinha, 6', 'Faro', 3006, '1988-02-29'
);

/*comfirmar o incremento automático de numeros*/

SELECT NomeEstudante, ID FROM Estudante;

/*verificar todo o conteudo da tabela estudante */

SELECT * FROM Estudante;


/*Acrescenta uma coluna á tabela Estudante*/

ALTER TABLE Estudante add column Nacionalidade VARCHAR(20);


/*Atualizar os dados do campo de forma automática pois todos são de nacionalidade portuguesa*/
UPDATE Estudante SET Nacionalidade = 'Portuguesa';


/*confirmar a atualização*/

SELECT * FROM Estudante;


/*Acrescenta uma coluna á tabela Estudante*/
ALTER TABLE Estudante ADD COLUMN Apelido VARCHAR(50);


/*adicionar dados á coluna Apelido*/
UPDATE Estudante SET Apelido = 'Américo' WHERE NomeEstudante = 'António';
UPDATE Estudante SET Apelido = 'Bastos' WHERE NomeEstudante = 'Beatriz';
UPDATE Estudante SET Apelido = 'Coelho' WHERE NomeEstudante = 'Catarina';
UPDATE Estudante  SET Apelido = 'Diniz' WHERE NomeEstudante = 'Diogo';
UPDATE Estudante SET Apelido = 'Esteves' WHERE NomeEstudante = 'Eduardo';
UPDATE Estudante SET Apelido = 'Fernandes' WHERE NomeEstudante = 'Filipa';

/*Alterar a coluna cidade do Eduardo*/
UPDATE Estudante SET Cidade = 'Espinho' WHERE ID = 5;


/*Apagar tabelas*/
DROP TABLE Estudante;
DROP TABLE Inscricao;
DROP TABLE Accao;
DROP TABLE Curso;


/*Ficha 2.2...*/
/*Criar Tabela*/

CREATE TABLE Curso (
			ID_Curso						INTEGER PRIMARY KEY AUTO_INCREMENT,	
			Nome							VARCHAR(100) NOT NULL COMMENT 'Designaçaõ oficial do curso',
			Duracao						SMALLINT UNSIGNED NOT NULL COMMENT 'Duração em Horas',
			Tipo							VARCHAR(50) NOT NULL COMMENT 'Tipo de curso'
);

/*Introduzir dados na tabela*/
SELECT * FROM Curso;

INSERT INTO Curso
			(Nome, Duracao, Tipo)
VALUES
			('Agricultura Aplicada', 1500, 'Ciências Agrárias'),
			('Biologia', 1600, 'Ciências da Vida'),
			('Contabilidade', 1700, 'Ciências Económicas e Fiscalidade'
			);
			
/*Criar Tabela*/
CREATE TABLE Accao (
			ID_Accao	 					INTEGER PRIMARY KEY AUTO_INCREMENT,
			Numero						INTEGER UNSIGNED NOT NULL,
			DataInicial 				DATE NOT NULL,
			DataFinal 					DATE,
			Coordenador 				VARCHAR(250),
			ID_Curso						INTEGER NOT NULL,
										   UNIQUE KEY (ID_Curso, Numero),
											FOREIGN KEY chave_curso (ID_Curso) REFERENCES Curso (ID_Curso) ON UPDATE CASCADE
);

/*Introduzir dados na tabela*/
select * from Accao;
INSERT INTO Accao
			(Curso, Numero, DataInicial, DataFinal, Coordenador)
VALUES
			('Agricultura Ap.', 1, 02-07-2014, 02-09-2016, 'Alberto Antunes'),
			('Agricultura Ap.', 2, 02-08-2016, 02-04-2018, 'Alberto Antunes'),
			('Biologia', 1, 02-02-2016, 02-12-2017, 'Armando Almeida'),
			('Contabilidade', 1, 02-09-2013, 02-12-2015, 'Arnaldo Alves'),
			('Contabilidade', 2, 02-09-2016, 02-03-2018, 'Arnaldo Alves'
			);

/*Criar Tabela*/
DROP TABLE IF EXISTS Estudante;
CREATE TABLE Estudante (
			ID_Estudante     			INTEGER PRIMARY KEY AUTO_INCREMENT,
			NomeEstudante				VARCHAR(150) NOT NULL COMMENT 'Nomes pessoais',
			Apelido						VARCHAR(250) NOT NULL COMMENT 'Nomes de família',
			Endereco						VARCHAR(200) NOT NULL COMMENT 'Endereço excepto cidade e código postal',
			Cidade						VARCHAR(50)  NOT NULL DEFAULT 'Lisboa',
			CodigoPostal				SMALLINT UNSIGNED NOT NULL CHECK (CodigoPostal BETWEEN 3000 AND 4999),
			DataNascimento				DATE 			 NOT NULL,
			Niss							INTEGER UNSIGNED NOT NULL UNIQUE 
											COMMENT 'NUmero de indentificação da segurança social'
);

CREATE TABLE Inscricao (
			ID_Inscricao			   INTEGER PRIMARY KEY AUTO_INCREMENT,
			ID_Estudante 				INTEGER NOT NULL ON UPDATE CASCADE,
			ID_Accao	 					INTEGER NOT NULL ON UPDATE CASCADE,
			DataInscricao				DATE CURRENT_DATE,
			Estado						VARCHAR(10) NOT NULL DEFAULT 'Activo',
			ClassificacaoFinal		DECIMAL (11,2) 
			FOREIGN KEY chave_Estudante (ID_Estudane) REFERENCES Estudante (ID_Estudante) ON UPDATE CASCADE,
			FOREIGN KEY chave_accao (ID_Accao) REFERENCES Accao (ID_Accao) ON UPDATE CASCADE,
			UNIQUE EstudanteAccaoID(ID_Estudante,ID_Accao)
);

DROP TABLE IF EXISTS EstudanteTrabalhador;
CREATE TABLE EstudanteTrabalhador (
			ID_Estudante            INTEGER PRIMARY KEY,
											FOREIGN KEY (ID_Estudante) REFERENCES Estudante (ID_Estudante)  
											ON UPDATE CASCADE
			NomeEstudante				VARCHAR(150) NOT NULL COMMENT 'Nomes pessoais',
			Apelido						VARCHAR(250) NOT NULL COMMENT 'Nomes de família',
			Endereco						VARCHAR(200) NOT NULL COMMENT 'Endereço excepto cidade e código postal',
			Cidade						VARCHAR(50)  NOT NULL DEFAULT 'Lisboa',
			CodigoPostal				SMALLINT UNSIGNED NOT NULL CHECK (CodigoPostal BETWEEN 3000 AND 4999),
			DataNascimento				DATE 			 NOT NULL,
			Nif							INTEGER UNSIGNED UNIQUE NOT NULL COMMENT 'Numero de identificação fiscal'
											CHECK(LENGHT(Nif)=6),
			DataEstatuto				DATE NOT NULL COMMENT 'Inicio do estatuto trabalhador estudante',
			NumExames					SMALLINT NOT NULL DEFAULT 1 COMMENT 'Numero de exames em epoca especial', 
											COMMENT 'NUmero de indentificação da segurança social'
);


			

