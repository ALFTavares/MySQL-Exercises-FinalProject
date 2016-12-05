DROP DATABASE IF EXISTS Estudantes;
CREATE DATABASE Estudantes;
USE Estudantes;

DROP TABLE IF EXISTS Curso;
CREATE TABLE Curso (
    ID       INTEGER PRIMARY KEY AUTO_INCREMENT,
    Nome     VARCHAR(100) NOT NULL,
    Duracao  INTEGER UNSIGNED NOT NULL COMMENT 'Duração em horas',
    Tipo     VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS Accao;
CREATE TABLE Accao (                    
    ID          INTEGER PRIMARY KEY AUTO_INCREMENT,    
    Numero      INTEGER NOT NULL,    
    DataInicial DATE, 
    DataFinal   DATE,
    Coordenador VARCHAR(20),
    IDCurso     INTEGER NOT NULL,
    FOREIGN KEY CursoFK (IDCurso) REFERENCES Curso(ID) ON UPDATE CASCADE,
    UNIQUE KEY NumeroIDX (IDCurso, Numero)
);

-- SET foreign_key_checks = 0;
-- DROP INDEX NumeroIDX ON Accao;
-- -- ou ALTER TABLE Accao DROP INDEX NumeroIDX;
-- SET foreign_key_checks = 1;

-- ALTER TABLE Accao DROP FOREIGN KEY CursoIDX;
-- SHOW CREATE TABLE Accao;

DROP TABLE IF EXISTS Estudante;
CREATE TABLE Estudante (
    ID              INTEGER PRIMARY KEY AUTO_INCREMENT,
    Nome            VARCHAR(150) NOT NULL COMMENT 'Nomes pessoais',
    Apelido         VARCHAR(150) NOT NULL COMMENT 'Nomes de família',
    Endereco        VARCHAR(200) NOT NULL COMMENT 'Endereço excepto cidade e código postal',
    Cidade          VARCHAR(50) NOT NULL DEFAULT 'Lisboa',
    CodigoPostal    INTEGER NOT NULL CHECK(CodigoPostal BETWEEN 3000 AND 4999),
    DataNascimento  DATE NOT NULL,
    NISS            INTEGER UNSIGNED NOT NULL UNIQUE COMMENT 'Número de Identificação da Segurança Social'
);

DROP TABLE IF EXISTS Inscricao;
CREATE TABLE Inscricao (
    ID                  INTEGER PRIMARY KEY AUTO_INCREMENT,    
    IDEstudante         INTEGER NOT NULL,
    IDAccao             INTEGER NOT NULL,
    DataInscricao       DATE, 
    ClassificacaoFinal  DECIMAL(4,2) UNSIGNED CHECK (ClassificacaoFinal BETWEEN 0 AND 20),
    Estado              VARCHAR(10) NOT NULL DEFAULT 'activa'
                        CHECK (Estado in ('activa', 'suspensa', 'concluida')),
    FOREIGN KEY EstudanteFK (IDEstudante) REFERENCES Estudante(ID) ON UPDATE CASCADE,
    FOREIGN KEY AccaoFK (IDAccao) REFERENCES Accao(ID) ON UPDATE CASCADE,
    UNIQUE EstudanteAccaoIDX (IDEstudante, IDAccao)
);

DROP TABLE IF EXISTS EstudanteTrabalhador;
CREATE TABLE EstudanteTrabalhador (
    IDEstudante INTEGER PRIMARY KEY,
    FOREIGN KEY EstudanteTrabalhadorFK (IDEstudante) REFERENCES Estudante(ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    NIF             INTEGER UNSIGNED UNIQUE NOT NULL COMMENT 'Número de identificação fiscal' 
                    CHECK(LENGTH(NIF)=6),
    DataEstatuto    DATE NOT NULL COMMENT 'Início do estatuto de estudante trabalhador',
    NumExames       SMALLINT NOT NULL DEFAULT 1 COMMENT 'Número de exames em época especial',
    Profissao       VARCHAR(20) DEFAULT 'N/D'
);

INSERT INTO Curso
    (Nome, Duracao, Tipo)
VALUES
    ('Agricultura Aplicada', 1500, 'Ciências Agrárias'),
    ('Biologia', 1600, 'Ciências da Vida'),
    ('Contabilidade', 1700, 'Ciências Económicas e Fiscalidade');

INSERT INTO Accao
    (Numero, DataInicial, DataFinal, Coordenador, IDCurso)
VALUES
    (1, '2014-02-02', '2016-09-02', 'Alberto Antunes', 1),
    (2, '2016-08-02', '2018-04-02', 'Alberto Antunes', 1),
    (1, '2016-02-02', '2017-12-02', 'Armando Almeida', 2),
    (1, '2013-09-02', '2015-12-02', 'Arnaldo Alves', 3),
    (2, '2016-09-02', '2018-03-02', 'Arnaldo Alves', 3);

INSERT INTO Estudante
    (Nome, Apelido, Endereco, Cidade, CodigoPostal, DataNascimento, NISS)
VALUES
    ('Antonio', 'Américo', 'Rua do Alecrim, n. 1', 'Albufeira', 3001, '1982-08-22', 1111),
    ('Beatriz', 'Bastos', 'Rua do Beato, Lote 2', 'Braga', 3002, '1982-02-23', 1112),
    ('Catarina', 'Coelho', 'Praça da Constituição, n. 3', 'Coimbra', 3003, '1983-08-10', 1113),
    ('Diogo', 'Diniz', 'Avenida Dom Afonso Lote 4', 'Domelas', 3004, '1980-02-04', 1114),
    ('Eduardo', 'Esteves', 'Praça de Espanha, n. 5', 'Évora', 3005, '1987-03-05', 1115),
    ('Filipa', 'Fernandes', 'Travessa da Ferreirinha, 6', 'Faro', 3006, '1988-02-29', 1116);

INSERT INTO Inscricao
    (IDEstudante, IDAccao, DataInscricao, ClassificacaoFinal)
VALUES
    (1, 2, '2015-05-15', NULL),
    (2, 3, '2015-12-12', NULL),
    (3, 3, '2015-12-10', NULL),
    (4, 3, '2015-12-14', NULL),
    (5, 2, '2014-05-10', NULL),
    (6, 4, '2013-08-01', 17);

INSERT INTO EstudanteTrabalhador
    (IDEstudante, NIF, DataEstatuto, NumExames, Profissao)
VALUES
    (3, 2324540, '2016-02-12', 3, 'Restauração'),
    (4, 345761, '2015-01-02', 5, 'Entretenimento'), 
    (6, 434456, '2012-02-02', 4, 'Programador');

