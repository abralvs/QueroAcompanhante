/** 
 * UNIVERSIDADE FEDERAL DE SERGIPE 
 * DEPARTAMENTO DE SISTEMAS DE INFORMA??O - DSI
 * SISTEMAS DE APOIO A DECIS?O -SAD
 * PROJETAR AMBIENTE DE SUPORTE A DECIS?O BASEADO EM SISTEMA DE ACOMPANHANTES
 * ABRA?O ALVES E IGOR BRUNO
 * 25/07/2019
 **/
 USE QueroAcompanhanteSAD
 
/*--------------------------- CRIANDO TABELAS AUXILIARES DA AREA DE STAGING ---------------------------*/

CREATE TABLE TB_AUX_CLIENTE(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	nome VARCHAR(45) NULL,
	cpf VARCHAR(11) NULL,
	telefone VARCHAR(13) NULL,
	genero VARCHAR(45) NULL,
	usuario VARCHAR(45) NULL,
	data_nascimento DATE NULL,
	idade INT NULL
) 

CREATE TABLE TB_AUX_OPORTUNIDADE(	
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	titulo VARCHAR(50) NULL,
	descricao VARCHAR(300) NULL,
	status VARCHAR(45) NULL CHECK (status IN ('ABERTA', 'OCUPADA', 'FINALIZADA')),
	eh_publica SMALLINT NOT NULL CHECK (eh_publica IN (1,0)),
	id_tipo_acompanhamento INT NULL,
	qtd_candidatos INT NULL, -- novo campo
)

CREATE TABLE TB_AUX_LOCALIDADE(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_servico INT NULL, 
	estado CHAR(2) NULL,
	cidade VARCHAR(45) NULL,
	rua VARCHAR(45) NULL,
	bairro VARCHAR(45) NULL
)

CREATE TABLE TB_AUX_ACOMPANHANTE(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	nome VARCHAR(45) NULL,
	cpf VARCHAR(11) NULL,
	telefone VARCHAR(13) NULL,
	genero VARCHAR(45) NULL,
	usuario VARCHAR(45) NULL,
	data_nascimento DATE NULL,
	idade INT NULL,
	valor_hora NUMERIC(10,2) NULL
)

CREATE TABLE TB_AUX_TRANSACAO(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_servico INT NULL,
	pagamento_avista SMALLINT NOT NULL CHECK(pagamento_avista IN(1,0)),
	data_transacao DATETIME NULL
)

CREATE TABLE TB_AUX_SERVICO(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_cliente INT NULL,
	id_acompanhante INT NULL,
	id_oportunidade INT NULL,
	valor_total NUMERIC(10,2), -- novo campo
	status VARCHAR(45) NULL CHECK(status IN('EM ANDAMENTO', 'CANCELADA', 'FINALIZADA'))
)

CREATE TABLE TB_AUX_TIPO_ACOMPANHAMENTO(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	descricao VARCHAR(300) NULL,
	tipo_acompanhamento VARCHAR(100) NULL
)


CREATE TABLE TB_AUX_FATO_ACOMPANHAMENTO(
	data_carga DATETIME NOT NULL,
	id_tempo INT  NULL,
	id_cliente INT NULL,
	id_acompanhante INT NULL,
	id_localidade INT NULL,
	id_oportunidade INT  NULL,
	id_servico INT NULL,
	id_transacao INT NULL,
	id_faixa_etaria_cliente INT NULL,
	id_faixa_etaria_acompanhante INT  NULL,
	id_data_transacao INT NULL,
	id_tipo_acompanhamento INT NULL,
	qtd INT NULL,
	valor NUMERIC(10,2) NULL,
	qtd_candidatos INT NULL
)


/*--------------------------- CRIANDO TABELAS DE VIOLACAO DA AREA DE STAGING ---------------------------*/

