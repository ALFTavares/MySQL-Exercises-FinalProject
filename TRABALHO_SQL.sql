CREATE DATABASE Exercicio4;

USE Exercicio4;

CREATE TABLE Membro(
			CodigoMembro				INTEGER PRIMARY KEY AUTO_INCREMENT,
			Nome							VARCHAR (30) NOT NULL UNIQUE,
			DataEntrada					DATETIME NOT NULL,
			DataSaida					DATETIME NOT NULL,
			Email							VARCHAR(30) NOT NULL
			);

CREATE TABLE Gestor(
			CodigoMembro				INTEGER , 
			EmailResponsavel			VARCHAR(30) NOT NULL,
											FOREIGN KEY (CodigoMembro) REFERENCES Membro(CodigoMembro)
											 );
			
CREATE TABLE Coordenador(
			CodigoMembro				INTEGER,
			Certificado          	VARCHAR(3) DEFAULT 'Não' NOT NULL,
											 CHECK (Certificado = 'Sim' OR Certificado = 'Não'),
											 FOREIGN KEY (CodigoMembro) REFERENCES Membro(CodigoMembro)
											 );
										
CREATE TABLE Engenheiro(
			CodigoMembro				INTEGER,
			Especialidade				VARCHAR (20) NOT NULL DEFAULT 'Software',
											FOREIGN KEY (CodigoMembro) REFERENCES Membro(CodigoMembro)
											 );
		
CREATE TABLE Tarefa(
			CodigoTarefa				INTEGER PRIMARY KEY AUTO_INCREMENT,
			EstadoTarefa				VARCHAR (20) NOT NULL DEFAULT 'por_iniciar',
											CHECK(EstadoTarefa = 'por_iniciar' OR EstadoTarefa = 'iniciada'OR EstadoTarefa = 'bloqueada'OR EstadoTarefa = 'suspensa')
				);									

			
drop database Exercicio4;