CREATE DATABASE QueroAcompanhanteSAD
DROP DATABASE QueroAcompanhanteSAD
USE QueroAcompanhanteSAD

/*---------------------------------------- CRIANDO TABELAS DO BANCO  -----------------------------------------------------*/

CREATE TABLE Usuario(
	idUsuario INT IDENTITY(1,1) NOT NULL ,
	nome VARCHAR(45) NOT NULL,
	telefone VARCHAR(13) NOT NULL,
	genero VARCHAR(45) NOT NULL,
	cpf VARCHAR(11) NOT NULL,
	dataNascimento DATE NOT NULL,
	email VARCHAR(45) NOT NULL,
	usuario VARCHAR(45) NOT NULL,
	senha VARCHAR(15) NOT NULL,
	descricao VARCHAR(500) NOT NULL,
	data_atualizacao DATETIME NOT NULL, 
	PRIMARY KEY (idUsuario)
)

CREATE TABLE Endereco( --
	idEndereco INT IDENTITY(1,1) NOT NULL ,
	estado CHAR(2) NOT NULL,
	cidade VARCHAR(45) NOT NULL,
	rua VARCHAR(45) NOT NULL,
	bairro VARCHAR(45) NOT NULL,
	numero INT NULL,
	idUsuario INT NOT NULL,
	data_atualizacao DATETIME NOT NULL,
	PRIMARY KEY (idEndereco),
	FOREIGN KEY (idUsuario) REFERENCES Usuario (idUsuario)	
)

CREATE TABLE Acompanhante(
   idAcompanhante INT NOT NULL,
   valorHora NUMERIC(10,2) NULL DEFAULT NULL,
   credencialContaDigital VARCHAR(45) NULL DEFAULT NULL,
   data_atualizacao DATETIME NOT NULL,
   PRIMARY KEY (idAcompanhante),
   FOREIGN KEY (idAcompanhante) REFERENCES Usuario (idUsuario)   
)

CREATE TABLE TipoAcompanhamento(
	idTipoAcompanhamento INT IDENTITY(1,1) NOT NULL,
	tipoAcompanhamento VARCHAR(100) NOT NULL,
	descricao VARCHAR(300) NULL,
	data_atualizacao DATETIME NOT NULL,
	PRIMARY KEY(idTipoAcompanhamento)
)


CREATE TABLE Servico (
   idServico INT IDENTITY(1,1) NOT NULL,
   idCliente INT NOT NULL,
   idAcompanhante INT NOT NULL,
   idTipoAcompanhamento INT NOT NULL,
   dataSolicitacao DATETIME NULL DEFAULT NULL,	
   status VARCHAR(45) NOT NULL CHECK(status IN ('PENDENTE','ACEITA','RECUSADA','CANCELADA','FINALIZADA')),
   data_atualizacao DATETIME NOT NULL,
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
   data_atualizacao DATETIME NOT NULL,
   PRIMARY KEY(idMensagem),
   FOREIGN KEY (idServico) REFERENCES Servico(idServico)
)

CREATE TABLE Oportunidade (
   idOportunidade INT IDENTITY(1,1) NOT NULL,
   descricao VARCHAR(300) NULL DEFAULT NULL,
   titulo VARCHAR(50) NOT NULL,
   idCliente INT NOT NULL,
   idServico INT DEFAULT NULL,
   idTipoAcompanhamento INT NOT NULL, 
   status VARCHAR(45) NULL CHECK(status IN ('ABERTA','OCUPADA','FINALIZADA')),
   data_atualizacao DATETIME NOT NULL,
   FOREIGN KEY (idTipoAcompanhamento) REFERENCES TipoAcompanhamento(idTipoAcompanhamento),
   PRIMARY KEY(idOportunidade),
   FOREIGN KEY (idCliente) REFERENCES Usuario(idUsuario),
   FOREIGN KEY (idServico) REFERENCES Servico(idServico)
)

CREATE TABLE DetalhesEncontro(
   idDetalhesEncontro INT IDENTITY(1,1) NOT NULL,	
   idServico INT NOT NULL,
   dataServico DATETIME NULL DEFAULT NULL,
   horaInicio TIME NULL DEFAULT NULL,
   horaFim TIME NULL DEFAULT NULL,
   estado char(2) NULL DEFAULT NULL,
   cidade VARCHAR(45) NULL DEFAULT NULL,
   bairro VARCHAR(100) NULL DEFAULT NULL,   
   rua VARCHAR(100) NULL DEFAULT NULL,
   nLocal INT NULL DEFAULT NULL,
   referencia VARCHAR(100) NULL DEFAULT NULL,
   valor NUMERIC(10,2) NULL DEFAULT NULL,
   data_atualizacao DATETIME NOT NULL,
   PRIMARY KEY (idDetalhesEncontro),
   FOREIGN KEY (idServico) REFERENCES Servico(idServico)
)

