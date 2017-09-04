
/*QUERY 1*/

DROP VIEW IF EXISTS Query1;

CREATE VIEW Query1 AS
    SELECT  Dip.Nome, Dip.Cognome, Citta
    FROM Dipendente Dip
    WHERE Dip.Stipendio>(SELECT MAX(Stipendio) FROM Dipendente WHERE Citta='Padova');


/*QUERY 2*/
DROP VIEW IF EXISTS Query2;

CREATE VIEW Query2  AS
    SELECT CodS AS Codice, Nome, ValoreStimato AS Valore
    FROM RepertoStorico
    WHERE Donato=2 AND ValoreStimato>(SELECT MAX(ValoreStimato) FROM RepertoStorico WHERE Donato=1);

/*QUERY 3 */
DROP VIEW IF EXISTS Query3;

CREATE VIEW Query3 AS
    SELECT DISTINCT Dipendente.Nome
    FROM Dipendente,Museo
    WHERE Dipendente.CAP=Museo.CAP AND YEAR(Dipendente.DatadiNascita) between 1950 and 1960 AND Sesso=1 ;

/*Query 4*/
DROP VIEW IF EXISTS MediaValoreS;

SET SQL_MODE='';

CREATE VIEW MediaValoreS AS
    SELECT AVG(ValoreStimato) AS Media
    FROM RepertoStorico
    WHERE Tipo='Manufatto';

SELECT Dip.Cognome, Dip.Nome, Dip.Stipendio
FROM Dipendente Dip, Museo M, Locazione L, RepertoStorico R
WHERE Dip.CodMuseo=M.CodiceMuseo AND M.CodiceMuseo=L.CodMuseo AND L.CodLuogo=R.CodDep AND Dip.Sesso='F'
GROUP BY Dip.Cognome, Dip.Nome
HAVING Dip.Stipendio>(Select * FROM MediaValoreS);


/*QUERY 5*/
DROP VIEW IF EXISTS table1;
DROP VIEW IF EXISTS table2;

CREATE VIEW table1 AS (SELECT CodiceMuseo, M.Nome, COUNT(CodS) AS TotaleRepertiStorici
FROM Museo M, Locazione L, RepertoStorico RS
WHERE M.CodiceMuseo=L.CodMuseo AND L.CodLuogo=RS.CodDep AND M.CAP=35121
GROUP BY CodiceMuseo);

CREATE VIEW table2 AS (SELECT CodiceMuseo, M.Nome, COUNT(CodA) AS TotaleRepertiArtistici
FROM Museo M, Locazione L, RepertoArtistico RA
WHERE M.CodiceMuseo=L.CodMuseo AND L.CodLuogo=RA.CodDep
GROUP BY CodiceMuseo);

    CREATE VIEW Query5 AS(
    SELECT table1.Nome AS 'Nome Museo', TotaleRepertiStorici AS 'Totale Reperti Storici', TotaleRepertiArtistici AS 'Totale Reperti Artistici'
    FROM table1,table2
    WHERE table1.CodiceMuseo=table2.CodiceMuseo);


/*QUERY 6*/

DROP VIEW IF EXISTS Query6;

CREATE VIEW Query6 AS
SELECT MAX(RepertiEsposti) AS 'Reperti Esposti', MAX(RepertiInMagazzino) AS 'Reperti in Magazzino'
FROM (SELECT COUNT(CodS) as RepertiEsposti, 0 AS RepertiInMagazzino
        FROM Museo M, Locazione L, RepertoStorico R
        WHERE M.CodiceMuseo=L.CodMuseo AND L.CodLuogo=R.CodDep AND L.Tipologia<>'Magazzino' AND M.CAP=35121
        UNION ALL
        SELECT NULL AS RepertiEsposti, COUNT(CodS) as RepertiEsposti
        FROM Museo M, Locazione L, RepertoStorico R
        WHERE M.CodiceMuseo=L.CodMuseo AND L.CodLuogo=R.CodDep AND L.Tipologia='Magazzino' AND M.CAP=35121) T;
