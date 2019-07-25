USE QueroAcompanhanteSAD;

-- -----------------------------------------------------
-- Table DIM_TEMPO
-- -----------------------------------------------------
CREATE TABLE DIM_TEMPO (
  id INT NOT NULL,
  data DATE NOT NULL,
  dia SMALLINT NOT NULL,
  nomeDia VARCHAR(20) NOT NULL,
  mes SMALLINT NOT NULL,
  nomeMes VARCHAR(20) NOT NULL,
  ano SMALLINT NOT NULL,
  semestre VARCHAR(45) NOT NULL,
  trimestre VARCHAR(45) NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_LOCALIDADE
-- -----------------------------------------------------
CREATE TABLE DIM_LOCALIDADE (
  id INT NOT NULL,
  codigo INT NOT NULL,
  estado VARCHAR(45) NOT NULL,
  cidade VARCHAR(45) NOT NULL,
  rua VARCHAR(45) NOT NULL,
  bairro VARCHAR(45) NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_CLIENTE
-- -----------------------------------------------------
CREATE TABLE DIM_CLIENTE (
  id INT NOT NULL,
  codigo INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  cpf VARCHAR(45) NOT NULL,
  telefone VARCHAR(45) NOT NULL,
  genero VARCHAR(45) NOT NULL,
  usuario VARCHAR(45) NOT NULL,
  dataNascimento DATE NOT NULL,
  idade SMALLINT NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_TRANSACAO
-- -----------------------------------------------------
CREATE TABLE DIM_TRANSACAO (
  id INT NOT NULL,
  codigo INT NOT NULL,
  data DATE NOT NULL,
  nomeCliente VARCHAR(45) NOT NULL,
  nomeAcompanhante VARCHAR(45) NOT NULL,
  valor DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_OPORTUNIDADE
-- -----------------------------------------------------
CREATE TABLE DIM_OPORTUNIDADE (
  id INT NOT NULL,
  codigo INT NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  nomeCliente VARCHAR(45) NOT NULL,
  status VARCHAR(45) NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_ACOMPANHANTE
-- -----------------------------------------------------
CREATE TABLE DIM_ACOMPANHANTE (
  id INT NOT NULL,
  codigo INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  cpf VARCHAR(45) NOT NULL,
  telefone VARCHAR(45) NOT NULL,
  genero VARCHAR(45) NOT NULL,
  usuario VARCHAR(45) NOT NULL,
  dataNascimento DATE NOT NULL,
  idade SMALLINT NOT NULL,
  valorHora DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_SERVICO
-- -----------------------------------------------------
CREATE TABLE DIM_SERVICO (
  id INT NOT NULL,
  codigo INT NOT NULL,
  nomeCliente VARCHAR(45) NOT NULL,
  nomeAcompanhante VARCHAR(45) NOT NULL,
  status VARCHAR(45) NOT NULL,
  valor DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table FATO_ACOMPANHAMENTO
-- -----------------------------------------------------
CREATE TABLE FATO_ACOMPANHAMENTO (
  id INT NOT NULL,
  id_tempo INT NOT NULL,
  id_cliente INT NOT NULL,
  id_acompanhante INT NOT NULL,
  id_localidade INT NOT NULL,
  id_oportunidade INT NOT NULL,
  id_trasancao INT NOT NULL,
  id_servico INT NOT NULL,
  qtd INT NOT NULL,
  valor DECIMAL(10,0) NOT NULL,
  qtd_candidatos INT NOT NULL,
  PRIMARY KEY (id),
  INDEX FK_DIM_LOCALIDADE_idx (id_localidade ASC),
  INDEX FK_DIM_CLIENTE_idx (id_cliente ASC),
  INDEX FK_DIM_TEMPO_idx (id_tempo ASC),
  INDEX FK_DIM_TRANSACAO_idx (id_trasancao ASC),
  INDEX FK_DIM_OPORTUNIDADE_idx (id_oportunidade ASC),
  INDEX FK_DIM_ACOMPANHANTE_idx (id_acompanhante ASC),
  INDEX FK_DIM_SERVICO_idx (id_servico ASC),
  CONSTRAINT FK_DIM_TEMPO
    FOREIGN KEY (id_tempo)
    REFERENCES DIM_TEMPO (id),
  CONSTRAINT FK_DIM_LOCALIDADE
    FOREIGN KEY (id_localidade)
    REFERENCES DIM_LOCALIDADE (id),
  CONSTRAINT FK_DIM_CLIENTE
    FOREIGN KEY (id_cliente)
    REFERENCES DIM_CLIENTE (id),
  CONSTRAINT FK_DIM_TRANSACAO
    FOREIGN KEY (id_trasancao)
    REFERENCES DIM_TRANSACAO (id),
  CONSTRAINT FK_DIM_OPORTUNIDADE
    FOREIGN KEY (id_oportunidade)
    REFERENCES DIM_OPORTUNIDADE (id),
  CONSTRAINT FK_DIM_ACOMPANHANTE
    FOREIGN KEY (id_acompanhante)
    REFERENCES DIM_ACOMPANHANTE (id),
  CONSTRAINT FK_DIM_SERVICO
    FOREIGN KEY (id_servico)
    REFERENCES DIM_SERVICO (id)
    )