CREATE TABLE Candidatura(
   idCandidatura INT IDENTITY(1,1) NOT NULL,
   idAcompanhante INT NOT NULL,
   idOportunidade INT NOT NULL,
   data_atualizacao DATETIME NOT NULL,
   PRIMARY KEY (idCandidatura),
   FOREIGN KEY(idAcompanhante) REFERENCES Acompanhante(idAcompanhante),
   FOREIGN KEY(idOportunidade) REFERENCES Oportunidade(idOportunidade)
)

CREATE TABLE Transacao(
	idTransacao INT IDENTITY(1,1) NOT NULL,
	idServico INT NOT NULL,
	dataEHora DATETIME NOT NULL,
	data_atualizacao DATETIME NOT NULL,
	PRIMARY KEY (idTransacao),
	FOREIGN KEY (idServico) REFERENCES Servico(idServico)
)

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

/*---------------------------------------- PROCEDIMENTOS ARMAZENADOS PARA POPULAR O BANCO-----------------------------------------------------*/

EXEC SP_INSERE_USUARIOS
EXEC SP_INSERE_SOLICITACOES_SERVICO
EXEC SP_INSERIR_NEGOCIACAO

DROP PROCEDURE SP_INSERE_USUARIOS
DROP PROCEDURE SP_INSERE_SOLICITACOES_SERVICO
DROP PROCEDURE SP_INSERIR_NEGOCIACAO

-- INSERINDO CLIENTES E ACOMPANHANTES  
CREATE PROCEDURE SP_INSERE_USUARIOS 
AS
	BEGIN
		INSERT INTO Usuario (nome,telefone,genero,cpf,dataNascimento,email,usuario,senha,descricao,data_atualizacao)
		VALUES('IGOR BRUNO','75998719582','MASCULINO','07852892590', CAST('19980524' AS DATETIME),'igorb22@live.com','igorb22','0123456','',GETDATE()),
			  ('ABRAÃO PEREIRA ALVES','79994854123','MASCULINO','07852134569',CAST('19980901' AS DATETIME),'abraao@gmail.com','abralvs','0123456','',GETDATE()),
			  ('JOSIELY DE OLIVEIRA','79998716573','FEMININO','07195693290',CAST('19990106' AS DATETIME),'josy@gmail.com','josi99','josygat','SOU ESTUDANTE DE FISICA E PRESTO ACOMPANHANMENTO ESCOLAR PARA ALUNOS ATÉ 9º ANO E ACOMPANHAMENTO INFANTIL',GETDATE()),
			  ('MARIA APARECIDA','79989527369','FEMININO','06932416590',CAST('19781231' AS DATETIME),'cia@gmail.com','cidaribs','5544asd','OLÁ, ME CHAMO APARECIDA E FAÇO ACOMPANHAMENTO INFANTIL e DOMÉSTICO, ME CONTRATE, POSSO CUIDAR DOS SEUS FILHOS',GETDATE()),
			  ('MARCIA SANTANA','79551166661','FEMININO','07863245980',CAST('19850801' AS DATETIME),'marciasantana@outlook.com','marciasantana','marcinha123','SOU ACADEMICA DE ENFERMAGEM E FAÇO ACOMPANHAMENO MÉDICO POR UM PREÇO JUSTO!',GETDATE()),
			  ('GILMAR RIBEIRO','75998287294','MASCULINO','04763214789',CAST('19810506' AS DATETIME),'gilmar@hotmail.com','gilmarsans','511654S65D','EM BUSCA DE ACOMPANHANTES DOMÉSTICAS E PARA CUIDAR DOS MEUS FILHOS',GETDATE())

		INSERT INTO Endereco (estado,cidade,rua,bairro,numero,idUsuario,data_atualizacao)
		VALUES ('BA','PARIPIRANGA','ZONA RURAL','POV. RASO',00,1,GETDATE()),
			   ('SE','ITABAIANA','RUA EUCLIDES PAES MENDONÇA','CENTRO',600,2,GETDATE()),
			   ('SE','ITABAIANA','RUA CAPITAO JOSÉ FERREIRA','CENTRO',232,3,GETDATE()),
			   ('SE','ITABAIANA','AV. BOANERGES PINHEIRO','CENTRO',144,4,GETDATE()),
			   ('SE','LAGARTO','RUA GETÚLIO VARGAS','CENTRO',186,5,GETDATE()),
			   ('SE','ARACAJU','RUA LARANJEIRAS','BAIRO JARDINS',98,6,GETDATE())


		INSERT INTO Acompanhante (idAcompanhante,valorHora,credencialContaDigital,data_atualizacao)
		VALUES(3,20.00,'HD541DA-1',GETDATE()), 
			  (4,50.00,'00145HJ-X',GETDATE()),
			  (5,120.00,'00012A-0',GETDATE())
	END



