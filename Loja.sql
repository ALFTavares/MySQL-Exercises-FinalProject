DROP DATABASE IF EXISTS LOJA_EM_LINHA;
CREATE DATABASE LOJA_EM_LINHA;

USE LOJA_EM_LINHA;

DROP TABLE IF EXISTS PRODUTO;
CREATE TABLE PRODUTO(
	ID					VARCHAR(10) PRIMARY KEY,
	Quantidade			INTEGER UNSIGNED NOT NULL,
	Preco				DECIMAL(8, 2) UNSIGNED NOT NULL,
	IVA					REAL UNSIGNED NOT NULL
);

DROP TABLE IF EXISTS FORNECEDOR;
CREATE TABLE FORNECEDOR (
    ID      	  		VARCHAR(10)NOT NULL PRIMARY KEY ,
    Nome     			VARCHAR(50) NOT NULL,
    Morada  	  		VARCHAR(100) NOT NULL,
    NumeroTelefone   	BIGINT(9) NOT NULL CHECK (2 OR 91 OR 92 OR 93 OR 96),
						CHECK (LENGTH(Telefone) = 9)
);

DROP TABLE IF EXISTS ORDEM;
CREATE TABLE ORDEM(
		ID				INTEGER AUTO_INCREMENT PRIMARY KEY,
		Datahora	  	DATETIME NOT NULL DEFAULT NOW(),
		IDFornecedor	VARCHAR(10)NOT NULL,
		Estado			VARCHAR(12) NOT NULL DEFAULT 'aberta' CHECK (Estado IN('aberta' OR 'colocada' OR 'interronpida' OR 'fechada' OR 'cancelada')),
		FOREIGN KEY IDFornecedorFK (IDFornecedor) REFERENCES FORNECEDOR(ID) 
);
		
DROP TABLE IF EXISTS PRODUTO_PEDIDO;
CREATE TABLE PRODUTO_PEDIDO(
	IDProduto			VARCHAR(10) NOT NULL,
	IDOrdem			INT NOT NULL,																	
	FOREIGN KEY ProdutoFK (IDProduto) REFERENCES PRODUTO(ID),
	FOREIGN KEY OrdemFK (IDOrdem) REFERENCES ORDEM(ID),
	PRIMARY KEY (IDProduto,IDOrdem)
);
	
DROP TABLE IF EXISTS CLIENTE;
CREATE TABLE CLIENTE(
	ID					INTEGER AUTO_INCREMENT PRIMARY KEY,
	Nome				VARCHAR(50) NOT NULL,
	Email				VARCHAR(50) UNIQUE NOT NULL,
	Senha				VARCHAR(50) NOT NULL,
	Morada			  	VARCHAR(100) NOT NULL,
	CodigoPostal	  	INTEGER(10) NOT NULL,
	Cidade			  	VARCHAR(30) NOT NULL,
	Pais				VARCHAR(30) DEFAULT 'Portugal',
	NumeroTelefone	  	BIGINT NOT NULL	CHECK (2 OR 91 OR 92 OR 93 OR 96),
						CHECK (LENGTH(Telefone) = 9),
						CHECK (LENGTH(Senha) >= 5)
);
		
DROP DATABASE IF EXISTS ENCOMENDA;
CREATE TABLE ENCOMENDA(
    ID                	INTEGER AUTO_INCREMENT PRIMARY KEY,
    DataHora          	DATETIME DEFAULT NOW(),
    MetodoExpedicao   	VARCHAR(10) DEFAULT 'normal' CHECK(MetodoExpedicao('normal' OR 'urgente')),
    Estado            	VARCHAR(12) NOT NULL DEFAULT 'aberta' CHECK (Estado in('aberta' OR 'colocada' OR 'interronpida' OR 'fechada' OR 'cancelada')),
    NumeroCartao      	BIGINT NOT NULL,
    NomeCartao        	VARCHAR(20) NOT NULL,
    ValidadeCartao    	DATE NOT NULL,
    NumeroCliente     	INTEGER NOT NULL,
    FOREIGN KEY Cliente_FK(NumeroCliente) REFERENCES CLIENTE(ID)
);
	
