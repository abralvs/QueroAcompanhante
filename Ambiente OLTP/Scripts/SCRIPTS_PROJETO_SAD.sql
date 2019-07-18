CREATE DATABASE PROJETO_SAD
USE PROJETO_SAD

CREATE TABLE Endereco(
	idEndereco INT IDENTITY(1,1) NOT NULL ,
	estado CHAR(2) NOT NULL,
	cidade VARCHAR(45) NOT NULL,
	rua VARCHAR(45) NOT NULL,
	bairro VARCHAR(45) NOT NULL,
	numero INT NULL,
	PRIMARY KEY (idEndereco)
)


CREATE TABLE Usuario(
	idUsuario INT IDENTITY(1,1) NOT NULL ,
	nome VARCHAR(45) NOT NULL,
	telefone VARCHAR(11) NOT NULL,
	genero VARCHAR(45) NOT NULL,
	cpf VARCHAR(15) NOT NULL,
	dataNascimento DATE NOT NULL,
	email VARCHAR(45) NOT NULL,
	senha VARCHAR(15) NOT NULL,
	descricao VARCHAR(500) NOT NULL,
	PRIMARY KEY (idUsuario)
)


CREATE TABLE Acompanhante(
   idAcompanhante INT IDENTITY(1,1) NOT NULL,
   idUsuario INT NOT NULL,
   valorHora NUMERIC(10,2) NULL DEFAULT NULL,
   credencialContaDigital VARCHAR(45) NULL DEFAULT NULL,
   PRIMARY KEY (idAcompanhante),
   FOREIGN KEY (idUsuario) REFERENCES Usuario (idUsuario)   
)

CREATE TABLE TipoAcompanhamento(
	idTipoAcompanhamento INT IDENTITY(1,1) NOT NULL,
	tipoAcompanhamento VARCHAR(50) NOT NULL,
	descricao VARCHAR(300) NULL,
	PRIMARY KEY(idTipoAcompanhamento)
)


CREATE TABLE Servico (
   idServico INT IDENTITY(1,1) NOT NULL,
   idCliente INT NOT NULL,
   idAcompanhante INT NOT NULL,
   idTipoAcompanhamento INT NOT NULL,
   dataSolicitacao DATETIME NULL DEFAULT NULL,	
   status VARCHAR(45) NOT NULL CHECK(status IN ('PENDENTE','ACEITA','RECUSADA')),
   PRIMARY KEY(idServico),
   FOREIGN KEY (idCliente) REFERENCES Usuario(idUsuario),
   FOREIGN KEY (idAcompanhante) REFERENCES Acompanhante(idAcompanhante),
   FOREIGN KEY (idTipoAcompanhamento) REFERENCES TipoAcompanhamento(idTipoAcompanhamento)
)


CREATE TABLE Mensagem (
   idMensagem INT IDENTITY(1,1) NOT NULL,
   mensagem VARCHAR(300) NULL DEFAULT NULL,
   dataEHora DATETIME NULL DEFAULT NULL,
   idRemetente INT NOT NULL,
   idDestinatario INT NOT NULL,
   idServico INT NOT NULL,
   PRIMARY KEY(idMensagem),
   FOREIGN KEY (idServico) REFERENCES Servico(idServico)
)

CREATE TABLE Oportunidade (
   idOportunidade INT IDENTITY(1,1) NOT NULL,
   descricao VARCHAR(200) NULL DEFAULT NULL,
   idCliente INT NOT NULL,
   idServico INT NULL,
   idTipoAcompanhamento INT NOT NULL, 
   status VARCHAR(45) NULL CHECK(status IN ('ABERTA','OCUPADA','FINALIZADA')),
   FOREIGN KEY (idTipoAcompanhamento) REFERENCES TipoAcompanhamento(idTipoAcompanhamento),
   PRIMARY KEY(idOportunidade),
   FOREIGN KEY (idCliente) REFERENCES Usuario(idUsuario),
   FOREIGN KEY (idServico) REFERENCES Servico(idServico)
)

CREATE TABLE DetalhesEncontro(
   idDetalhesEncontro INT IDENTITY(1,1) NOT NULL,	
   idServico INT NOT NULL,
   dataServico DATETIME NULL DEFAULT NULL,
   horario TIME NULL DEFAULT NULL,
   cidade VARCHAR(45) NULL DEFAULT NULL,
   rua VARCHAR(45) NULL DEFAULT NULL,
   nLocal VARCHAR(45) NULL DEFAULT NULL,
   referencia VARCHAR(100) NULL DEFAULT NULL,
   valor NUMERIC(10,2) NULL DEFAULT NULL,
   PRIMARY KEY (idDetalhesEncontro),
   FOREIGN KEY (idServico) REFERENCES Servico(idServico)
)

CREATE TABLE Candidatura(
   idCandidatura INT IDENTITY(1,1) NOT NULL,
   idAcompanhante INT NOT NULL,
   idOportunidade INT NOT NULL,
   PRIMARY KEY (idCandidatura),
   FOREIGN KEY(idAcompanhante) REFERENCES Acompanhante(idAcompanhante),
   FOREIGN KEY(idOportunidade) REFERENCES Oportunidade(idOportunidade)
)


CREATE TABLE Transacao(
	idTransacao INT IDENTITY(1,1) NOT NULL,
	idServico INT NOT NULL,
	dataEHora DATETIME NOT NULL,
	PRIMARY KEY (idTransacao),
	FOREIGN KEY (idServico) REFERENCES Servico(idServico)
)

/* QUERYS AUXILIARES*/
DROP TABLE Endereco
DROP TABLE Usuario
DROP TABLE Acompanhante
DROP TABLE TipoAcompanhamento
DROP TABLE Servico
DROP TABLE Mensagem 
DROP TABLE Oportunidade
DROP TABLE DetalhesEncontro
DROP TABLE Candidatura
DROP TABLE Transacao

SELECT * FROM endereco
SELECT * FROM Usuario
SELECT * FROM Acompanhante
SELECT * FROM TipoAcompanhamento
SELECT * FROM Servico
SELECT * FROM Mensagem
SELECT * FROM Oportunidade
SELECT * FROM DetalhesEncontro
SELECT * FROM Candidatura
SELECT * FROM Transacao