CREATE TABLE TB_VIO_CLIENTE(
	id INT IDENTITY(1,1) NOT NULL,
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	nome VARCHAR(45) NULL,
	cpf VARCHAR(11) NULL,
	telefone VARCHAR(13) NULL,
	genero VARCHAR(45) NULL,
	usuario VARCHAR(45) NULL,
	data_nascimento DATE NULL,
	idade INT NULL,
	data_violacao DATETIME NOT NULL,
	violacao VARCHAR(100) NOT NULL
	PRIMARY KEY(id)
)

CREATE TABLE TB_VIO_OPORTUNIDADE(
	id INT IDENTITY(1,1) NOT NULL,
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	titulo VARCHAR(50) NULL,
	descricao VARCHAR(300) NULL,
	status VARCHAR(45) NULL CHECK (status IN ('ABERTA', 'OCUPADA', 'FINALIZADA')),
	eh_publica SMALLINT NOT NULL CHECK (eh_publica IN (1,0)),
	id_tipo_acompanhamento INT NULL,
	qtd_candidatos INT NULL, -- novo campo
	data_violacao DATETIME NOT NULL,
	violacao VARCHAR(100) NOT NULL
	PRIMARY KEY(id)
)

CREATE TABLE TB_VIO_LOCALIDADE(
	id INT IDENTITY(1,1) NOT NULL,
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_usuario INT NULL, 
	estado CHAR(2) NULL,
	cidade VARCHAR(45) NULL,
	rua VARCHAR(100) NULL,
	bairro VARCHAR(100) NULL,
	data_violacao DATETIME NOT NULL,
	violacao VARCHAR(100) NOT NULL
	PRIMARY KEY(id)
)

CREATE TABLE TB_VIO_ACOMPANHANTE(
	id INT IDENTITY(1,1) NOT NULL,
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	nome VARCHAR(45) NULL,
	cpf VARCHAR(11) NULL,
	telefone VARCHAR(13) NULL,
	genero VARCHAR(45) NULL,
	usuario VARCHAR(45) NULL,
	data_nascimento DATE NULL,
	idade INT NULL,
	valor_hora NUMERIC(10,2) NULL,
	data_violacao DATETIME NOT NULL,
	violacao VARCHAR(100) NOT NULL
	PRIMARY KEY(id)
)

CREATE TABLE TB_VIO_TRANSACAO(
	id INT IDENTITY(1,1) NOT NULL,
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_servico INT NULL,
	pagamento_avista SMALLINT NOT NULL CHECK(pagamento_avista IN(1,0)),
	data_transacao DATETIME NULL,
	data_violacao DATETIME NOT NULL,
	violacao VARCHAR(100) NOT NULL
	PRIMARY KEY(id)
)

CREATE TABLE TB_VIO_SERVICO(
	id INT IDENTITY(1,1) NOT NULL,
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_cliente INT NULL,
	id_acompanhante INT NULL,
	id_oportunidade INT NOT NULL,
	valor_total NUMERIC(10,2), -- novo campo
	status VARCHAR(45) NULL CHECK(status IN('EM ANDAMENTO', 'CANCELADA', 'FINALIZADA')),
	data_violacao DATETIME NOT NULL,
	violacao VARCHAR(100) NOT NULL
	PRIMARY KEY(id)
)

CREATE TABLE TB_VIO_TIPO_ACOMPANHAMENTO(
	id INT IDENTITY(1,1) NOT NULL,
	data_carga DATETIME NOT NULL,
	codigo INT  NOT NULL,
	descricao VARCHAR(300) NULL,
	tipo_acompanhamento VARCHAR(45) NULL,
	data_violacao DATETIME NOT NULL,
	violacao VARCHAR(100) NOT NULL
	PRIMARY KEY(id)
)


CREATE TABLE TB_VIO_FATO_ACOMPANHAMENTO(
	id INT IDENTITY(1,1) NOT NULL,
	data_carga DATETIME NOT NULL,
	id_tempo INT  NULL,
	id_cliente INT NULL,
	id_acompanhante INT NULL,
	id_localidade INT NULL,
	id_oportunidade INT  NULL,
	id_servico INT NULL,
	id_transacao INT NULL,
	id_faixa_etaria_cliente INT NULL,
	id_faixa_etaria_acompanhante INT  NULL,
	id_data_transacao INT NULL,
	id_tipo_acompanhamento INT NULL,
	qtd INT NULL,
	valor NUMERIC(10,2) NULL,
	qtd_candidatos INT NULL,	
	data_violacao DATETIME NOT NULL,
	violacao VARCHAR(100) NOT NULL
	PRIMARY KEY(id)

)