GO


-- INSERINDO OPORTUNIDADES, CANDIDATURAS, SOLICITACOES DE SERVICO E TIPOS DE SERVICO
CREATE PROCEDURE SP_INSERE_SOLICITACOES_SERVICO
AS 
	BEGIN

		INSERT INTO TipoAcompanhamento (tipoAcompanhamento,descricao,data_atualizacao)
		VALUES('ACOMPANHAMENTO MÉDICO','ESTE ACOMPANHANTE OFERECE SERVICOS DE ACOMPANHAMENTO EM ATIVIDADES E CUIDADOS MÉDICOS.',GETDATE()),
			  ('ACOMPANHAMENTO INFANTIL','ESTE ACOMPANHANTE OFERECE SERVIÇOS DE BABÁ PARA CRIANÇAS E OUTROS CUIDADOS ESPECIAS',GETDATE()),
			  ('ACOMPANHAMENTO DOMÉSTICO','ESTE ACOMPANHANTE OFERECE SERVIÇOS DE LIMPEZA,COZINHEIRO E OUTROS CUDIADOS DOMÉSTICOS',GETDATE()),
			  ('ACOMPANHAMENTO PARA IDOSOS','ESTE ACOMPANHANTE OFERECE SERVIÇOS DE BABÁ PARA IDOSOS E OUTROS CUIDADOS ESPECIAS',GETDATE()),
			  ('ACOMPANHAMENTO ESCOLAR','ESTE ACOMPANHANTE OFERECE SERVIÇOS  DE AJUDA E REFORÇO ESCOLAR',GETDATE()),
			  ('ACOMPANHAMENTO PARA PESSOAS COM NECESSIDADES ESPECIAIS','ESTE ACOMPANHANTE OFERECE SERVIÇOS DE ACOMPANHAMENTO PARA PESSOAS COM NECESSIDADES ESPECIAIS TAIS COMO DEFICIÊNCIA FÍSICA',GETDATE())


		INSERT INTO Oportunidade (descricao,titulo,idCliente,idTipoAcompanhamento,idServico,status,data_atualizacao)
		VALUES('PROCURO UMA PESSOA PARA FAZER UM ACOMPANHAMENTO MÉDICO COMIGO NO PRÓXIMO FINAL DE SEMANA 21-22/07, HORARIOS A COMBINAR',  'VAGA PARA ACOMPANHANTE MEDICO',6,1,NULL,'ABERTA',GETDATE()),
			  ('PROCURO UMA PESSOA PARA FAZER ACOMPANHAMENTO INFANTIL PARA OS MEUS FILHOS NO PROXIMO FINAL DE SEMANA 21-22/07, HORARIOS A COMBINAR',  'VAGA PARA BABA',6,2,NULL,'ABERTA',GETDATE()),
			  ('PROCURO UMA PESSOA PARA FAZER UM ACOMPANHAMENTO ESCOLAR COMIGO', 'VAGA PARA PROFESSORA DE BANCA',1,5,NULL,'ABERTA',GETDATE())
		

		INSERT INTO Candidatura (idAcompanhante,idOportunidade,data_atualizacao)
		VALUES(5,1,GETDATE()),
			  (4,2,GETDATE()),
			  (3,2,GETDATE()),
			  (3,3,GETDATE())

		INSERT INTO Servico (idCliente,idAcompanhante,idTipoAcompanhamento,dataSolicitacao,status,data_atualizacao)
		VALUES(1,4,3,GETDATE(),'PENDENTE',GETDATE()),
			  (2,3,5,GETDATE(),'PENDENTE',GETDATE()),
			  (1,3,5,GETDATE(),'PENDENTE',GETDATE()),
			  (6,4,3,GETDATE(),'PENDENTE',GETDATE())

		UPDATE Oportunidade SET idServico = 3,data_atualizacao = GETDATE() WHERE idOportunidade = 3

		UPDATE Servico SET status = 'ACEITA',data_atualizacao = GETDATE() WHERE idServico = 1;
		UPDATE Servico SET status = 'RECUSADA',data_atualizacao = GETDATE() WHERE idServico = 2;
		UPDATE Servico SET status = 'ACEITA',data_atualizacao = GETDATE() WHERE idServico = 3;
		UPDATE Servico SET status = 'ACEITA',data_atualizacao = GETDATE() WHERE idServico = 4;

	END

GO