DROP TABLE IF EXISTS PRODUTO_ENCOMENDADO;
CREATE TABLE PRODUTO_ENCOMENDADO(
    IDEncomenda         INTEGER AUTO_INCREMENT,
    IDProduto        	VARCHAR(10),
    Quantidade          INTEGER UNSIGNED NOT NULL,
    Preco               DECIMAL(8, 2) UNSIGNED,
    IVA                 REAL UNSIGNED NOT NULL,
    FOREIGN KEY IDEncomenda_FK(IDEncomenda) REFERENCES ENCOMENDA(ID),
    FOREIGN KEY IDProduto_FK(IDProduto) REFERENCES PRODUTO(ID),
    UNIQUE ID_U (IDEncomenda, IDProduto)
);
	
DROP TABLE IF EXISTS CONSUMIVEL_ELEC;
CREATE TABLE CONSUMIVEL_ELEC(
    IDProduto          VARCHAR(10) NOT NULL,
    NumeroSerie        BIGINT UNIQUE NOT NULL,
    Marca              VARCHAR(20) NOT NULL,
    Modelo             VARCHAR(20) NOT NULL,
    SpecTec            LONGTEXT,
    Tipo               VARCHAR(10) NOT NULL,
    FOREIGN KEY IDProdutoFK(IDProduto) REFERENCES PRODUTO(ID)
);


DROP TABLE IF EXISTS LIVRO;
CREATE TABLE LIVRO(
    IDProduto        	VARCHAR(10) NOT NULL,
    ISBN             	VARCHAR(20) UNIQUE NOT NULL,
    Titulo           	VARCHAR(50) NOT NULL,
    Genero           	VARCHAR(20) NOT NULL,
    Editora          	VARCHAR(20) NOT NULL,
    Autor            	VARCHAR(50) NOT NULL,
    DataPublicacao   	DATE,
    FOREIGN KEY FK_IDProduto(IDProduto) REFERENCES PRODUTO(ID)
);

DELIMITER //
DROP PROCEDURE IF EXISTS pValidaTelefone//
CREATE PROCEDURE pValidaTelefone(INOUT Numerotelefone BIGINT)
	BEGIN
		IF LENGTH(NumeroTelefone) <> 9 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Telefone tem que conter 9 digitos';
		END IF;
		IF SUBSTR(NumeroTelefone, 1, 1) <> 2 AND SUBSTR(NumeroTelefone, 1, 2) NOT IN (91, 92, 93, 96) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Telefone tem que começar por 2, 91, 92, 93, 96';
		END IF;
	END
//

DELIMITER //
DROP TRIGGER IF EXISTS tTelefoneCliente//
CREATE TRIGGER tTelefoneCliente BEFORE INSERT ON CLIENTE
	FOR EACH ROW
	BEGIN
		CALL pValidaTelefone(NEW.NumeroTelefone);
		IF LENGTH(NEW.Senha) < 5 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Minimo 5 caracteres';
		END IF;
	END
//

DELIMITER //
DROP TRIGGER IF EXISTS tTelefoneFornecedor//
CREATE TRIGGER tTelefoneFornecedor BEFORE INSERT ON FORNECEDOR
	FOR EACH ROW
	BEGIN
		CALL pValidaTelefone(NEW.NumeroTelefone);
	END
//

DELIMITER //
DROP TRIGGER IF EXISTS tEncomenda//
CREATE TRIGGER tEncomenda BEFORE INSERT ON ENCOMENDA
	FOR EACH ROW
	BEGIN
		IF NEW.MetodoExpedicao NOT IN ('normal', 'urgente') THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Expedição tem que ser normal ou urgente';
		END IF;
		IF NEW.Estado NOT IN ('aberta', 'colocada', 'interrompida', 'fechada', 'cancelada') THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Estado tem que ser aberta, colocada, interrompida, fechada ou cancelada';
		END IF;
	END
//

DELIMITER ;

