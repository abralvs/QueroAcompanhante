

EXEC SP_POVOA_DIMS_PRE_CARREGADAS  '20180101', '20300101';

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
	
	
GO	
-- -----------------------------------------------------
-- PROCEDURE DIM_TRANSACAO
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_DIM_TRANSACAO
AS
BEGIN
   INSERT INTO DIM_TRANSACAO (TIPO_PAGAMENTO)
   VALUES('EM ESPECIE'),('CARTAO CREDITO/DEBITO'),('NAO REALIZADO') 
END

GO

-- -----------------------------------------------------
-- PROCEDURE DIM_FAIXA_ETARIA
-- -----------------------------------------------------
CREATE PROCEDURE SP_POVOA_DIM_FAIXA_ETARIA
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

GO

CREATE PROCEDURE SP_POVOA_DIMS_PRE_CARREGADAS(@DT_INICIO_DIM_TEMPO DATETIME,@DT_FIM_DIM_TEMPO DATETIME)
AS
BEGIN
	EXEC SP_POVOA_DIM_TEMPO         @DT_INICIO_DIM_TEMPO,@DT_FIM_DIM_TEMPO;
	EXEC SP_POVOA_DIM_FAIXA_ETARIA;
	EXEC SP_POVOA_DIM_TRANSACAO;
END