/*--------------------------- PROCEDIMENTOS DE CARGA DO AMBIENTE OPERACIONAL PARA AREA DE STAGING ---------------------------*/


EXEC SP_OLTP_CARREGA_CLIENTES_E_ACOMPANHANTES '20190721'
EXEC SP_OLTP_CARGAS_SIMPLES '20190721'
EXEC SP_CARREGA_FATO '20190721'

SELECT * FROM TB_AUX_ACOMPANHANTE
SELECT * FROM TB_AUX_CLIENTE
SELECT * FROM TB_AUX_LOCALIDADE
SELECT * FROM TB_AUX_SERVICO
SELECT * FROM TB_AUX_TIPO_ACOMPANHAMENTO
SELECT * FROM TB_AUX_TRANSACAO
SELECT * FROM TB_AUX_OPORTUNIDADE
SELECT * FROM TB_AUX_FATO_ACOMPANHAMENTO

DELETE FROM TB_AUX_ACOMPANHANTE
DELETE FROM TB_AUX_CLIENTE
DELETE FROM TB_AUX_LOCALIDADE
DELETE FROM TB_AUX_SERVICO
DELETE FROM TB_AUX_TIPO_ACOMPANHAMENTO
DELETE FROM TB_AUX_TRANSACAO
DELETE FROM TB_AUX_OPORTUNIDADE
DELETE FROM TB_AUX_FATO_ACOMPANHAMENTO

/* ------------------------------------------------------------------------------------------------------------ */


--- CARREGA DADOS DO AMBIENTE OPERACIONAL PARA AS TABELAS AUXILIARES DE CLIENTE E ACOMPANHANTE
ALTER PROCEDURE SP_OLTP_CARREGA_CLIENTES_E_ACOMPANHANTES (@DATACARGA DATETIME)
AS
	BEGIN
		DECLARE @IDUSUARIO INT
		DECLARE @NOME VARCHAR(45)
		DECLARE @CPF VARCHAR(11)
		DECLARE @TELEFONE VARCHAR(13)
		DECLARE @GENERO VARCHAR(45)
		DECLARE @USUARIO VARCHAR(45)
		DECLARE @NASCIMENTO DATE
		DECLARE @IDADE INT
		DECLARE @VALORHORA NUMERIC(10,2)

		DECLARE USUARIO CURSOR FOR 
		SELECT idUsuario, nome, cpf,telefone, genero, usuario, dataNascimento FROM Usuario WHERE (data_atualizacao >= @DATACARGA)   

		DELETE TB_AUX_CLIENTE WHERE @DATACARGA = data_carga
		DELETE TB_AUX_ACOMPANHANTE WHERE @DATACARGA = data_carga


		OPEN USUARIO
		FETCH USUARIO INTO @IDUSUARIO,@NOME,@CPF,@TELEFONE,@GENERO,@USUARIO,@NASCIMENTO

		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @IDADE = DATEDIFF(mm,@NASCIMENTO,@DATACARGA)/12

				IF (EXISTS (SELECT * FROM Acompanhante WHERE @IDUSUARIO = idAcompanhante))
					BEGIN
						SET @VALORHORA = (SELECT valorHora FROM Acompanhante WHERE @IDUSUARIO = idAcompanhante)

						INSERT INTO TB_AUX_ACOMPANHANTE (data_carga,codigo,nome,cpf,telefone,genero,usuario,data_nascimento,idade,valor_hora)
						VALUES(@DATACARGA,@IDUSUARIO,@NOME,@CPF,@TELEFONE,@GENERO,@USUARIO,@NASCIMENTO,@IDADE,@VALORHORA)
					END
				ELSE 
					BEGIN
						
						INSERT INTO TB_AUX_CLIENTE (data_carga,codigo,nome,cpf,telefone,genero,usuario,data_nascimento,idade)
						VALUES(@DATACARGA,@IDUSUARIO,@NOME,@CPF,@TELEFONE,@GENERO,@USUARIO,@NASCIMENTO,@IDADE)
					END
				FETCH USUARIO INTO @IDUSUARIO,@NOME,@CPF,@TELEFONE,@GENERO,@USUARIO,@NASCIMENTO
			END
			CLOSE USUARIO
			DEALLOCATE USUARIO
	END