INSERT INTO CLIENTE(Nome, Email, Senha, Morada, CodigoPostal, Cidade, NumeroTelefone)
VALUES
    ('João', 'jo@ao.com', '12346', 'rua do fim do muindo', 2675322, 'Amaadora', 969387569),
	('Manuel', 'Manuel@el.com', '15874', 'estrada da luz', 4589625, 'Carcavelos', 964086547),
	('Manuela', 'Manuela@el.com', '15664', 'estrada da igreja', 4589825, 'Carca', 964086577),
	('Joana', 'Joa@na.com', '24474', 'morada especial', 2229625, 'Lisboa', 924086547),
	('Rui', 'Ruil@el.com', '15111', 'estrada de benfica', 4589777, 'Lisboa', 214086547);
	 

INSERT INTO FORNECEDOR(ID, Nome, Morada, NumeroTelefone)
VALUES
	('João58', 'joão', 'rua do fim do mundo', 219387569),
	('Pedro5478', 'Segue', 'rua da paz', 219571269),
	('Busca582', 'Busca', 'Porto de Lisboa', 219387749),
	('DX547', 'DX', 'Avenida da Liberdade', 939387569),
	('Power6147', 'PowerP', 'Avenida Gonçalves', 919387569);
	

INSERT INTO PRODUTO(ID, Quantidade, Preco, IVA)
VALUES
 	('ER5856', 52, 52.5, 23),
 	('ro5478', 21, 103.84, 23),
 	('a582', 3, 1335, 23),
 	('DX58547', 1, 2500, 23),
 	('Po47', 85, 15,23),
	('ER585652', 6, 3000, 23),
	('ro547852', 21, 103.84, 23),
	('a58252', 3, 1350.74, 23),
	('DX5854752', 15, 370, 23),
	('Po4752', 10, 85,23);
	
	
	
INSERT INTO ENCOMENDA(MetodoExpedicao,  Estado,NumeroCartao, NomeCartao, ValidadeCartao, NumeroCliente)
	values
 		( 'normal', 'aberta', 219387569, 'Joaocart', '2018-03-15', 1),
 		( 'urgente', 'colocada', 2198771269, 'Manuelcart', '2019-06-04', 2);
INSERT INTO ENCOMENDA(Estado,NumeroCartao, NomeCartao, ValidadeCartao, NumeroCliente)
	values
		('colocada', 2196555269, 'Manuelacart', '2019-06-04', 3),
		('interrompida', 354127769, 'Joanacart', '2019-06-02', 4),
		('fechada', 35427769, 'Ruiacart', '2019-06-02',5),
		('fechada', 35427769, 'Ruiacart', '2019-06-02',5);

	
	

INSERT INTO ORDEM( IDFornecedor, Estado)
VALUES
	('Busca582', 'Aberto'),
	('DX547', 'colocada'),
	('João58', 'Interronpida'),
	('Pedro5478', 'Fechada'),
	('Power6147', 'Cancelada');
	
	
	
INSERT INTO LIVRO (IDProduto, ISBN, Titulo, Genero, Editora, Autor, DataPublicacao)       
VALUES
	('a582', '99921-58-10-7','Os Lusíadas', 'poema épico', 'livraria arte', 'Camões, Luís de', '1572-02-26'),
	('DX58547', '9971-5-0210-0','Os Maias', 'romance', 'livroCO', 'Queirós, Eça de', '1888-03-14'),
	('ER5856', '972-662-905-4', 'Os Incompatíveis', 'literatura', 'Campo das Letras', 'José Leon Machado',  '2002-05-12'),
	('Po47', '85-359-0277-5', 'O Esplendor de Portugal', 'literatura', 'Dom Quixote','Antunes, António Lobo', '2000-05-14'),
	('ro5478', '0-684-84328-5', 'O Arco-Íris da Gravidade', 'romance', 'Dom Quixote', 'Pynchon,Thomas', '1973-08-13');
	
	
	
