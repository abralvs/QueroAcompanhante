/** 
 * UNIVERSIDADE FEDERAL DE SERGIPE 
 * DEPARTAMENTO DE SISTEMAS DE INFORMAÇÃO - DSI
 * SISTEMAS DE APOIO A DECISÃO -SAD
 * PROJETAR AMBIENTE DE SUPORTE A DECISÃO BASEADO EM SISTEMA DE ACOMPANHANTES
 * ABRAÃO ALVES E IGOR BRUNO
 **/


CREATE DATABASE QueroAcompanhanteSAD;
USE QueroAcompanhanteSAD;

-- -----------------------------------------------------
-- Table DIM_TEMPO
-- -----------------------------------------------------
CREATE TABLE DIM_TEMPO (
  id INT IDENTITY(1,1) NOT NULL,
  data DATE NOT NULL,
  dia SMALLINT NOT NULL,
  nomeDia VARCHAR(20) NOT NULL,
  mes SMALLINT NOT NULL,
  nomeMes VARCHAR(20) NOT NULL,
  semestre VARCHAR(45) NOT NULL,
  trimestre VARCHAR(45) NOT NULL,
  ano SMALLINT NOT NULL,
  PRIMARY KEY (id)
)

-- -----------------------------------------------------
-- Table DIM_FAIXA_ETARIA
-- -----------------------------------------------------
CREATE TABLE DIM_FAIXA_ETARIA (
  id INT IDENTITY(1,1) NOT NULL,
  descricao VARCHAR(50) NOT NULL,
  idade_inicial INT NOT NULL,
  idade_final INT NOT NULL,
  PRIMARY KEY (id)
)

-- -----------------------------------------------------
-- Table DIM_FAIXA_ETARIA
-- -----------------------------------------------------
CREATE TABLE DIM_TIPO_ACOMPANHAMENTO (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  tipo_acompanhamento VARCHAR(45) NOT NULL,
  descricao VARCHAR(300) NOT NULL,
  PRIMARY KEY (id)
)

-- -----------------------------------------------------
-- Table DIM_LOCALIDADE
-- -----------------------------------------------------
CREATE TABLE DIM_LOCALIDADE (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  estado VARCHAR(45) NOT NULL,
  cidade VARCHAR(45) NOT NULL,
  rua VARCHAR(45) NOT NULL,
  bairro VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
)

-- -----------------------------------------------------
-- Table DIM_CLIENTE
-- -----------------------------------------------------
CREATE TABLE DIM_CLIENTE (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  cpf VARCHAR(11) NOT NULL,
  telefone VARCHAR(13) NOT NULL,
  genero VARCHAR(45) NOT NULL,
  usuario VARCHAR(45) NOT NULL,
  dataNascimento DATE NOT NULL,
  idade SMALLINT NOT NULL,
  PRIMARY KEY (id)
)

-- -----------------------------------------------------
-- Table DIM_TRANSACAO
-- -----------------------------------------------------
CREATE TABLE DIM_TRANSACAO (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  PRIMARY KEY (id)
)

-- -----------------------------------------------------
-- Table DIM_OPORTUNIDADE
-- -----------------------------------------------------
CREATE TABLE DIM_OPORTUNIDADE (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  titulo VARCHAR(50) NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  status VARCHAR(45) NOT NULL CHECK (status IN ('ABERTA', 'OCUPADA', 'FINALIZADA')),
  dt_inicio DATE NOT NULL,
  dt_fim DATE NULL,
  fl_corrente CHAR(3) NOT NULL CHECK(fl_corrente IN ('SIM','NAO')),
  PRIMARY KEY (id)
)
-- -----------------------------------------------------
-- Table DIM_ACOMPANHANTE
-- -----------------------------------------------------
CREATE TABLE DIM_ACOMPANHANTE (
  id INT  IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  cpf VARCHAR(45) NOT NULL,
  telefone VARCHAR(45) NOT NULL,
  genero VARCHAR(45) NOT NULL,
  usuario VARCHAR(45) NOT NULL,
  idade SMALLINT NOT NULL,
  dataNascimento DATE NOT NULL,
  valorHora DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (id)
)
-- -----------------------------------------------------
-- Table DIM_SERVICO
-- -----------------------------------------------------
CREATE TABLE DIM_SERVICO (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  status VARCHAR(45) NOT NULL CHECK (status IN ('PENDENTE', 'ACEITA', 'RECUSADA', 'CANCELADA', 'FINALIZADA')),
  dt_inicio DATE NOT NULL,
  dt_fim DATE NULL,
  fl_corrente CHAR(3) NOT NULL CHECK(fl_corrente IN ('SIM','NAO')),
  PRIMARY KEY (id)
)

-- -----------------------------------------------------
-- Table FATO_ACOMPANHAMENTO
-- -----------------------------------------------------
CREATE TABLE FATO_ACOMPANHAMENTO (
  id INT IDENTITY(1,1) NOT NULL,
  id_tempo INT NOT NULL,
  id_cliente INT NOT NULL,
  id_acompanhante INT NOT NULL,
  id_localidade INT NOT NULL,
  id_oportunidade INT NOT NULL,
  id_servico INT NOT NULL,
  id_trasancao INT NOT NULL,
  id_faixa_etaria_cliente INT NOT NULL,
  id_faixa_etaria_acompanhante INT NOT NULL,
  id_data_transacao INT NULL,
  id_tipo_acompanhamento INT NOT NULL,
  qtd INT NOT NULL,
  valor DECIMAL(10,0) NOT NULL,
  qtd_candidatos INT NOT NULL,
  PRIMARY KEY (id), 
  CONSTRAINT FK_DIM_TEMPO FOREIGN KEY (id_tempo) REFERENCES DIM_TEMPO (id),
  CONSTRAINT FK_DIM_CLIENTE FOREIGN KEY (id_cliente) REFERENCES DIM_CLIENTE (id),
  CONSTRAINT FK_DIM_ACOMPANHANTE FOREIGN KEY (id_acompanhante) REFERENCES DIM_ACOMPANHANTE (id),
  CONSTRAINT FK_DIM_LOCALIDADE FOREIGN KEY (id_localidade) REFERENCES DIM_LOCALIDADE (id),
  CONSTRAINT FK_DIM_OPORTUNIDADE FOREIGN KEY (id_oportunidade) REFERENCES DIM_OPORTUNIDADE (id),
  CONSTRAINT FK_DIM_SERVICO FOREIGN KEY (id_servico) REFERENCES DIM_SERVICO (id), 
  CONSTRAINT FK_DIM_TRANSACAO FOREIGN KEY (id_trasancao) REFERENCES DIM_TRANSACAO (id),
  CONSTRAINT FK_DIM_FAIXA_ETARIA_CLIENTE FOREIGN KEY (id_faixa_etaria_cliente) REFERENCES DIM_FAIXA_ETARIA (id),
  CONSTRAINT FK_DIM_FAIXA_ETARIA_ACOMPANHANTE FOREIGN KEY (id_faixa_etaria_acompanhante) REFERENCES DIM_FAIXA_ETARIA (id),
  CONSTRAINT FK_DIM_TEMPO_DATA_TRANSACAO FOREIGN KEY (id_data_transacao) REFERENCES DIM_TEMPO (id),
  CONSTRAINT FK_DIM_TIPO_ACOMPANHAMENTO FOREIGN KEY (id_tipo_acompanhamento) REFERENCES DIM_TIPO_ACOMPANHAMENTO (id)
)