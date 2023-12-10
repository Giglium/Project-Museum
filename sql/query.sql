/*QUERY 1*/

DROP VIEW IF EXISTS Query1;

CREATE VIEW Query1 AS
SELECT
    Dip.Nome,
    Dip.Cognome,
    Dip.Citta
FROM Dipendente AS Dip
WHERE
    Dip.Stipendio > (SELECT MAX(Stipendio) FROM Dipendente WHERE Citta = 'Padova');


/*QUERY 2*/
DROP VIEW IF EXISTS Query2;

CREATE VIEW Query2 AS
SELECT
    CodS AS Codice,
    Nome,
    ValoreStimato AS Valore
FROM RepertoStorico
WHERE
    Donato = 2
    AND ValoreStimato > (SELECT MAX(ValoreStimato) FROM RepertoStorico WHERE Donato = 1);

/*QUERY 3 */
DROP VIEW IF EXISTS Query3;

CREATE VIEW Query3 AS
SELECT DISTINCT Dipendente.Nome
FROM Dipendente,
    Museo
WHERE
    Dipendente.CAP = Museo.CAP
    AND YEAR(Dipendente.DatadiNascita) BETWEEN 1950 AND 1960
    AND Sesso = 1;

/*Query 4*/
DROP VIEW IF EXISTS MediaValoreS;

SET SQL_MODE = '';

CREATE VIEW MediaValoreS AS
SELECT AVG(ValoreStimato) AS Media
FROM RepertoStorico
WHERE Tipo = 'Manufatto';

SELECT
    Dip.Cognome,
    Dip.Nome,
    Dip.Stipendio
FROM Dipendente AS Dip,
    Museo AS M,
    Locazione AS L,
    RepertoStorico AS R
WHERE
    Dip.CodMuseo = M.CodiceMuseo
    AND M.CodiceMuseo = L.CodMuseo
    AND L.CodLuogo = R.CodDep
    AND Dip.Sesso = 'F'
GROUP BY Dip.Cognome, Dip.Nome
HAVING Dip.Stipendio > (SELECT * FROM MediaValoreS);


/*QUERY 5*/
DROP VIEW IF EXISTS Table1;
DROP VIEW IF EXISTS Table2;

CREATE VIEW Table1 AS
(
    SELECT
        CodiceMuseo,
        M.Nome,
        COUNT(CodS) AS TotaleRepertiStorici
    FROM Museo AS M,
        Locazione AS L,
        RepertoStorico AS RS
    WHERE
        M.CodiceMuseo = L.CodMuseo
        AND L.CodLuogo = RS.CodDep
        AND M.CAP = 35121
    GROUP BY CodiceMuseo
);

CREATE VIEW Table2 AS
(
    SELECT
        CodiceMuseo,
        M.Nome,
        COUNT(CodA) AS TotaleRepertiArtistici
    FROM Museo AS M,
        Locazione AS L,
        RepertoArtistico AS RA
    WHERE
        M.CodiceMuseo = L.CodMuseo
        AND L.CodLuogo = RA.CodDep
    GROUP BY CodiceMuseo
);

CREATE VIEW Query5 AS
(
    SELECT
        Table1.Nome AS 'Nome Museo',
        TotaleRepertiStorici AS 'Totale Reperti Storici',
        TotaleRepertiArtistici AS 'Totale Reperti Artistici'
    FROM Table1,
        Table2
    WHERE Table1.CodiceMuseo = Table2.CodiceMuseo
);


/*QUERY 6*/

#  Cannot be converted to VIEW due to SQL limitation on sub-queries, it need to be manually run
SELECT
    MAX(RepertiEsposti) AS 'Reperti Esposti',
    MAX(RepertiInMagazzino) AS 'Reperti in Magazzino'
FROM (
    SELECT
        COUNT(CodS) AS RepertiEsposti,
        0 AS RepertiInMagazzino
    FROM Museo AS M,
        Locazione AS L,
        RepertoStorico AS R
    WHERE
        M.CodiceMuseo = L.CodMuseo
        AND L.CodLuogo = R.CodDep
        AND L.Tipologia != 'Magazzino'
        AND M.CAP = 35121
    UNION ALL
    SELECT
        NULL AS RepertiEsposti,
        COUNT(CodS) AS RepertiEsposti
    FROM Museo AS M,
        Locazione AS L,
        RepertoStorico AS R
    WHERE
        M.CodiceMuseo = L.CodMuseo
        AND L.CodLuogo = R.CodDep
        AND L.Tipologia = 'Magazzino'
        AND M.CAP = 35121
) AS T;