INSERT INTO CONSUMIVEL_ELEC (IDProduto,  NumeroSerie, Marca, Modelo, SpecTec, Tipo)       
VALUES
	('a58252', 9992158107,'Singer', '65UH668V', 'Mapeamento de cores 3D expressa cores realistas através de seu algoritmo Gamut Mapping 3D. Minimiza a distorção de cor, permitindo desfrutar de cores incrivelmente naturais', 'televisor'),
	('DX5854752', 9971502100,'Philips', '55UH668V', 'O rádio digital DAB (Digital Audio Broadcasting) é, a par da transmissão analógica FM, uma nova forma de transmissão rádio através de uma rede de transmissores terrestres. ', 'Radio'),
	('ER585652', 9726629054, 'Asus', '60UH650V', 'O ZenFone combina a melhor da experiência dos Smartphones com uma performance potente que irá melhorar cada aspecto da sua vida. Simples, Pacífico, Belo, é isto que o ZenFone', 'Telemovel'),
	('Po4752', 853590275, 'Lenovo', '55UH600V', 'i5-6200U, 1x8GB, 256 GB SSD, no DVD, Intel Integrated HD Graphics, 14.0" FULL HD (1920x1080), Intel 8260 ACBGN + BT4.1, FPR, 3cell 23.5Whr integrated + 3cell 23.5Whr external,','Portatil'),
	('ro547852', 0684843285, 'HP', '55UH650V', 'Imprima a cores de qualidade profissional a um custo por página de até 50% menos em relação às impressoras laser com esta impressora ligada à Web.1 Imprima através da sua rede ', 'Impressora');
	 

	
INSERT INTO PRODUTO_ENCOMENDADO(IDEncomenda, IDProduto, Quantidade, Preco, IVA )       
VALUES
		( 3, 'a582', 1, 1335, 23),
		( 4, 'a58252', 2, 1350,23),
		( 5, 'DX58547', 1, 2500, 23),
		(6, 'DX5854752', 1, 370, 23),
		(1, 'ER5856', 1, 52.50, 23),
		(2, 'ER585652', 1, 3000, 23);	
		

		
INSERT INTO PRODUTO_PEDIDO(IDProduto, IDOrdem)       
VALUES
		( 'a582', 1),
		( 'a58252', 2),
		('DX58547', 3),
		('DX5854752', 4),
		('ER5856', 5);

/*PROCEDURES
PROCEDURES
PROCEDURES
PROCEDURES
PROCEDURES
PROCEDURES
PROCEDURES
PROCEDURES
PROCEDURES
PROCEDURES
PROCEDURES
PROCEDURES*/

-- Livros
SELECT 'LIVRO' AS Tipo, IDProduto AS 'Codigo de Produto', Preco, Titulo
FROM LIVRO, PRODUTO
WHERE LIVRO.IDProduto = PRODUTO.ID;


-- Elecs
SELECT IDProduto, Preco, Modelo, Tipo
FROM CONSUMIVEL_ELEC, PRODUTO
WHERE PRODUTO.ID = CONSUMIVEL_ELEC.IDProduto;

-- EncomendasDiarias

DELIMITER //
DROP PROCEDURE IF EXISTS pEncomendasDiarias//
CREATE PROCEDURE pEncomendasDiarias(
	IN _DataEncomenda DATE)
	BEGIN
		SELECT ID, DataHora
		FROM ENCOMENDA
		WHERE DATE(DataHora) = _DataEncomenda;
	END
//


CALL pEncomendasDiarias('2016-07-26')
// 

-- OrdensProdutos

DELIMITER //
DROP PROCEDURE IF EXISTS pOrdensProdutos//
CREATE PROCEDURE pOrdensProdutos(
	IN _Ordens INT)
	BEGIN
		SELECT O.ID, DataHora, Nome AS 'Nome do Fornecedor', Preco
		FROM ORDEM O, PRODUTO P, PRODUTO_PEDIDO PD, FORNECEDOR F
		WHERE P.ID = PD.IDProduto
			AND PD.IDOrdem = O.ID
			AND O.IDFornecedor = F.ID
			AND _Ordens = O.ID;
	END
//

CALL pOrdensProdutos(2)
//


-- OrdensAnuais


