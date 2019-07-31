/** 
 * UNIVERSIDADE FEDERAL DE SERGIPE 
 * DEPARTAMENTO DE SISTEMAS DE INFORMAÇÃO - DSI
 * SISTEMAS DE APOIO A DECISÃO -SAD
 * PROJETAR AMBIENTE DE SUPORTE A DECISÃO BASEADO EM SISTEMA DE ACOMPANHANTES
 * ABRAÃO ALVES E IGOR BRUNO
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
	idade INT
)

CREATE TABLE TB_AUX_OPORTUNIDADE(	
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_tipo_acompanhamento INT NOT NULL,
	id_cliente INT NOT NULL,
	id_servico INT NULL,
	descricao VARCHAR(300) NULL,
	titulo VARCHAR(50) NULL,
	status VARCHAR(45) NULL CHECK (status IN ('ABERTA', 'OCUPADA', 'FINALIZADA'))
)

CREATE TABLE TB_AUX_LOCALIDADE(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_usuario INT NOT NULL, 
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
	idade INT NOT NULL,
	valor_hora NUMERIC(10,2)
)

CREATE TABLE TB_AUX_TRANSACAO(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_servico INT NULL,
	data_transacao DATETIME NULL
)

CREATE TABLE TB_AUX_SERVICO(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	data_solicitacao DATETIME NULL,
	id_acompanhante INT NULL,
	id_cliente INT NULL,
	id_tipo_acompanhamento INT NULL,
	status VARCHAR(45) NULL CHECK(status IN('PENDENTE', 'ACEITA', 'RECUSADA', 'CANCELADA', 'FINALIZADA'))
)

CREATE TABLE TB_AUX_TIPO_ACOMPANHAMENTO(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	descricao VARCHAR(300) NULL,
	tipo_acompanhamento VARCHAR(100) NULL
)


CREATE TABLE TB_AUX_FATO_ACOMPANHAMENTO(
	data_carga DATETIME NOT NULL,
	id_tempo INT NOT NULL,
	id_cliente INT NOT NULL,
	id_acompanhamento INT NOT NULL,
	id_localidade INT NOT NULL,
	id_oportunidade INT NOT NULL,
	id_servico INT NOT NULL,
	id_transacao INT NOT NULL,
	id_faixa_etaria_cliente INT NOT NULL,
	id_faixa_etaria_acompanhante INT NOT NULL,
	id_data_transacao INT NOT NULL,
	id_tipo_acompanhamento INT NOT NULL,
	qtd INT NULL,
	valor NUMERIC(10,2) NULL,
	qtd_candidatos INT NULL
)



/*--------------------------- CRIANDO TABELAS DE VIOLAÇÃO DA AREA DE STAGING ---------------------------*/

CREATE TABLE TB_VIO_CLIENTE(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	nome VARCHAR(45) NULL,
	cpf VARCHAR(11) NULL,
	telefone VARCHAR(13) NULL,
	genero VARCHAR(45) NULL,
	usuario VARCHAR(45) NULL,
	data_nascimento DATE NULL,
	idade INT
)

CREATE TABLE TB_VIO_OPORTUNIDADE(	
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_tipo_acompanhamento INT NOT NULL,
	id_cliente INT NOT NULL,
	id_servico INT NULL,
	descricao VARCHAR(300) NULL,
	titulo VARCHAR(50) NULL,
	status VARCHAR(50) NULL CHECK (status IN ('ABERTA', 'OCUPADA', 'FINALIZADA'))
)

CREATE TABLE TB_VIO_LOCALIDADE(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_usuario INT NOT NULL, 
	estado CHAR(2) NULL,
	cidade VARCHAR(45) NULL,
	rua VARCHAR(45) NULL,
	bairro VARCHAR(45) NULL
)

CREATE TABLE TB_VIO_ACOMPANHANTE(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	nome VARCHAR(45) NULL,
	cpf VARCHAR(11) NULL,
	telefone VARCHAR(13) NULL,
	genero VARCHAR(45) NULL,
	usuario VARCHAR(45) NULL,
	data_nascimento DATE NULL,
	idade INT NOT NULL,
	valor_hora NUMERIC(10,2)
)

CREATE TABLE TB_VIO_TRANSACAO(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	id_servico INT NULL,
	data_transacao DATETIME NULL
)

CREATE TABLE TB_VIO_SERVICO(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	data_solicitacao DATETIME NULL,
	id_acompanhante INT NULL,
	id_cliente INT NULL,
	id_tipo_acompanhamento INT NULL,
	status VARCHAR(45) NULL CHECK(status IN('PENDENTE', 'ACEITA', 'RECUSADA', 'CANCELADA', 'FINALIZADA'))
)

CREATE TABLE TB_VIO_TIPO_ACOMPANHAMENTO(
	data_carga DATETIME NOT NULL,
	codigo INT NOT NULL,
	descricao VARCHAR(300) NULL,
	tipo_acompanhamento VARCHAR(45) NULL
)


CREATE TABLE TB_VIO_FATO_ACOMPANHAMENTO(
	data_carga DATETIME NOT NULL,
	id_tempo INT NOT NULL,
	id_cliente INT NOT NULL,
	id_acompanhamento INT NOT NULL,
	id_localidade INT NOT NULL,
	id_oportunidade INT NOT NULL,
	id_servico INT NOT NULL,
	id_transacao INT NOT NULL,
	id_faixa_etaria_cliente INT NOT NULL,
	id_faixa_etaria_acompanhante INT NOT NULL,
	id_data_transacao INT NOT NULL,
	id_tipo_acompanhamento INT NOT NULL,
	qtd INT NULL,
	valor NUMERIC(10,2) NULL,
	qtd_candidatos INT NULL
)
