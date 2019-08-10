/**
 * UNIVERSIDADE FEDERAL DE SERGIPE
 * DEPARTAMENTO DE SISTEMAS DE INFORMAÇÃO - DSI
 * SISTEMAS DE APOIO A DECISÃO -SAD
 * PROJETAR AMBIENTE DE SUPORTE A DECISÃO BASEADO EM SISTEMA DE ACOMPANHANTES
 * ABRAÃO ALVES E IGOR BRUNO
 **/
DROP DATABASE QueroAcompanhanteSAD;
CREATE DATABASE QueroAcompanhanteSAD;
USE QueroAcompanhanteSAD;
-- -----------------------------------------------------
-- Table DIM_TEMPO
-- -----------------------------------------------------
CREATE TABLE DIM_TEMPO (
                           id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
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
)

-- -----------------------------------------------------
-- Table DIM_LOCALIDADE
-- -----------------------------------------------------
CREATE TABLE DIM_LOCALIDADE (
                                id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
                                codigo_localidade INT NOT NULL,
                                estado VARCHAR(45) NOT NULL,
                                cidade VARCHAR(45) NOT NULL,
                                rua VARCHAR(100) NOT NULL,
                                bairro VARCHAR(100) NOT NULL
)

-- -----------------------------------------------------
-- Table DIM_CLIENTE
-- -----------------------------------------------------
CREATE TABLE  DIM_CLIENTE (
                              id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
                              codigo_cliente INT NOT NULL,
                              nome VARCHAR(45) NOT NULL,
                              cpf VARCHAR(45) NOT NULL,
                              telefone VARCHAR(45) NOT NULL,
                              genero VARCHAR(45) NOT NULL,
                              usuario VARCHAR(45) NOT NULL,
                              idade SMALLINT NOT NULL,
                              dataNascimento DATE NOT NULL
)

-- -----------------------------------------------------
-- Table DIM_OPORTUNIDADE
-- -----------------------------------------------------
CREATE TABLE DIM_OPORTUNIDADE (
                                  id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
                                  codigo_oportunidade INT NOT NULL,
                                  titulo VARCHAR(50) NOT NULL,
                                  descricao VARCHAR(45) NOT NULL,
                                  status VARCHAR(10) NOT NULL CHECK (status IN ('ABERTA', 'OCUPADA', 'FINALIZADA')),
                                  dt_inicio DATE NOT NULL,
                                  dt_fim DATE NULL,
                                  fl_corrente CHAR(3) NOT NULL CHECK(fl_corrente IN ('SIM','NAO'))
)


-- -----------------------------------------------------
-- Table DIM_ACOMPANHANTE
-- -----------------------------------------------------
CREATE TABLE DIM_ACOMPANHANTE (
                                  id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
                                  codigo_acompanhante INT NOT NULL,
                                  nome VARCHAR(45) NOT NULL,
                                  cpf VARCHAR(45) NOT NULL,
                                  telefone VARCHAR(45) NOT NULL,
                                  genero VARCHAR(45) NOT NULL,
                                  usuario VARCHAR(45) NOT NULL,
                                  idade INT NOT NULL,
                                  dataNascimento DATE NOT NULL,
                                  valorHora DECIMAL(10,0) NOT NULL
)

-- -----------------------------------------------------
-- Table DIM_SERVICO
-- -----------------------------------------------------
CREATE TABLE DIM_SERVICO (
                             id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
                             codigo_servico INT NOT NULL,
                             status VARCHAR NOT NULL CHECK (status IN('PENDENTE', 'ACEITA', 'RECUSADA', 'CANCELADA', 'FINALIZADA')),
                             dt_inicio DATE NOT NULL,
                             dt_fim DATE NULL,
                             fl_corrente CHAR(3) NOT NULL CHECK(fl_corrente IN ('SIM','NAO'))
)

-- -----------------------------------------------------
-- Table DIM_TRANSACAO
-- -----------------------------------------------------
CREATE TABLE DIM_TRANSACAO (
                               id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
                               codigo_transacao INT NOT NULL
)

-- -----------------------------------------------------
-- Table DIM_FAIXA_ETARIA
-- -----------------------------------------------------
CREATE TABLE DIM_FAIXA_ETARIA (
                                  id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
                                  codigo_faixa_etaria INT NOT NULL,
                                  descricao VARCHAR(45) NOT NULL,
                                  idade_inicial INT NOT NULL,
                                  idade_final INT NOT NULL
)

-- -----------------------------------------------------
-- Table DIM_TIPO_ACOMPANHAMENTO
-- -----------------------------------------------------
CREATE TABLE DIM_TIPO_ACOMPANHAMENTO (
                                         id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
                                         codigo_tipo_acompanhante INT NOT NULL,
                                         tipo_acompanhamento VARCHAR(45) NOT NULL,
                                         descricao VARCHAR(300) NOT NULL
)