GO
/* ------------------------------------------------------------------------------------------------------------ */

--- CARREGA DADOS DO AMBIENTE OPERACIONAL PARA AS TABELAS AUXILIARES DE ENDERECO, OPORTUNIDADE, SERVICO, TRANSACAO, TIPO DE ACOMPANHANMENTO
ALTER PROCEDURE SP_OLTP_CARGAS_SIMPLES (@DATACARGA DATETIME)
AS
	BEGIN
		
		DELETE TB_AUX_LOCALIDADE		  WHERE @DATACARGA = data_carga
		DELETE TB_AUX_TRANSACAO			  WHERE @DATACARGA = data_carga
		DELETE TB_AUX_OPORTUNIDADE		  WHERE @DATACARGA = data_carga
		DELETE TB_AUX_SERVICO			  WHERE @DATACARGA = data_carga
		DELETE TB_AUX_TIPO_ACOMPANHAMENTO WHERE @DATACARGA = data_carga



		INSERT INTO TB_AUX_LOCALIDADE (data_carga,codigo,estado,cidade,rua,bairro,id_servico)
		(SELECT @DATACARGA,idDetalhesEncontro,estado,cidade,rua,bairro,idServico FROM DetalhesEncontro WHERE (data_atualizacao >= @DATACARGA))
	
		INSERT INTO TB_AUX_TRANSACAO (data_carga,codigo,id_servico, pagamento_avista, data_transacao)
		(SELECT @DATACARGA,idTransacao,idServico, pagamento_avista, dataEHora FROM Transacao WHERE (data_atualizacao >= @DATACARGA))

		INSERT INTO TB_AUX_OPORTUNIDADE (data_carga, codigo,titulo,descricao,status,eh_publica,id_tipo_acompanhamento,qtd_candidatos)
		(SELECT @DATACARGA,op.idOportunidade, op.titulo,op.descricao,op.status,op.EhPublica,op.idTipoAcompanhamento,
			(SELECT COUNT(cd.idCandidatura) AS CANDIDATURA  FROM Candidatura as cd 
			Where cd.idOportunidade = op.idOportunidade GROUP BY cd.idOportunidade)
		FROM Oportunidade as op WHERE (data_atualizacao >= @DATACARGA))

		INSERT INTO TB_AUX_SERVICO(data_carga,codigo,id_cliente,id_acompanhante,id_oportunidade,valor_total,status)
		(SELECT @DATACARGA,se.idServico,se.idCliente,se.idAcompanhante,se.idOportunidade,
			(SELECT dt.valor FROM DetalhesEncontro AS dt WHERE dt.idServico = se.idServico),
		status FROM Servico as se WHERE (data_atualizacao >= @DATACARGA))

		INSERT INTO TB_AUX_TIPO_ACOMPANHAMENTO (data_carga,codigo,tipo_acompanhamento,descricao)
		(SELECT @DATACARGA,idTipoAcompanhamento,TipoAcompanhamento,descricao FROM TipoAcompanhamento WHERE (data_atualizacao >= @DATACARGA))
	
	END


GO
/* ------------------------------------------------------------------------------------------------------------ */


