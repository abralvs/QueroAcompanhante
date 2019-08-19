
-- -----------------------------------------------------
-- EXECUTA PROCEDURES
-- -----------------------------------------------------
EXEC AMBIENTE_DIMENSIONAL.SP_POVOA_DIMS							   '20190721';
EXEC AMBIENTE_DIMENSIONAL.SP_POVOA_FATO_ACOMPANHAMENTO			   '20190721';
EXEC AMBIENTE_DIMENSIONAL.SP_POVOA_FATO_ACOMPANHAMENTO_CONCLUIDO           ;

SELECT * FROM AMBIENTE_DIMENSIONAL.FATO_ACOMPANHAMENTO
SELECT * FROM AMBIENTE_DIMENSIONAL.FATO_ACOMPANHAMENTO_CONCLUIDO

-- -----------------------------------------------------
-- PROCEDURE AMBIENTE_DIMENSIONAL.DIM_OPORTUNIDADE
-- -----------------------------------------------------
CREATE PROCEDURE AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_OPORTUNIDADE(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE @COUNTER SMALLINT;
    DECLARE
        @CODIGO_OPORTUNIDADE INT, @TITULO VARCHAR(50), @DESCRICAO VARCHAR(300), @STATUS VARCHAR(45), @EH_PUBLICA INT, @ID_TIPO_ACOMP INT, @QTD_CANDIDATOS INT;
    DECLARE CURSOR_OP CURSOR FOR SELECT CODIGO,
                                        TITULO,
                                        DESCRICAO,
                                        STATUS,
                                        EH_PUBLICA,
                                        ID_TIPO_ACOMPANHAMENTO,
                                        QTD_CANDIDATOS
                                 FROM AMBIENTE_OLAP.TB_AUX_OPORTUNIDADE
                                 WHERE DATA_CARGA = @DATA_CARGA;

    OPEN CURSOR_OP;
    FETCH CURSOR_OP INTO @CODIGO_OPORTUNIDADE, @TITULO, @DESCRICAO, @STATUS, @EH_PUBLICA, @ID_TIPO_ACOMP, @QTD_CANDIDATOS;
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (@STATUS IS NULL OR @ID_TIPO_ACOMP IS NULL OR @EH_PUBLICA IS NULL OR @QTD_CANDIDATOS IS NULL
            OR @DESCRICAO IS NULL OR @TITULO IS NULL)
            INSERT INTO AMBIENTE_OLAP.TB_VIO_OPORTUNIDADE(DATA_CARGA, CODIGO, TITULO, DESCRICAO, STATUS, EH_PUBLICA, ID_TIPO_ACOMPANHAMENTO, QTD_CANDIDATOS, DATA_VIOLACAO, VIOLACAO)
            VALUES (@DATA_CARGA,  @CODIGO_OPORTUNIDADE, @TITULO, @DESCRICAO, @STATUS, @EH_PUBLICA, @ID_TIPO_ACOMP, @QTD_CANDIDATOS, GETDATE(), 'VIOLA��O COM ATRIBUTO QUE � NULO');
        ELSE
            BEGIN
                SET @COUNTER = (SELECT COUNT(ID) FROM AMBIENTE_DIMENSIONAL.DIM_OPORTUNIDADE WHERE CODIGO_OPORTUNIDADE = @CODIGO_OPORTUNIDADE);
                IF (@COUNTER = 0)
                    BEGIN
                        INSERT INTO AMBIENTE_DIMENSIONAL.DIM_OPORTUNIDADE(CODIGO_OPORTUNIDADE, TITULO, DESCRICAO, STATUS, EH_PUBLICA,QTD_CANDIDATOS,DT_INICIO, DT_FIM, FL_CORRENTE)
                        VALUES (@CODIGO_OPORTUNIDADE, @TITULO, @DESCRICAO, @STATUS, @EH_PUBLICA, @QTD_CANDIDATOS,GETDATE(), NULL, 'SIM');
                    END
                ELSE
                    BEGIN
                        IF (EXISTS(SELECT *
                                   FROM AMBIENTE_DIMENSIONAL.DIM_OPORTUNIDADE
                                   WHERE CODIGO_OPORTUNIDADE = @CODIGO_OPORTUNIDADE
                                     AND (STATUS <> @STATUS OR TITULO <> @TITULO OR DESCRICAO <> @DESCRICAO)))
                            BEGIN
                                UPDATE AMBIENTE_DIMENSIONAL.DIM_OPORTUNIDADE
                                SET DT_FIM = GETDATE(), FL_CORRENTE = 'NAO'
                                WHERE CODIGO_OPORTUNIDADE = @CODIGO_OPORTUNIDADE AND FL_CORRENTE = 'SIM';
                                INSERT INTO AMBIENTE_DIMENSIONAL.DIM_OPORTUNIDADE(CODIGO_OPORTUNIDADE, TITULO, DESCRICAO, STATUS, EH_PUBLICA, QTD_CANDIDATOS,DT_INICIO, DT_FIM, FL_CORRENTE)
                                VALUES (@CODIGO_OPORTUNIDADE, @TITULO, @DESCRICAO, @STATUS, @EH_PUBLICA, @QTD_CANDIDATOS,GETDATE(), NULL, 'SIM');
                            END
                    END
            END
        FETCH CURSOR_OP INTO @CODIGO_OPORTUNIDADE, @DESCRICAO, @TITULO, @STATUS, @EH_PUBLICA, @ID_TIPO_ACOMP, @QTD_CANDIDATOS;
    END
    CLOSE CURSOR_OP;
    DEALLOCATE CURSOR_OP;
END
GO

-- -----------------------------------------------------
-- PROCEDURE AMBIENTE_DIMENSIONAL.DIM_LOCALIDADE
-- -----------------------------------------------------
CREATE PROCEDURE AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_LOCALIDADE(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE CURSOR_LOC CURSOR FOR SELECT CODIGO,
                                         ID_SERVICO,
                                         ESTADO,
                                         CIDADE,
                                         RUA,
                                         BAIRRO
                                  FROM AMBIENTE_OLAP.TB_AUX_LOCALIDADE
                                  WHERE DATA_CARGA = @DATA_CARGA;
    DECLARE
        @CODIGO_LOCALIDADE INT, @ID_SERVICO INT, @ESTADO CHAR(2), @CIDADE VARCHAR(45), @RUA VARCHAR(2), @BAIRRO VARCHAR(45);

    OPEN CURSOR_LOC;
    FETCH CURSOR_LOC INTO @CODIGO_LOCALIDADE, @ID_SERVICO, @ESTADO, @CIDADE, @RUA, @BAIRRO;
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (@ESTADO IS NULL OR @CIDADE IS NULL OR @RUA IS NULL OR @BAIRRO IS NULL)
            INSERT INTO AMBIENTE_OLAP.TB_VIO_LOCALIDADE(DATA_CARGA, CODIGO, ID_USUARIO, ESTADO, CIDADE, RUA, BAIRRO, DATA_VIOLACAO,
                                                        VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO_LOCALIDADE, @ID_SERVICO, @ESTADO, @CIDADE, @RUA, @BAIRRO, GETDATE(),
                    'VIOLA��O COM ATRIBUTO QUE � NULO');
        ELSE
            INSERT INTO AMBIENTE_DIMENSIONAL.DIM_LOCALIDADE(CODIGO_LOCALIDADE, ESTADO, CIDADE, RUA, BAIRRO)
            VALUES (@CODIGO_LOCALIDADE, @ESTADO, @CIDADE, @RUA, @BAIRRO);
        FETCH CURSOR_LOC INTO @CODIGO_LOCALIDADE, @ID_SERVICO, @ESTADO, @CIDADE, @RUA, @BAIRRO;
    END
    CLOSE CURSOR_LOC;
    DEALLOCATE CURSOR_LOC;
END
GO

-- -----------------------------------------------------
-- PROCEDURE AMBIENTE_DIMENSIONAL.DIM_CLIENTE
-- -----------------------------------------------------
CREATE PROCEDURE AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_CLIENTE(@DATA_CARGA DATE)
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
                                  FROM AMBIENTE_OLAP.TB_AUX_CLIENTE
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
            INSERT INTO AMBIENTE_OLAP.TB_VIO_CLIENTE(DATA_CARGA, CODIGO, NOME, CPF, TELEFONE, GENERO, USUARIO, DATA_NASCIMENTO,
                                                     IDADE, DATA_VIOLACAO, VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO_CLIENTE, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @DT_NASC, @IDADE, GETDATE(),
                    'VIOLA��O COM ATRIBUTO QUE � NULO');
        ELSE

            INSERT INTO AMBIENTE_DIMENSIONAL.DIM_CLIENTE(CODIGO_CLIENTE, NOME, CPF, TELEFONE, GENERO, USUARIO, IDADE, DATANASCIMENTO)
            VALUES (@CODIGO_CLIENTE, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @IDADE, @DT_NASC);
        FETCH CURSOR_CLI INTO @CODIGO_CLIENTE, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @IDADE, @DT_NASC;
    END
    CLOSE CURSOR_CLI;
    DEALLOCATE CURSOR_CLI;
END
GO

-- -----------------------------------------------------
-- PROCEDURE AMBIENTE_DIMENSIONAL.DIM_ACOMPANHANTE
-- -----------------------------------------------------
CREATE PROCEDURE AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_ACOMPANHANTE(@DATA_CARGA DATE)
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
                                 FROM AMBIENTE_OLAP.TB_AUX_ACOMPANHANTE
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
            INSERT INTO AMBIENTE_OLAP.TB_VIO_ACOMPANHANTE(DATA_CARGA, CODIGO, NOME, CPF, TELEFONE, GENERO, USUARIO,
                                                          DATA_NASCIMENTO, IDADE, VALOR_HORA, DATA_VIOLACAO, VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @DT_NASC, @IDADE,
                    @VALOR_HORA, GETDATE(), 'VIOLA��O COM ATRIBUTO QUE � NULO');
        ELSE
            INSERT INTO AMBIENTE_DIMENSIONAL.DIM_ACOMPANHANTE(CODIGO_ACOMPANHANTE, NOME, CPF, TELEFONE, GENERO, USUARIO, IDADE, DATANASCIMENTO, VALORHORA)
            VALUES (@CODIGO, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @IDADE, @DT_NASC, @VALOR_HORA);
        FETCH CURSOR_AC INTO @CODIGO, @NOME, @CPF, @TELEFONE, @GENERO, @USUARIO, @IDADE, @DT_NASC, @VALOR_HORA;
    END
    CLOSE CURSOR_AC
    DEALLOCATE CURSOR_AC;
END
GO

-- -----------------------------------------------------
-- PROCEDURE AMBIENTE_DIMENSIONAL.DIM_SERVICO
-- -----------------------------------------------------
CREATE PROCEDURE AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_SERVICO(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE @COUNTER SMALLINT;
    DECLARE
        @CODIGO INT, @ID_CLIENTE INT, @ID_ACOMPANHANTE INT, @ID_OPORTUNIDADE INT, @VALOR_TOTAL NUMERIC(10,2), @STATUS VARCHAR(45);
    DECLARE CURSOR_SC CURSOR FOR SELECT CODIGO, ID_CLIENTE, ID_ACOMPANHANTE, ID_OPORTUNIDADE, VALOR_TOTAL, STATUS
                                 FROM AMBIENTE_OLAP.TB_AUX_SERVICO
                                 WHERE DATA_CARGA = @DATA_CARGA;
    OPEN CURSOR_SC;
    FETCH CURSOR_SC INTO @CODIGO,  @ID_CLIENTE, @ID_ACOMPANHANTE, @ID_OPORTUNIDADE, @VALOR_TOTAL, @STATUS;
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (@STATUS IS NULL OR @ID_ACOMPANHANTE IS NULL OR @ID_CLIENTE IS NULL OR  @ID_OPORTUNIDADE IS NULL OR
            @VALOR_TOTAL IS NULL OR @VALOR_TOTAL IS NULL)
            INSERT INTO AMBIENTE_OLAP.TB_VIO_SERVICO(DATA_CARGA, CODIGO, ID_CLIENTE, ID_ACOMPANHANTE, ID_OPORTUNIDADE, VALOR_TOTAL, STATUS, DATA_VIOLACAO, VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO,  @ID_CLIENTE, @ID_ACOMPANHANTE, @ID_OPORTUNIDADE, @VALOR_TOTAL, @STATUS,
                    GETDATE(), 'VIOLA��O COM ATRIBUTO QUE � NULO');
        ELSE
            BEGIN
                SET @COUNTER = (SELECT COUNT(ID) FROM AMBIENTE_DIMENSIONAL.DIM_SERVICO WHERE CODIGO_SERVICO = @CODIGO);
                IF (@COUNTER = 0)
                    BEGIN
                        INSERT INTO AMBIENTE_DIMENSIONAL.DIM_SERVICO(CODIGO_SERVICO, STATUS, DT_INICIO, DT_FIM, FL_CORRENTE)
                        VALUES (@CODIGO, @STATUS, GETDATE(), NULL, 'SIM');
                    END
                ELSE
                    BEGIN
                        IF (EXISTS(
                                SELECT * FROM AMBIENTE_DIMENSIONAL.DIM_SERVICO WHERE CODIGO_SERVICO = @CODIGO AND STATUS <> @STATUS))
                            BEGIN
                                UPDATE AMBIENTE_DIMENSIONAL.DIM_SERVICO
                                SET DT_FIM = GETDATE(), FL_CORRENTE = 'NAO'
                                WHERE CODIGO_SERVICO = @CODIGO AND FL_CORRENTE = 'SIM';
                                INSERT INTO AMBIENTE_DIMENSIONAL.DIM_SERVICO(CODIGO_SERVICO, STATUS, DT_INICIO, DT_FIM, FL_CORRENTE)
                                VALUES (@CODIGO, @STATUS, GETDATE(), NULL, 'SIM');
                            END
                    END
            END
        FETCH CURSOR_SC INTO @CODIGO,  @ID_CLIENTE, @ID_ACOMPANHANTE, @ID_OPORTUNIDADE, @VALOR_TOTAL, @STATUS;
    END
    CLOSE CURSOR_SC;
    DEALLOCATE CURSOR_SC;
END

GO
-- -----------------------------------------------------
-- PROCEDURE AMBIENTE_DIMENSIONAL.DIM_TIPO_ACOMPANHAMENTO
-- -----------------------------------------------------
CREATE PROCEDURE AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_TIPO_ACOMPANHAMETO(@DATA_CARGA DATE)
AS
BEGIN
    DECLARE @CODIGO INT, @DESCRICAO VARCHAR(300), @TIPO_ACOMP VARCHAR(45);
    DECLARE CURSOR_T CURSOR FOR SELECT CODIGO,
                                       DESCRICAO,
                                       TIPO_ACOMPANHAMENTO
                                FROM AMBIENTE_OLAP.TB_AUX_TIPO_ACOMPANHAMENTO
                                WHERE DATA_CARGA = @DATA_CARGA;

    OPEN CURSOR_T;
    FETCH CURSOR_T INTO @CODIGO, @DESCRICAO, @TIPO_ACOMP;
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (@CODIGO IS NULL OR @DESCRICAO IS NULL OR @TIPO_ACOMP IS NULL)
            INSERT INTO AMBIENTE_OLAP.TB_VIO_TIPO_ACOMPANHAMENTO(DATA_CARGA, CODIGO, DESCRICAO,
                                                                 TIPO_ACOMPANHAMENTO, DATA_VIOLACAO,
                                                                 VIOLACAO)
            VALUES (@DATA_CARGA, @CODIGO, @DESCRICAO, @TIPO_ACOMP, GETDATE(),
                    'VIOLA��O COM ATRIBUTO QUE � NULO');
        ELSE
            INSERT INTO AMBIENTE_DIMENSIONAL.DIM_TIPO_ACOMPANHAMENTO(CODIGO_TIPO_ACOMPANHANTE, TIPO_ACOMPANHAMENTO, DESCRICAO)
            VALUES (@CODIGO, @TIPO_ACOMP, @DESCRICAO);

        FETCH CURSOR_T INTO @CODIGO, @DESCRICAO, @TIPO_ACOMP;
    END
    CLOSE CURSOR_T;
    DEALLOCATE CURSOR_T;
END
GO

-- -----------------------------------------------------
-- PROCEDURE AMBIENTE_DIMENSIONAL.FATO_ACOMPANHAMENTO
-- -----------------------------------------------------
CREATE PROCEDURE AMBIENTE_DIMENSIONAL.SP_POVOA_FATO_ACOMPANHAMENTO(@DATA_CARGA DATE)
AS
BEGIN
    --VAR CODIGOS STAGING
    DECLARE
        @CODIGO_ACOMPANHANTE INT, @CODIGO_CLIENTE INT, @CODIGO_SERVICO INT, @CODIGO_TIPO_ACOMP INT, @CODIGO_OPORTUNIDADE INT,
        @CODIGO_LOCALIDADE  INT, @CODIGO_FAIXA_ETARIA_ACOMP INT, @CODIGO_FAIXA_ETARIA_CLIENTE INT,  @CODIGO_DATA_TRANSACAO INT;

    --VAR ID'S DIM
    DECLARE
        @ID_ACOMPANHANTE INT, @ID_CLIENTE INT, @ID_SERVICO INT, @ID_TIPO_ACOMP INT, @ID_TEMPO INT,
        @ID_LOCALIDADE   INT, @ID_OPORTUNIDADE INT, @ID_TRANSACAO INT, @ID_FAIXA_ETARIA_ACOMP INT, @ID_FAIXA_ETARIA_CLIENTE INT, @IDADE_ACOMP INT,
        @IDADE_CLIENTE   INT, @VALOR NUMERIC(10, 2), @QTD SMALLINT;

    DECLARE CURSOR_F CURSOR FOR SELECT ID_TEMPO, ID_CLIENTE, ID_ACOMPANHANTE, ID_LOCALIDADE, ID_OPORTUNIDADE, ID_SERVICO,
                                       ID_TRANSACAO, ID_FAIXA_ETARIA_CLIENTE,
                                       ID_FAIXA_ETARIA_ACOMPANHANTE, ID_TIPO_ACOMPANHAMENTO, QTD, VALOR
                                FROM AMBIENTE_OLAP.TB_AUX_FATO_ACOMPANHAMENTO
                                WHERE DATA_CARGA = @DATA_CARGA;

    OPEN CURSOR_F;
    FETCH CURSOR_F INTO @ID_TEMPO, @CODIGO_CLIENTE, @CODIGO_ACOMPANHANTE, @CODIGO_LOCALIDADE, @CODIGO_OPORTUNIDADE, @CODIGO_SERVICO, @ID_TRANSACAO,
        @CODIGO_FAIXA_ETARIA_CLIENTE, @CODIGO_FAIXA_ETARIA_ACOMP, @CODIGO_TIPO_ACOMP, @QTD, @VALOR;

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        SET @ID_CLIENTE =
                (SELECT ID FROM AMBIENTE_DIMENSIONAL.DIM_CLIENTE WHERE CODIGO_CLIENTE = @CODIGO_CLIENTE);
        SET @ID_ACOMPANHANTE =
                (SELECT ID FROM AMBIENTE_DIMENSIONAL.DIM_ACOMPANHANTE WHERE CODIGO_ACOMPANHANTE = @CODIGO_ACOMPANHANTE);
        SET @ID_LOCALIDADE =
                (SELECT ID FROM AMBIENTE_DIMENSIONAL.DIM_LOCALIDADE WHERE CODIGO_LOCALIDADE = @CODIGO_LOCALIDADE);
        SET @ID_OPORTUNIDADE =
                (SELECT ID FROM AMBIENTE_DIMENSIONAL.DIM_OPORTUNIDADE WHERE CODIGO_OPORTUNIDADE = @CODIGO_OPORTUNIDADE
                                                                        AND FL_CORRENTE = 'SIM');
        SET @ID_SERVICO =
                (SELECT ID FROM AMBIENTE_DIMENSIONAL.DIM_SERVICO WHERE CODIGO_SERVICO = @CODIGO_SERVICO
                                                                   AND FL_CORRENTE = 'SIM');
        SET @IDADE_ACOMP =
                (SELECT IDADE FROM AMBIENTE_DIMENSIONAL.DIM_ACOMPANHANTE WHERE CODIGO_ACOMPANHANTE = @CODIGO_ACOMPANHANTE);
        SET @ID_FAIXA_ETARIA_ACOMP = (SELECT ID
                                      FROM AMBIENTE_DIMENSIONAL.DIM_FAIXA_ETARIA
                                      WHERE @IDADE_ACOMP >= IDADE_INICIAL
                                        AND @IDADE_ACOMP <= IDADE_FINAL);
        SET @IDADE_CLIENTE =
                (SELECT IDADE FROM AMBIENTE_DIMENSIONAL.DIM_CLIENTE WHERE CODIGO_CLIENTE = @CODIGO_CLIENTE);
        SET @ID_FAIXA_ETARIA_CLIENTE = (SELECT ID
                                        FROM AMBIENTE_DIMENSIONAL.DIM_FAIXA_ETARIA
                                        WHERE @IDADE_CLIENTE >= IDADE_INICIAL
                                          AND @IDADE_CLIENTE <= IDADE_FINAL);
        SET @ID_TIPO_ACOMP =
                (SELECT ID FROM AMBIENTE_DIMENSIONAL.DIM_TIPO_ACOMPANHAMENTO WHERE CODIGO_TIPO_ACOMPANHANTE = @CODIGO_TIPO_ACOMP);

        IF (@ID_TEMPO IS NULL OR @ID_CLIENTE IS NULL OR @ID_ACOMPANHANTE IS NULL OR @ID_LOCALIDADE IS NULL
            OR @ID_OPORTUNIDADE IS NULL OR @ID_SERVICO IS NULL OR @ID_TRANSACAO IS NULL
            OR @ID_TRANSACAO IS NULL OR @ID_FAIXA_ETARIA_CLIENTE IS NULL OR @ID_FAIXA_ETARIA_ACOMP IS  NULL
            OR @ID_TIPO_ACOMP IS NULL)
            INSERT INTO AMBIENTE_OLAP.TB_VIO_FATO_ACOMPANHAMENTO(data_carga, id_tempo, id_cliente, id_acompanhante, id_localidade, id_oportunidade,
                                                                 id_servico, id_transacao, id_faixa_etaria_cliente, id_faixa_etaria_acompanhante,
                                                                 id_tipo_acompanhamento, qtd, valor, data_violacao, violacao)
            VALUES (@DATA_CARGA, @ID_TEMPO, @ID_CLIENTE, @ID_ACOMPANHANTE,
                    @ID_LOCALIDADE, @ID_OPORTUNIDADE, @ID_SERVICO, @ID_TRANSACAO,
                    @ID_FAIXA_ETARIA_CLIENTE,
                    @ID_FAIXA_ETARIA_ACOMP, @ID_TIPO_ACOMP, @QTD,
                    @VALOR, GETDATE(),
                    'HOUVE UM PROBLEMA NOS ID DOS DADOS DE ALGUMA(S) DIM');
        ELSE
            INSERT INTO AMBIENTE_DIMENSIONAL.FATO_ACOMPANHAMENTO(ID_TEMPO, ID_CLIENTE, ID_ACOMPANHANTE,
                                                                 ID_LOCALIDADE, ID_OPORTUNIDADE, ID_SERVICO,
                                                                 ID_TRANSACAO, ID_FAIXA_ETARIA_CLIENTE,
                                                                 ID_FAIXA_ETARIA_ACOMPANHANTE,
                                                                 ID_TIPO_ACOMPANHAMENTO, QTD, VALOR)
            VALUES (@ID_TEMPO, @ID_CLIENTE, @ID_ACOMPANHANTE, @ID_LOCALIDADE,
                    @ID_OPORTUNIDADE, @ID_SERVICO, @ID_TRANSACAO,
                    @ID_FAIXA_ETARIA_CLIENTE,
                    @ID_FAIXA_ETARIA_ACOMP, @ID_TIPO_ACOMP, @QTD,
                    @VALOR);
        FETCH CURSOR_F INTO @ID_TEMPO, @CODIGO_CLIENTE, @CODIGO_ACOMPANHANTE, @CODIGO_LOCALIDADE, @CODIGO_OPORTUNIDADE, @CODIGO_SERVICO, @ID_TRANSACAO,
            @CODIGO_FAIXA_ETARIA_CLIENTE, @CODIGO_FAIXA_ETARIA_ACOMP,  @CODIGO_TIPO_ACOMP, @QTD, @VALOR;
    END
    CLOSE CURSOR_F;
    DEALLOCATE CURSOR_F;
END
GO
-- -----------------------------------------------------
-- PROCEDURE AMBIENTE_DIMENSIONAL.CARGA_DIMENSOES
-- -----------------------------------------------------

CREATE PROCEDURE AMBIENTE_DIMENSIONAL.SP_POVOA_DIMS(@DATA DATE)
AS
BEGIN
    EXEC AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_CLIENTE                @DATA;
    EXEC AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_ACOMPANHANTE           @DATA;
    EXEC AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_LOCALIDADE             @DATA;
    EXEC AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_OPORTUNIDADE           @DATA;
    EXEC AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_SERVICO                @DATA;
    EXEC AMBIENTE_DIMENSIONAL.SP_POVOA_DIM_TIPO_ACOMPANHAMETO     @DATA;
END

GO

CREATE PROCEDURE AMBIENTE_DIMENSIONAL.SP_POVOA_FATO_ACOMPANHAMENTO_CONCLUIDO
AS
BEGIN
    DECLARE @ID_TEMPO INT,@ID_OPORTUNIDADE INT, @QTD SMALLINT, @VALOR NUMERIC(10,2);
    DECLARE CURSOR_F CURSOR FOR SELECT F.ID_TEMPO, F.ID_OPORTUNIDADE, F.QTD, F.VALOR
                                FROM AMBIENTE_DIMENSIONAL.FATO_ACOMPANHAMENTO F
                                         JOIN DIM_SERVICO DS on F.ID_SERVICO = DS.ID
                                WHERE DS.status = 'CONCLUIDA';
    OPEN CURSOR_F;
    FETCH CURSOR_F INTO @ID_TEMPO, @ID_OPORTUNIDADE, @QTD, @VALOR;
    WHILE(@@FETCH_STATUS = 0)
    BEGIN
        INSERT INTO FATO_ACOMPANHAMENTO_CONCLUIDO(ID_TEMPO, ID_OPORTUNIDADE, QTD, VALOR)
        VALUES(@ID_TEMPO, @ID_OPORTUNIDADE, @QTD, @VALOR);
        FETCH CURSOR_F INTO @ID_TEMPO, @ID_OPORTUNIDADE, @QTD, @VALOR;
    END
    CLOSE CURSOR_F;
    DEALLOCATE CURSOR_F;
END