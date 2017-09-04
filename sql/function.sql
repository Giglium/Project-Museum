/*FUNZIONE 1*/
DELIMITER $

CREATE FUNCTION RepertoEsposto (nome_reperto VARCHAR(50), nome_museo VARCHAR(200))
RETURNS bit
BEGIN
    DECLARE temp SMALLINT UNSIGNED;
    SELECT Count(CodS) INTO temp
    FROM Museo M, Locazione L, RepertoArtistico RA
    WHERE M.Nome=nome_museo AND RA.Nome=nome_reperto AND M.CodiceMuseo=L.CodMuseo AND L.CodLuogo=RA.CodDep;
    IF temp>0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END$

/*FUNZIONE 2*/
DELIMITER $
CREATE FUNCTION GiorniRestaurazioneArtistico ( codice SMALLINT UNSIGNED )
RETURNS int
BEGIN
    DECLARE temp SMALLINT UNSIGNED;
    SELECT DATEDIFF(CURDATE(),FineRestauro) INTO temp
    FROM RepertoArtistico
    WHERE CodA=codice;
    RETURN TEMP;
END$
DELIMITER ;