--- CARREGA DADOS DAS TABELAS AUXILIARES PARA TABELA AUXILIAR DO FATO
ALTER PROCEDURE SP_CARREGA_FATO (@DATACARGA DATETIME)
AS
	BEGIN
		
		DECLARE @CODIGO INT
		DECLARE @DATASOLICITACAO DATETIME
		DECLARE @IDACOMPANHANTE INT
		DECLARE @IDCLIENTE INT
		DECLARE @IDTIPOACOMPANHAMENTO INT
		DECLARE @STATUS VARCHAR(50)
		DECLARE @IDTEMPO INT
		DECLARE @IDLOCALIDADE INT
		DECLARE @IDOPORTUNIDADE INT
		DECLARE @IDTRANSACAO INT
		DECLARE @IDFAIXAETARIAACOMPANHANTE INT
		DECLARE @IDFAIXAETARIACLEINTE INT
		DECLARE @IDADE INT
		DECLARE @IDTEMPOTRANSACAO INT
		DECLARE @VALOR NUMERIC(10,2)
		DECLARE @QTDCANDIDATOS INT

		DECLARE servico CURSOR FOR 
		SELECT codigo,id_cliente,id_acompanhante,id_oportunidade,valor_total,status 
		FROM TB_AUX_SERVICO WHERE status = 'FINALIZADA'
			   
		DELETE TB_AUX_FATO_ACOMPANHAMENTO WHERE @DATACARGA = data_carga

		OPEN servico
		FETCH servico INTO @CODIGO,@IDCLIENTE,@IDACOMPANHANTE,@IDOPORTUNIDADE,@VALOR,@STATUS

		WHILE(@@FETCH_STATUS = 0)
			BEGIN
				
				SET @IDTEMPO			= (SELECT ID FROM DIM_TEMPO WHERE data = CAST(@DATACARGA AS DATE))
				SET @IDLOCALIDADE		= (SELECT codigo FROM TB_AUX_LOCALIDADE WHERE id_servico = @CODIGO)
				SET @IDTRANSACAO		= (SELECT codigo FROM TB_AUX_TRANSACAO WHERE id_servico = @CODIGO)
				SET @IDADE				= (SELECT idade FROM TB_AUX_ACOMPANHANTE WHERE codigo = @IDACOMPANHANTE)
				SET @IDFAIXAETARIAACOMPANHANTE = (SELECT id FROM DIM_FAIXA_ETARIA WHERE @IDADE >= idade_inicial AND @IDADE <= idade_final)
				SET @IDADE					   = (SELECT idade FROM TB_AUX_CLIENTE WHERE codigo = @IDCLIENTE)
				SET @IDFAIXAETARIACLEINTE	   = (SELECT id FROM DIM_FAIXA_ETARIA WHERE @IDADE >= idade_inicial AND @IDADE <= idade_final)
				SET @IDTEMPOTRANSACAO		   = (SELECT id FROM DIM_TEMPO WHERE data = CAST((SELECT data_transacao FROM TB_AUX_TRANSACAO WHERE id_servico = @CODIGO) AS DATE))
				SET @QTDCANDIDATOS			   = (SELECT qtd_candidatos FROM TB_AUX_OPORTUNIDADE WHERE @IDOPORTUNIDADE = codigo)

				INSERT INTO TB_AUX_FATO_ACOMPANHAMENTO (data_carga,id_tempo,id_cliente,id_acompanhante,id_localidade,id_oportunidade,id_servico,id_transacao,id_faixa_etaria_cliente,id_faixa_etaria_acompanhante,id_data_transacao,id_tipo_acompanhamento,qtd,valor,qtd_candidatos)
				VALUES(@DATACARGA,@IDTEMPO,@IDCLIENTE,@IDACOMPANHANTE,@IDLOCALIDADE,@IDOPORTUNIDADE,@CODIGO,@IDTRANSACAO,@IDFAIXAETARIACLEINTE,@IDFAIXAETARIAACOMPANHANTE,@IDTEMPOTRANSACAO,@IDTIPOACOMPANHAMENTO,1,@VALOR,isnull(@QTDCANDIDATOS,0))


				FETCH servico INTO @CODIGO,@IDCLIENTE,@IDACOMPANHANTE,@IDOPORTUNIDADE,@VALOR,@STATUS
			END
			CLOSE servico
			DEALLOCATE servico
	END	