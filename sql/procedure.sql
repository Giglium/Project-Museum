/*PROCEDURA 1*/
DROP PROCEDURE IF EXISTS RimuoviReperto;
DELIMITER $
CREATE PROCEDURE RimuoviReperto (IN CodiceReperto smallint UNSIGNED)
    BEGIN
        DECLARE Temp smallint UNSIGNED;
        SELECT CodA INTO Temp
        FROM RepertoArtistico
        WHERE CodA=CodiceReperto;
        IF Temp IS NOT NULL THEN
            DELETE FROM RepertoArtistico WHERE CodA=Temp;
        END IF;
    END$
DELIMITER ;

/*PROCEDURA 2*/
DROP PROCEDURE IF EXISTS AumentoStipendio;
DELIMITER $
CREATE PROCEDURE AumentoStipendio (IN CodiceDirettore smallint UNSIGNED, CodiceDipendente smallint UNSIGNED, percentuale int UNSIGNED)
    BEGIN
        DECLARE Temp smallint;
        SELECT CodiceDip INTO Temp
        FROM Dipendente
        WHERE CodMuseo=(SELECT CodMuseo FROM Dipendente Dir WHERE Dir.CodiceDip=CodiceDirettore AND Dir.Lavoro='direttore') AND CodiceDip=CodiceDipendente;
        IF(Temp=CodiceDipendente) THEN
            UPDATE Dipendente
            SET Stipendio=Stipendio+((Stipendio*percentuale)/100)
            WHERE CodiceDip=Temp AND Lavoro <> 'direttore';
        END IF;
    END$

DELIMITER ;