-- -----------------------------------------------------
-- Table FATO_ACOMPANHAMENTO
-- -----------------------------------------------------
CREATE TABLE FATO_ACOMPANHAMENTO (
                                     id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
                                     id_tempo INT NOT NULL,
                                     id_cliente INT NOT NULL,
                                     id_acompanhante INT NOT NULL,
                                     id_localidade INT NOT NULL,
                                     id_oportunidade INT NULL,
                                     id_servico INT NOT NULL,
                                     id_transacao INT NOT NULL,
                                     id_faixa_etaria_cliente INT NOT NULL,
                                     id_faixa_etaria_acompanhante INT NOT NULL,
                                     id_tipo_acompanhamento INT NOT NULL,
                                     id_data_transacao INT NULL,
                                     qtd INT NOT NULL,
                                     valor DECIMAL(10,0) NOT NULL,
                                     qtd_candidatos INT NOT NULL,
                                     CONSTRAINT FK_DIM_TEMPO FOREIGN KEY(id_tempo) REFERENCES DIM_TEMPO(id),
                                     CONSTRAINT FK_DIM_LOCALIDADE FOREIGN KEY(id_localidade) REFERENCES DIM_LOCALIDADE(id),
                                     CONSTRAINT FK_DIM_CLIENTE FOREIGN KEY(id_cliente) REFERENCES DIM_CLIENTE(id),
                                     CONSTRAINT FK_DIM_OPORTUNIDADE FOREIGN KEY (id_oportunidade) REFERENCES DIM_OPORTUNIDADE(id),
                                     CONSTRAINT FK_DIM_ACOMPANHANTE FOREIGN KEY(id_acompanhante) REFERENCES DIM_ACOMPANHANTE(id),
                                     CONSTRAINT FK_DIM_SERVICO FOREIGN KEY(id_servico) REFERENCES DIM_SERVICO(id),
                                     CONSTRAINT Fk_DIM_TRANSACAO FOREIGN KEY(id_transacao) REFERENCES DIM_TRANSACAO(id),
                                     CONSTRAINT Fk_DIM_FAIXA_ETARIA_CLIENTE FOREIGN KEY (id_faixa_etaria_cliente) REFERENCES DIM_FAIXA_ETARIA(id),
                                     CONSTRAINT Fk_DIM_FAIXA_ETARIA_ACOMPANHANTE FOREIGN KEY (id_faixa_etaria_acompanhante) REFERENCES DIM_FAIXA_ETARIA(id),
                                     CONSTRAINT Fk_DIM_TEMPO_DATA_TRANSACAO FOREIGN KEY (id_data_transacao) REFERENCES DIM_TEMPO(id),
                                     CONSTRAINT Fk_DIM_TIPO_ACOMPANHAMENTO FOREIGN KEY (id_tipo_acompanhamento) REFERENCES DIM_TIPO_ACOMPANHAMENTO(id)
)

-- -----------------------------------------------------
-- EXECUTA PROCEDURES
-- -----------------------------------------------------
EXEC SP_POVOA_DIM_TEMPO              '20180101', '20300101';
EXEC SP_POVOA_DIMS                   '20190721';
EXEC SP_POVOA_FATO_ACOMPANHAMENTO    '20190721';
-- -----------------------------------------------------
-- PROCEDURE CARGA_DIMENSOES
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_DIMS(@DATA DATE)
AS
BEGIN
    EXEC SP_POVOA_DIM_CLIENTE                @DATA;
    EXEC SP_POVOA_DIM_ACOMPANHANTE           @DATA;
    EXEC SP_POVOA_DIM_LOCALIDADE             @DATA;
    EXEC SP_POVOA_DIM_OPORTUNIDADE           @DATA;
    EXEC SP_POVOA_DIM_SERVICO                @DATA;
    EXEC SP_POVOA_DIM_TIPO_ACOMPANHAMETO     @DATA;
    EXEC SP_POVOA_DIM_TRANSACAO              @DATA;
    EXEC SP_POVOA_DIM_FAIXA_ETARIA           @DATA;
END

-- -----------------------------------------------------
-- PROCEDURE DIM_TEMPO
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

-- -----------------------------------------------------
-- PROCEDURE DIM_LOCALIDADE
-- -----------------------------------------------------

