DROP DATABASE QueroAcompanhanteSAD;
CREATE DATABASE QueroAcompanhanteSAD;
USE QueroAcompanhanteSAD;
-- -----------------------------------------------------
-- Table DIM_TEMPO
-- -----------------------------------------------------
CREATE TABLE DIM_TEMPO (
  id INT IDENTITY(1,1) NOT NULL,
  nivel VARCHAR(3) NOT NULL,
  data DATE NULL,
  dia SMALLINT NULL,
  nomeDia VARCHAR(20) NULL,
  mes SMALLINT NULL,
  nomeMes VARCHAR(20) NULL,
  trimestre VARCHAR(45) NULL,
  nomeTrimestre VARCHAR(45) NULL,
  semestre VARCHAR(45) NULL,
  nomeSemestre VARCHAR(45) NULL,
  ano SMALLINT NOT NULL
  PRIMARY KEY (id))
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
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_CLIENTE
-- -----------------------------------------------------
CREATE TABLE  DIM_CLIENTE (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  cpf VARCHAR(45) NOT NULL,
  telefone VARCHAR(45) NOT NULL,
  genero VARCHAR(45) NOT NULL,
  usuario VARCHAR(45) NOT NULL,
  idade SMALLINT NOT NULL,
  dataNascimento DATE NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_OPORTUNIDADE
-- -----------------------------------------------------
CREATE TABLE DIM_OPORTUNIDADE (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  titulo VARCHAR(50) NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  status VARCHAR(10) NOT NULL CHECK (status IN ('ABERTA', 'OCUPADA', 'FINALIZADA')),
  dt_inicio DATE NOT NULL,
  dt_fim DATE NULL,
  fl_corrente CHAR(3) NOT NULL,
  PRIMARY KEY (id))


-- -----------------------------------------------------
-- Table DIM_ACOMPANHANTE
-- -----------------------------------------------------
CREATE TABLE DIM_ACOMPANHANTE (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  cpf VARCHAR(45) NOT NULL,
  telefone VARCHAR(45) NOT NULL,
  genero VARCHAR(45) NOT NULL,
  usuario VARCHAR(45) NOT NULL,
  idade INT NOT NULL,
  dataNascimento DATE NOT NULL,
  valorHora DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_SERVICO
-- -----------------------------------------------------
CREATE TABLE DIM_SERVICO (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  status VARCHAR NOT NULL CHECK (status IN('PENDENTE', 'ACEITA', 'RECUSADA', 'CANCELADA', 'FINALIZADA')),
  dt_inicio DATE NOT NULL,
  dt_fim DATE NULL,
  fl_corrente CHAR(3) NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_TRANSACAO
-- -----------------------------------------------------
CREATE TABLE DIM_TRANSACAO (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_FAIXA_ETARIA
-- -----------------------------------------------------
CREATE TABLE DIM_FAIXA_ETARIA (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  idade_inicial INT NOT NULL,
  idade_final INT NOT NULL,
  PRIMARY KEY (id))

-- -----------------------------------------------------
-- Table DIM_TIPO_ACOMPANHAMENTO
-- -----------------------------------------------------
CREATE TABLE DIM_TIPO_ACOMPANHAMENTO (
  id INT IDENTITY(1,1) NOT NULL,
  codigo INT NOT NULL,
  tipo_acompanhamento VARCHAR(45) NOT NULL,
  descricao VARCHAR(300) NOT NULL,
  PRIMARY KEY (id))

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
  idTransacao INT NOT NULL,
  id_faixa_etaria_cliente INT NOT NULL,
  id_faixa_etaria_acompanhante INT NOT NULL,
  id_tipo_acompanhamento INT NOT NULL,
  id_data_transacao INT NULL,
  qtd INT NOT NULL,
  valor DECIMAL(10,0) NOT NULL,
  qtd_candidatos INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT FK_DIM_TEMPO
    FOREIGN KEY(id_tempo)
    REFERENCES DIM_TEMPO(id),
  CONSTRAINT FK_DIM_LOCALIDADE
    FOREIGN KEY(id_localidade)
    REFERENCES DIM_LOCALIDADE(id),
  CONSTRAINT FK_DIM_CLIENTE
    FOREIGN KEY(id_cliente)
    REFERENCES DIM_CLIENTE(id),
  CONSTRAINT FK_DIM_OPORTUNIDADE
    FOREIGN KEY (id_oportunidade)
    REFERENCES DIM_OPORTUNIDADE(id),
  CONSTRAINT FK_DIM_ACOMPANHANTE
    FOREIGN KEY(id_acompanhante)
    REFERENCES DIM_ACOMPANHANTE(id),
  CONSTRAINT FK_DIM_SERVICO
    FOREIGN KEY(id_servico)
    REFERENCES DIM_SERVICO(id),
  CONSTRAINT fk_FATO_ACOMPANHAMENTO_DIM_TRANSACAO1
    FOREIGN KEY(idTransacao)
    REFERENCES DIM_TRANSACAO(id),
  CONSTRAINT fk_FATO_ACOMPANHAMENTO_DIM_FAIXA_ETARIA1
    FOREIGN KEY (id_faixa_etaria_cliente)
    REFERENCES DIM_FAIXA_ETARIA(id),
  CONSTRAINT fk_FATO_ACOMPANHAMENTO_DIM_FAIXA_ETARIA2
    FOREIGN KEY (id_faixa_etaria_acompanhante)
    REFERENCES DIM_FAIXA_ETARIA(id),
  CONSTRAINT fk_FATO_ACOMPANHAMENTO_DIM_TEMPO1
    FOREIGN KEY (id_data_transacao)
    REFERENCES DIM_TEMPO(id),
  CONSTRAINT fk_FATO_ACOMPANHAMENTO_DIM_TIPO_ACOMPANHAMENTO1
    FOREIGN KEY (id_tipo_acompanhamento)
    REFERENCES DIM_TIPO_ACOMPANHAMENTO(id))

-- -----------------------------------------------------
-- PROCEDURES
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_DIM_TEMPO(@INICIO DATE, @FIM DATE)
AS
BEGIN
    DECLARE @QTD_DIAS INT, @DATA DATE, @DIA SMALLINT, @MES SMALLINT, @COUNT SMALLINT, @FIM_MES CHAR(3), @TRIMESTRE SMALLINT,
            @NOME_TRI VARCHAR(20), @SEMESTRE SMALLINT, @NOME_SEMESTRE VARCHAR(20), @ANO SMALLINT, @DATA_TEMP DATE;
    SET @QTD_DIAS = DATEDIFF(DD, @INICIO, @FIM);
    SET @DATA = @INICIO;
    SET NOCOUNT ON

    WHILE(@QTD_DIAS >= 0)
    BEGIN
        SET @QTD_DIAS = @QTD_DIAS - 1;
        SET @COUNT = (SELECT COUNT(id) FROM DIM_TEMPO WHERE @DATA = data);
        IF(@COUNT = 0)
        BEGIN
            SELECT  @ANO = YEAR(@DATA), @MES = MONTH(@DATA), @DIA = day(@DATA);

            SET @SEMESTRE = IIF(@MES <= 6, 1, 2);
            SET @TRIMESTRE =  datepart(qq,@DATA);
            SET @DATA_TEMP = DATEADD(DAY, 1, @DATA);

            SELECT @FIM_MES = IIF(@MES <> MONTH(@DATA_TEMP), 'SIM', 'NAO'),
                @NOME_SEMESTRE = CAST(@SEMESTRE AS VARCHAR(1)) + '° / ' + CAST(@ANO AS VARCHAR(4)),
                @NOME_TRI = CAST(@TRIMESTRE AS VARCHAR(1)) + '° / ' + CAST(@ANO AS VARCHAR(4));

            INSERT INTO DIM_TEMPO (nivel, data, dia, nomeDia, mes, nomeMes, trimestre, nomeTrimestre, semestre, nomeSemestre, ano)
                VALUES('DIA', @DATA, @DIA, DATENAME(DW, @DATA), @MES, DATENAME(MM, @DATA), @TRIMESTRE, @NOME_TRI, @SEMESTRE, @NOME_SEMESTRE, @ANO);

            IF(@FIM_MES = 'SIM')
                INSERT INTO DIM_TEMPO (nivel, data, dia, nomeDia, mes, nomeMes, trimestre, nomeTrimestre, semestre, nomeSemestre, ano)
                VALUES('MES', NULL, NULL, NULL, @MES, DATENAME(MM, @DATA), NULL, NULL, NULL, NULL, @ANO);

            IF(@ANO <> year(@DATA_TEMP))
                INSERT INTO DIM_TEMPO (nivel, data, dia, nomeDia, mes, nomeMes, trimestre, nomeTrimestre, semestre, nomeSemestre, ano)
                VALUES('ANO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @ANO);

            SET @DATA = @DATA_TEMP;
        END
        ELSE
        BEGIN
            SET @DATA = DATEADD(DAY, 1, @DATA);
        END
    END
END

EXEC SP_POVOA_DIM_TEMPO '20191010', '20301010';

select * from DIM_TEMPO;