-- INSERINDO A NEGOCIAÇÃO PARA O SERVIÇO, DIALOGOS ENCONTROS E TRANSACOES
CREATE PROCEDURE SP_INSERIR_NEGOCIACAO
AS 
	BEGIN

		INSERT INTO Mensagem (mensagem,dataEHora,idRemetente,idDestinatario,idServico,data_atualizacao)
		VALUES ('Olá bom dia, preciso de uma pessoa para realizar algumas tarefas domésticas na minha casa',GETDATE(),1,4,1,GETDATE()),
			   ('qual o dia ?',GETDATE(),4,1,1,GETDATE()),
			   ('dia 25/07, você pode ?',GETDATE(),1,4,1,GETDATE()),
			   ('posso sim, o dia todo ?',GETDATE(),4,1,1,GETDATE()),
			   ('não, só das 8 até as 12 ',GETDATE(),1,4,1,GETDATE()),
			   ('pronto, pode confirmar o encontro',GETDATE(),4,1,1,GETDATE()),
			   ('Certo.',GETDATE(),1,4,1,GETDATE())

		-- Detalhes Primeiro Encontro
		INSERT INTO DetalhesEncontro (idServico,dataServico,horaInicio,horaFim,estado,cidade,bairro,rua,nLocal,referencia,valor,data_atualizacao)
		VALUES(1,'20190725','08:00:00','12:00:00','SE','ITABAIANA','CENTRO','AV. BOANERGES PINHEIRO',144,'',200.00,GETDATE())


		/*-----------------------------------------------------------------------------------------------------------------------------------*/	
		
		INSERT INTO Mensagem (mensagem,dataEHora,idRemetente,idDestinatario,idServico,data_atualizacao)
		VALUES('Oi',GETDATE(),1,4,3,GETDATE()),
		      ('Olá',GETDATE(),4,1,3,GETDATE()),
			  ('Gostaria de marcar um horario para reforço escolar na disciplina de fisica',GETDATE(),1,4,3,GETDATE()),
			  ('Estou disponivel de segunda a sexta das 8 as 17 horas, tenho local próprio',GETDATE(),4,1,3,GETDATE()),
			  ('Quinta feira dia 25/07 das 14 as 16 você pode me atender ? onde você atende ? ',GETDATE(),1,4,3,GETDATE()),
			  ('Posso sim. É no endereço cadastrado no meu perfil, dê uma olhadinha aí... ',GETDATE(),4,1,3,GETDATE()),
			  ('Pronto, to agendando aqui pelo aplicativo.',GETDATE(),1,4,3,GETDATE()),
			  ('Ok!. Até lá',GETDATE(),4,1,3,GETDATE())
		
		UPDATE Oportunidade SET status = 'OCUPADA',data_atualizacao = GETDATE() WHERE idOportunidade = 3

		-- DETALHES SEGUNDO ENCONTRO
		INSERT INTO DetalhesEncontro (idServico,dataServico,horaInicio,horaFim,estado,cidade,bairro,rua,nLocal,referencia,valor,data_atualizacao)
		VALUES(3,'20190725','08:00:00','12:00:00','SE','ITABAIANA','CENTRO','RUA CAPITAO JOSÉ FERREIRA',232,'',80.00,GETDATE())
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------------*/


		INSERT INTO Mensagem (mensagem,dataEHora,idRemetente,idDestinatario,idServico,data_atualizacao)
		VALUES ('Você trabalha como babá ?',GETDATE(),6,4,4,GETDATE()),
			   ('Trabalho sim moço',GETDATE(),4,6,4,GETDATE()),
			   ('tenho dois filhos pequenos, um de 5 anos e outro de 2',GETDATE(),6,4,4,GETDATE()),
			   ('Você poderia cuidar deles na quinta feira pela manhã ? ',GETDATE(),6,4,4,GETDATE()),	
			   ('quinta feira dia 25/07 ? ',GETDATE(),4,6,4,GETDATE()),
			   ('sim!',GETDATE(),6,4,4,GETDATE()),
			   ('infelizmente já tenho compromisso marcado, não pode ser outro dia ?',GETDATE(),4,6,4,GETDATE()),
			   ('não pode não, vou cancelar a solicitação',GETDATE(),6,4,4,GETDATE()),
			   ('certo!.',GETDATE(),4,6,4,GETDATE())

		-- ENCONTRO CANCELADO
		UPDATE Servico SET status = 'CANCELADA',data_atualizacao = GETDATE() WHERE idServico = 4;

		/*-----------------------------------------------------------------------------------------------------------------------------------*/

		INSERT INTO Transacao (idServico,dataEHora,data_atualizacao)
		VALUES(1,'20190725',GETDATE()),
			  (3,'20190725',GETDATE())

		UPDATE Servico SET status = 'FINALIZADA', data_atualizacao = GETDATE() WHERE idServico = 1;
		UPDATE Servico SET status = 'FINALIZADA', data_atualizacao = GETDATE() WHERE idServico = 3;
	
	END