DELIMITER //
DROP PROCEDURE IF EXISTS pOrdensAnuais//
CREATE PROCEDURE pOrdensAnuais(
	IN _ano YEAR)
	BEGIN
		SELECT ID, DataHora
		FROM ORDEM
		WHERE YEAR(DataHora) = _ano;
	END
//

CALL pOrdensAnuais(2016)
//

-- CriarEncomenda


DELIMITER //
DROP PROCEDURE IF EXISTS pCriarEncomenda//
CREATE PROCEDURE pCriarEncomenda(
	IN _NCliente INT,
	IN _Metodo VARCHAR(10),
	IN _Ncartao BIGINT,
	IN _NomeC VARCHAR(20),
	IN _Validade DATE)
	BEGIN
		INSERT INTO ENCOMENDA(NumeroCliente, MetodoExpedicao, NumeroCartao, NomeCartao, ValidadeCartao)
			VALUES (_NCliente, _Metodo, _NCartao, _NomeC, _Validade);
	END
//

CALL pCriarEncomenda(1, 'normal', 918273645, 'JCartao', '2019-03-12');


-- AdicionarProduto

DELIMITER //
DROP PROCEDURE IF EXISTS pAdicionarProduto//
CREATE PROCEDURE pAdicionarProduto(
	IN _Encomenda INT,
	IN _Produto VARCHAR(10),
	IN _Quant INT)
	BEGIN
		INSERT INTO PRODUTO_ENCOMENDADO(IDEncomenda, IDProduto, Quantidade, IVA)
			VALUES (_Encomenda, _Produto, _Quant, 23);
	END
//

CALL pAdicionarProduto(2, 'a582', 5)
//

-- CalcularTotal

DELIMITER //
DROP PROCEDURE IF EXISTS pCalcularTotal//
CREATE PROCEDURE pCalcularTotal(
	IN _Encomenda INT)
BEGIN
	SELECT E.ID, (PE.Quantidade * (P.Preco+(P.Preco*P.IVA))) AS total
	FROM PRODUTO_ENCOMENDADO PE, ENCOMENDA E, PRODUTO P
	WHERE E.ID = PE.IDEncomenda AND PE.IDProduto = P.ID AND E.ID = _Encomenda
	GROUP BY E.ID;
END
//

CALL pCalcularTotal(2)
//

select * from ENCOMENDA
//

-- ColocarEncomenda

DELIMITER //
CREATE PROCEDURE pColocarEncomenda(
	IN _Encomenda INT)
	BEGIN
		UPDATE ENCOMENDA
			SET Estado = 'colocada'
			WHERE ID = _Encomenda;
	END
//

CALL pColocarEncomenda(8)
//


-- EncomendasTermindadas
DELIMITER ;

SELECT E.ID, E.Estado, PE.Quantidade, (PE.Quantidade * (P.Preco+(P.Preco*P.IVA))) AS total
FROM ENCOMENDA E, PRODUTO_ENCOMENDADO PE, PRODUTO P
	WHERE E.ID = PE.IDEncomenda
	AND P.ID = PE.IDProduto
	AND E.Estado = 'fechada'
	OR E.Estado = 'cancelada'
	GROUP BY E.ID;


CREATE USER 'tavaresoadmin'@'%'				IDENTIFIED BY 'qwerty';
CREATE USER 'tavaresoadmin'@'localhost'		IDENTIFIED BY 'qwerty';
CREATE USER 'toneogrande'@'ninja.org'			IDENTIFIED BY 'aspiragorduras';
CREATE USER 'ricardoopateta'@'ninja.org'	IDENTIFIED BY 'qwerty';

GRANT SELECT, INSERT, UPDATE, DELETE
	ON LOJA_EM_LINHA.*
	TO 'tavaresoadmin'@'%';

GRANT SELECT, UPDATE, DELETE, INSERT
	ON LOJA_EM_LINHA.*
	TO 'tavaresoadmin'@'localhost'
	WITH GRANT OPTION;

GRANT SELECT, INSERT
	ON LOJA_EM_LINHA.*
	TO 'toneogrande'@'ninja.org';

GRANT SELECT, INSERT
	ON LOJA_EM_LINHA.*
	TO 'ricardoopateta'@'ninja.org';