CREATE PROCEDURE SP_POVOA_DIM_LOCALIDADE(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE CURSOR_LOC CURSOR FOR SELECT CODIGO,
                                         ID_SERVICO,
                                         ESTADO,
                                         CIDADE,
                                         RUA,
                                         BAIRRO
                                  FROM TB_AUX_LOCALIDADE
                                  WHERE DATA_CARGA = @DATA_CARGA;
    DECLARE
        @CODIGO_LOCALIDADE INT, @ID_SERVICO INT, @ESTADO CHAR(2), @CIDADE VARCHAR(45), @RUA VARCHAR(2), @BAIRRO VARCHAR(45);

    OPEN CURSOR_LOC;
    FETCH CURSOR_LOC INTO @CODIGO_LOCALIDADE, @ID_SERVICO, @ESTADO, @CIDADE, @RUA, @BAIRRO;
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (@ESTADO IS NULL OR @CIDADE IS NULL OR @RUA IS NULL OR @BAIRRO IS NULL)
            INSERT INTO TB_VIO_LOCALIDADE(DATA_CARGA, CODIGO, ID_USUARIO, ESTADO, CIDADE, RUA, BAIRRO, DATA_VIOLACAO,
                                          VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO_LOCALIDADE, @ID_SERVICO, @ESTADO, @CIDADE, @RUA, @BAIRRO, GETDATE(),
                    'VIOLAÇÃO COM ATRIBUTO QUE É NULO');
        ELSE
            INSERT INTO DIM_LOCALIDADE(CODIGO_LOCALIDADE, ESTADO, CIDADE, RUA, BAIRRO)
            VALUES (@CODIGO_LOCALIDADE, @ESTADO, @CIDADE, @RUA, @BAIRRO);
        FETCH CURSOR_LOC INTO @CODIGO_LOCALIDADE, @ID_SERVICO, @ESTADO, @CIDADE, @RUA, @BAIRRO;
    END
    CLOSE CURSOR_LOC;
    DEALLOCATE CURSOR_LOC;
END

-- -----------------------------------------------------
-- PROCEDURE DIM_CLIENTE
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_DIM_CLIENTE(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE CURSOR_CLI CURSOR FOR SELECT
                                         CODIGO,
                                         NOME,
                                         CPF,
                                         TELEFONE,
                                         GENERO,
                                         USUARIO,
                                         IDADE,
                                         DATA_NASCIMENTO
                                  FROM TB_AUX_CLIENTE
                                  WHERE DATA_CARGA = @DATA_CARGA;
    DECLARE
        @CODIGO_CLIENTE INT, @NOME VARCHAR(45), @CPF VARCHAR(11), @TELEFONE VARCHAR(13), @GENERO VARCHAR(45),
        @USUARIO VARCHAR(45), @IDADE SMALLINT, @DT_NASC DATE;

    OPEN CURSOR_CLI;
    FETCH CURSOR_CLI INTO @CODIGO_CLIENTE, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @IDADE, @DT_NASC;
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (@NOME IS NULL OR @CPF IS NULL OR @TELEFONE IS NULL OR @GENERO IS NULL OR @USUARIO IS NULL
            OR @IDADE IS NULL OR @DT_NASC IS NULL)
            INSERT INTO TB_VIO_CLIENTE(DATA_CARGA, CODIGO, NOME, CPF, TELEFONE, GENERO, USUARIO, DATA_NASCIMENTO,
                                       IDADE, DATA_VIOLACAO, VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO_CLIENTE, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @DT_NASC, @IDADE, GETDATE(),
                    'VIOLAÇÃO COM ATRIBUTO QUE É NULO');
        ELSE

            INSERT INTO DIM_CLIENTE(CODIGO_CLIENTE, NOME, CPF, TELEFONE, GENERO, USUARIO, IDADE, DATANASCIMENTO)
            VALUES (@CODIGO_CLIENTE, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @IDADE, @DT_NASC);
        FETCH CURSOR_CLI INTO @CODIGO_CLIENTE, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @IDADE, @DT_NASC;
    END
    CLOSE CURSOR_CLI;
    DEALLOCATE CURSOR_CLI;
END

-- -----------------------------------------------------
-- PROCEDURE DIM_OPORTUNIDADE
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_DIM_OPORTUNIDADE(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE @COUNTER SMALLINT;
    DECLARE
        @CODIGO_OPORTUNIDADE INT, @ID_TIPO_ACOMP INT, @ID_CLIENTE INT, @ID_SERVICO INT, @TITULO VARCHAR(50), @DESCRICAO VARCHAR(300), @STATUS VARCHAR(45);
    DECLARE CURSOR_OP CURSOR FOR SELECT CODIGO,
                                        ID_TIPO_ACOMPANHAMENTO,
                                        ID_CLIENTE,
                                        ID_SERVICO,
                                        DESCRICAO,
                                        TITULO,
                                        STATUS
                                 FROM TB_AUX_OPORTUNIDADE
                                 WHERE DATA_CARGA = @DATA_CARGA;

    OPEN CURSOR_OP;
    FETCH CURSOR_OP INTO @CODIGO_OPORTUNIDADE, @ID_TIPO_ACOMP, @ID_CLIENTE, @ID_SERVICO, @DESCRICAO, @TITULO, @STATUS
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (@STATUS IS NULL OR @ID_TIPO_ACOMP IS NULL OR @ID_CLIENTE IS NULL OR @ID_CLIENTE IS NULL OR
            @ID_SERVICO IS NULL
            OR @DESCRICAO IS NULL OR @TITULO IS NULL)
            INSERT INTO TB_VIO_OPORTUNIDADE(DATA_CARGA, CODIGO, ID_TIPO_ACOMPANHAMENTO, ID_CLIENTE, ID_SERVICO,
                                            DESCRICAO, TITULO, STATUS, DATA_VIOLACAO, VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO_OPORTUNIDADE, @ID_TIPO_ACOMP, @ID_CLIENTE, @ID_SERVICO, @DESCRICAO, @TITULO,
                    @STATUS, GETDATE(), 'VIOLAÇÃO COM ATRIBUTO QUE É NULO');
        ELSE
            BEGIN
                SET @COUNTER = (SELECT COUNT(ID) FROM DIM_OPORTUNIDADE WHERE CODIGO_OPORTUNIDADE = @CODIGO_OPORTUNIDADE);
                IF (@COUNTER = 0)
                    BEGIN
                        INSERT INTO DIM_OPORTUNIDADE(CODIGO_OPORTUNIDADE, TITULO, DESCRICAO, STATUS, DT_INICIO, DT_FIM, FL_CORRENTE)
                        VALUES (@CODIGO_OPORTUNIDADE, @TITULO, @DESCRICAO, @STATUS, GETDATE(), NULL, 'SIM');
                    END
               ELSE
                    BEGIN
                        IF (EXISTS(SELECT *
                                   FROM DIM_OPORTUNIDADE
                                   WHERE CODIGO_OPORTUNIDADE = @CODIGO_OPORTUNIDADE
                                     AND (STATUS <> @STATUS OR TITULO <> @TITULO OR DESCRICAO <> @DESCRICAO)))
                            BEGIN
                                UPDATE DIM_OPORTUNIDADE
                                SET DT_FIM = GETDATE(), FL_CORRENTE = 'NAO'
                                WHERE CODIGO_OPORTUNIDADE = @CODIGO_OPORTUNIDADE AND FL_CORRENTE = 'SIM';
                                INSERT INTO DIM_OPORTUNIDADE(CODIGO_OPORTUNIDADE, TITULO, DESCRICAO, STATUS, DT_INICIO, DT_FIM, FL_CORRENTE)
                                VALUES (@CODIGO_OPORTUNIDADE, @TITULO, @DESCRICAO, @STATUS, GETDATE(), NULL, 'SIM');
                            END
                    END
            END
        FETCH CURSOR_OP INTO @CODIGO_OPORTUNIDADE, @ID_TIPO_ACOMP, @ID_CLIENTE, @ID_SERVICO, @DESCRICAO, @TITULO, @STATUS;
    END
    CLOSE CURSOR_OP;
    DEALLOCATE CURSOR_OP;
END

-- -----------------------------------------------------
-- PROCEDURE DIM_ACOMPANHANTE
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_DIM_ACOMPANHANTE(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE CURSOR_AC CURSOR FOR SELECT CODIGO,
                                        NOME,
                                        CPF,
                                        TELEFONE,
                                        GENERO,
                                        USUARIO,
                                        IDADE,
                                        DATA_NASCIMENTO,
                                        VALOR_HORA
                                 FROM TB_AUX_ACOMPANHANTE
                                 WHERE DATA_CARGA = @DATA_CARGA;
    DECLARE
        @CODIGO  INT, @NOME VARCHAR(45), @CPF VARCHAR(11), @TELEFONE VARCHAR(13), @GENERO VARCHAR(45),
        @USUARIO VARCHAR(45), @IDADE SMALLINT, @DT_NASC DATE, @VALOR_HORA NUMERIC(10,2);

    OPEN CURSOR_AC;
    FETCH CURSOR_AC INTO @CODIGO, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @IDADE, @DT_NASC, @VALOR_HORA;
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (@NOME IS NULL OR @CPF IS NULL OR @TELEFONE IS NULL OR @GENERO IS NULL OR @USUARIO IS NULL
            OR @IDADE IS NULL OR @DT_NASC IS NULL OR @VALOR_HORA IS NULL)
            INSERT INTO TB_VIO_ACOMPANHANTE(DATA_CARGA, CODIGO, NOME, CPF, TELEFONE, GENERO, USUARIO,
                                            DATA_NASCIMENTO, IDADE, VALOR_HORA, DATA_VIOLACAO, VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @DT_NASC, @IDADE,
                    @VALOR_HORA, GETDATE(), 'VIOLAÇÃO COM ATRIBUTO QUE É NULO');
        ELSE
            INSERT INTO DIM_ACOMPANHANTE(CODIGO_ACOMPANHANTE, NOME, CPF, TELEFONE, GENERO, USUARIO, IDADE, DATANASCIMENTO, VALORHORA)
            VALUES (@CODIGO, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @IDADE, @DT_NASC, @VALOR_HORA);
        FETCH CURSOR_AC INTO @CODIGO, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @IDADE, @DT_NASC, @VALOR_HORA;
    END
    CLOSE CURSOR_AC
    DEALLOCATE CURSOR_AC;
END

-- -----------------------------------------------------
-- PROCEDURE DIM_SERVICO
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_DIM_SERVICO(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE @COUNTER SMALLINT;
    DECLARE
        @CODIGO INT, @DT_SOLIC DATE, @ID_ACOMP INT, @ID_CLIENTE INT, @ID_TIPO_ACOMP INT, @STATUS VARCHAR(45);
    DECLARE CURSOR_SC CURSOR FOR SELECT CODIGO,
                                        DATA_SOLICITACAO,
                                        ID_ACOMPANHANTE,
                                        ID_CLIENTE,
                                        ID_TIPO_ACOMPANHAMENTO,
                                        STATUS
                                FROM TB_AUX_SERVICO
                                WHERE DATA_CARGA = @DATA_CARGA;
    OPEN CURSOR_SC;
    FETCH CURSOR_SC INTO @CODIGO, @DT_SOLIC, @ID_ACOMP, @ID_CLIENTE, @ID_TIPO_ACOMP, @STATUS;
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (@STATUS IS NULL OR @ID_ACOMP IS NULL OR @ID_CLIENTE IS NULL OR @ID_TIPO_ACOMP IS NULL OR
            @DT_SOLIC IS NULL)
            INSERT INTO TB_VIO_SERVICO(DATA_CARGA, CODIGO, DATA_SOLICITACAO, ID_ACOMPANHANTE,
                                       ID_CLIENTE, ID_TIPO_ACOMPANHAMENTO, STATUS, DATA_VIOLACAO,
                                       VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO, @DT_SOLIC, @ID_ACOMP, @ID_CLIENTE, @ID_TIPO_ACOMP, @STATUS,
                    GETDATE(), 'VIOLAÇÃO COM ATRIBUTO QUE É NULO');
        ELSE
            BEGIN
                SET @COUNTER = (SELECT COUNT(ID) FROM DIM_SERVICO WHERE CODIGO_SERVICO = @CODIGO);
                IF (@COUNTER = 0)
                    BEGIN
                        INSERT INTO DIM_SERVICO(CODIGO_SERVICO, STATUS, DT_INICIO, DT_FIM, FL_CORRENTE)
                        VALUES (@CODIGO, @STATUS, GETDATE(), NULL, 'SIM');
                    END
                ELSE
                    BEGIN
                        IF (EXISTS(
                                SELECT * FROM DIM_SERVICO WHERE CODIGO_SERVICO = @CODIGO AND STATUS <> @STATUS))
                            BEGIN
                                UPDATE DIM_SERVICO
                                SET DT_FIM = GETDATE(), FL_CORRENTE = 'NAO'
                                WHERE CODIGO_SERVICO = @CODIGO AND FL_CORRENTE = 'SIM';
                                INSERT INTO DIM_SERVICO(CODIGO_SERVICO, STATUS, DT_INICIO, DT_FIM, FL_CORRENTE)
                                VALUES (@CODIGO, @STATUS, GETDATE(), NULL, 'SIM');
                            END
                    END
            END
        FETCH CURSOR_SC INTO @CODIGO, @DT_SOLIC, @ID_ACOMP, @ID_CLIENTE, @ID_TIPO_ACOMP, @STATUS;
    END
END

-- -----------------------------------------------------
-- PROCEDURE DIM_TRANSACAO
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_DIM_TRANSACAO(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE @CODIGO_TRANSACAO INT, @ID_SERVICO INT, @DATA_TRANSACAO DATE;
    DECLARE CURSOR_T CURSOR FOR SELECT CODIGO,
                                       ID_SERVICO,
                                       DATA_TRANSACAO
                                FROM TB_AUX_TRANSACAO
                                WHERE DATA_CARGA = @DATA_CARGA;
    OPEN CURSOR_T;
    FETCH CURSOR_T INTO @CODIGO_TRANSACAO, @ID_SERVICO, @DATA_TRANSACAO;

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (@CODIGO_TRANSACAO IS NULL OR @ID_SERVICO IS NULL OR @DATA_TRANSACAO IS NULL)
            INSERT INTO TB_VIO_TRANSACAO(DATA_CARGA, CODIGO, ID_SERVICO, DATA_TRANSACAO,
                                         DATA_VIOLACAO, VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO_TRANSACAO, @ID_SERVICO, @DATA_TRANSACAO, GETDATE(),
                    'VIOLAÇÃO COM ATRIBUTO QUE É NULO');
        ELSE
            INSERT INTO DIM_TRANSACAO(CODIGO_TRANSACAO) VALUES (@CODIGO_TRANSACAO);

        FETCH CURSOR_T INTO @CODIGO_TRANSACAO, @ID_SERVICO, @DATA_TRANSACAO;
    END
END

-- -----------------------------------------------------
-- PROCEDURE DIM_FAIXA_ETARIA
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_DIM_FAIXA_ETARIA(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE
        @JOVEM SMALLINT, @DESCRICAOJ VARCHAR(45), @ADULTO SMALLINT, @DESCRICAOA VARCHAR(45), @IDOSO SMALLINT, @DESCRICAOI VARCHAR(45);
    SELECT @JOVEM = 15, @ADULTO = 25, @IDOSO = 65;
    SELECT @DESCRICAOJ = 'JOVEM, FAIXA ETÁRIA DE ' + STR(@JOVEM) + ' A ' + STR(@ADULTO - 1),
           @DESCRICAOA = 'ADULTO, FAIXA ETÁRIA DE ' + STR(@ADULTO) + ' A ' + STR(@IDOSO - 1),
           @DESCRICAOI = 'IDOSO, FAIXA ETÁRIA DE ' + STR(@IDOSO) + ' EM DIANTE';

    INSERT INTO DIM_FAIXA_ETARIA(CODIGO_FAIXA_ETARIA, DESCRICAO, IDADE_INICIAL, IDADE_FINAL) VALUES (1, @DESCRICAOJ, @JOVEM, @ADULTO - 1);
    INSERT INTO DIM_FAIXA_ETARIA(CODIGO_FAIXA_ETARIA, DESCRICAO, IDADE_INICIAL, IDADE_FINAL) VALUES (2, @DESCRICAOA, @ADULTO, @IDOSO - 1);
    INSERT INTO DIM_FAIXA_ETARIA(CODIGO_FAIXA_ETARIA, DESCRICAO, IDADE_INICIAL, IDADE_FINAL) VALUES (3, @DESCRICAOI, @IDOSO, @IDOSO + 70);
END

-- -----------------------------------------------------
-- PROCEDURE DIM_TIPO_ACOMPANHAMENTO
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_DIM_TIPO_ACOMPANHAMETO(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE @CODIGO INT, @DESCRICAO VARCHAR(300), @TIPO_ACOMP VARCHAR(45);
    DECLARE CURSOR_T CURSOR FOR SELECT CODIGO,
                                       DESCRICAO,
                                       TIPO_ACOMPANHAMENTO
                                FROM TB_AUX_TIPO_ACOMPANHAMENTO
                                WHERE DATA_CARGA = @DATA_CARGA;

    OPEN CURSOR_T;
    FETCH CURSOR_T INTO @CODIGO, @DESCRICAO, @TIPO_ACOMP;
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (@CODIGO IS NULL OR @DESCRICAO IS NULL OR @TIPO_ACOMP IS NULL)
            INSERT INTO TB_VIO_TIPO_ACOMPANHAMENTO(DATA_CARGA, CODIGO, DESCRICAO,
                                                   TIPO_ACOMPANHAMENTO, DATA_VIOLACAO,
                                                   VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO, @DESCRICAO, @TIPO_ACOMP, GETDATE(),
                    'VIOLAÇÃO COM ATRIBUTO QUE É NULO');
        ELSE
            INSERT INTO DIM_TIPO_ACOMPANHAMENTO(CODIGO_TIPO_ACOMPANHANTE, TIPO_ACOMPANHAMENTO, DESCRICAO)
            VALUES (@CODIGO, @TIPO_ACOMP, @DESCRICAO);

        FETCH CURSOR_T INTO @CODIGO, @DESCRICAO, @TIPO_ACOMP;
    END
    CLOSE CURSOR_T;
    DEALLOCATE CURSOR_T;
END

-- -----------------------------------------------------
-- PROCEDURE FATO_ACOMPANHAMENTO
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_FATO_ACOMPANHAMENTO(@DATA_CARGA DATE)
AS
BEGIN
    --VAR CODIGOS STAGING
    DECLARE
        @CODIGO_ACOMPANHANTE INT, @CODIGO_CLIENTE INT, @CODIGO_SERVICO INT, @CODIGO_TIPO_ACOMP INT, @CODIGO_OPORTUNIDADE INT,
        @CODIGO_LOCALIDADE   INT, @CODIGO_TRANSACAO INT, @CODIGO_FAIXA_ETARIA_ACOMP INT, @CODIGO_FAIXA_ETARIA_CLIENTE INT,  @CODIGO_DATA_TRANSACAO INT;

    --VAR ID'S DIM
    DECLARE
        @ID_ACOMPANHANTE INT, @ID_CLIENTE INT, @ID_SERVICO INT, @ID_TIPO_ACOMP INT, @ID_TEMPO INT,
        @ID_LOCALIDADE   INT, @ID_OPORTUNIDADE INT, @ID_TRANSACAO INT, @ID_FAIXA_ETARIA_ACOMP INT, @ID_FAIXA_ETARIA_CLIENTE INT, @IDADE_ACOMP INT,
        @IDADE_CLIENTE   INT, @ID_DATA_TRANSACAO INT, @VALOR NUMERIC(10, 2), @QTD SMALLINT, @QTD_CANDIDATOS INT;

    DECLARE CURSOR_F CURSOR FOR SELECT ID_TEMPO,
                                       ID_CLIENTE,
                                       ID_ACOMPANHANTE,
                                       ID_LOCALIDADE,
                                       ID_OPORTUNIDADE,
                                       ID_SERVICO,
                                       ID_TRANSACAO,
                                       ID_FAIXA_ETARIA_CLIENTE,
                                       ID_FAIXA_ETARIA_ACOMPANHANTE,
                                       ID_DATA_TRANSACAO,
                                       ID_TIPO_ACOMPANHAMENTO,
                                       QTD,
                                       VALOR,
                                       QTD_CANDIDATOS
                                FROM TB_AUX_FATO_ACOMPANHAMENTO
                                WHERE DATA_CARGA = @DATA_CARGA;

    OPEN CURSOR_F;
    FETCH CURSOR_F INTO @ID_TEMPO, @CODIGO_CLIENTE, @CODIGO_ACOMPANHANTE, @CODIGO_LOCALIDADE, @CODIGO_OPORTUNIDADE, @CODIGO_SERVICO, @CODIGO_TRANSACAO,
        @CODIGO_FAIXA_ETARIA_CLIENTE, @CODIGO_FAIXA_ETARIA_ACOMP, @CODIGO_DATA_TRANSACAO, @CODIGO_TIPO_ACOMP, @QTD, @VALOR, @QTD_CANDIDATOS;

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        SET @ID_CLIENTE =
                (SELECT ID FROM DIM_CLIENTE WHERE CODIGO_CLIENTE = @CODIGO_CLIENTE);
        SET @ID_ACOMPANHANTE =
                (SELECT ID FROM DIM_ACOMPANHANTE WHERE CODIGO_ACOMPANHANTE = @CODIGO_ACOMPANHANTE);
        SET @ID_LOCALIDADE =
                (SELECT ID FROM DIM_LOCALIDADE WHERE CODIGO_LOCALIDADE = @CODIGO_LOCALIDADE);
        SET @ID_OPORTUNIDADE =
                (SELECT ID FROM DIM_OPORTUNIDADE WHERE CODIGO_OPORTUNIDADE = @CODIGO_OPORTUNIDADE
                                                   AND FL_CORRENTE = 'SIM');
        SET @ID_SERVICO =
            (SELECT ID FROM DIM_SERVICO WHERE CODIGO_SERVICO = @CODIGO_SERVICO
                                          AND FL_CORRENTE = 'SIM');
        SET @ID_TRANSACAO =
                (SELECT ID FROM DIM_TRANSACAO WHERE CODIGO_TRANSACAO = @CODIGO_TRANSACAO);
        SET @IDADE_ACOMP =
                (SELECT IDADE FROM DIM_ACOMPANHANTE WHERE CODIGO_ACOMPANHANTE = @CODIGO_ACOMPANHANTE);
        SET @ID_FAIXA_ETARIA_ACOMP = (SELECT ID
                                      FROM DIM_FAIXA_ETARIA
                                      WHERE @IDADE_ACOMP >= IDADE_INICIAL
                                        AND @IDADE_CLIENTE <= IDADE_FINAL);
        SET @IDADE_CLIENTE =
                (SELECT IDADE FROM DIM_CLIENTE WHERE CODIGO_CLIENTE = @CODIGO_CLIENTE);
        SET @ID_FAIXA_ETARIA_CLIENTE = (SELECT ID
                                        FROM DIM_FAIXA_ETARIA
                                        WHERE @IDADE_CLIENTE >= IDADE_INICIAL
                                          AND @IDADE_CLIENTE <= IDADE_FINAL);
        SET @ID_DATA_TRANSACAO =
                (SELECT ID FROM DIM_TEMPO WHERE DATA = CAST((SELECT DATA FROM DIM_TEMPO WHERE ID = @CODIGO_DATA_TRANSACAO) AS DATE));
        SET @ID_TIPO_ACOMP =
                (SELECT ID FROM DIM_TIPO_ACOMPANHAMENTO WHERE CODIGO_TIPO_ACOMPANHANTE = @CODIGO_TIPO_ACOMP);
        SET @QTD_CANDIDATOS = (SELECT @QTD_CANDIDATOS
                               FROM DIM_OPORTUNIDADE
                               WHERE CODIGO_OPORTUNIDADE = @CODIGO_OPORTUNIDADE
                                 AND FL_CORRENTE = 'SIM');

        IF (@ID_TEMPO IS NULL OR @ID_LOCALIDADE IS NULL OR @ID_OPORTUNIDADE IS NULL OR
            @ID_TRANSACAO IS NULL OR @IDADE_ACOMP IS NULL OR @IDADE_CLIENTE IS NULL
            OR @ID_FAIXA_ETARIA_ACOMP IS NULL OR @ID_FAIXA_ETARIA_CLIENTE IS NULL OR
            @ID_DATA_TRANSACAO IS NULL)
            INSERT INTO TB_VIO_FATO_ACOMPANHAMENTO(DATA_CARGA, ID_TEMPO, ID_CLIENTE,
                                                   ID_ACOMPANHAMENTO, ID_LOCALIDADE,
                                                   ID_OPORTUNIDADE, ID_SERVICO,
                                                   ID_TRANSACAO,
                                                   ID_FAIXA_ETARIA_CLIENTE,
                                                   ID_FAIXA_ETARIA_ACOMPANHANTE,
                                                   ID_DATA_TRANSACAO,
                                                   ID_TIPO_ACOMPANHAMENTO, QTD, VALOR,
                                                   QTD_CANDIDATOS, DATA_VIOLACAO,
                                                   VIOLACAO)
            VALUES (@DATA_CARGA, @ID_TEMPO, @ID_CLIENTE, @ID_ACOMPANHANTE,
                    @ID_LOCALIDADE, @ID_OPORTUNIDADE, @ID_SERVICO, @ID_TRANSACAO,
                    @ID_FAIXA_ETARIA_CLIENTE,
                    @ID_FAIXA_ETARIA_ACOMP, @ID_DATA_TRANSACAO, @ID_TIPO_ACOMP, @QTD,
                    @VALOR, @QTD_CANDIDATOS, GETDATE(),
                    'HOUVE UM PROBLEMA NOS ID DOS DADOS DE ALGUMA(S) DIM');
        ELSE
            INSERT INTO FATO_ACOMPANHAMENTO(ID_TEMPO, ID_CLIENTE, ID_ACOMPANHANTE,
                                            ID_LOCALIDADE, ID_OPORTUNIDADE, ID_SERVICO,
                                            ID_TRANSACAO, ID_FAIXA_ETARIA_CLIENTE,
                                            ID_FAIXA_ETARIA_ACOMPANHANTE,
                                            ID_TIPO_ACOMPANHAMENTO, ID_DATA_TRANSACAO,
                                            QTD, VALOR, QTD_CANDIDATOS)
            VALUES (@ID_TEMPO, @ID_CLIENTE, @ID_ACOMPANHANTE, @ID_LOCALIDADE,
                    @ID_OPORTUNIDADE, @ID_SERVICO, @ID_TRANSACAO,
                    @ID_FAIXA_ETARIA_CLIENTE,
                    @ID_FAIXA_ETARIA_ACOMP, @ID_DATA_TRANSACAO, @ID_TIPO_ACOMP, @QTD,
                    @VALOR, @QTD_CANDIDATOS);

        FETCH CURSOR_F INTO @ID_TEMPO, @CODIGO_CLIENTE, @CODIGO_ACOMPANHANTE, @CODIGO_LOCALIDADE, @CODIGO_OPORTUNIDADE, @CODIGO_SERVICO, @CODIGO_TRANSACAO,
            @CODIGO_FAIXA_ETARIA_CLIENTE, @CODIGO_FAIXA_ETARIA_ACOMP, @CODIGO_DATA_TRANSACAO, @CODIGO_TIPO_ACOMP, @QTD, @VALOR, @QTD_CANDIDATOS;
    END
    CLOSE CURSOR_F;
    DEALLOCATE CURSOR_F;
END

