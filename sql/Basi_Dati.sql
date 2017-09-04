/*Effettua una pulizia, eliminando le tabelle qualora esistessero gia`*/

DROP TABLE IF EXISTS Creato;
DROP TABLE IF EXISTS RepertoArtistico;
DROP TABLE IF EXISTS RepertoStorico;
DROP TABLE IF EXISTS Artista;
DROP TABLE IF EXISTS Locazione;
DROP TABLE IF EXISTS Fornitore;
DROP TABLE IF EXISTS Dipendente;
DROP TABLE IF EXISTS Museo;
DROP TABLE IF EXISTS Errori;

/*Crea la tabella Errori*/
CREATE TABLE IF NOT EXISTS Errori
(
CodiceErrore smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Descrizione varchar(255) NOT NULL,
PRIMARY KEY (CodiceErrore)
)ENGINE=InnoDB;

/*Crea la tabella Museo*/
CREATE TABLE IF NOT EXISTS Museo
(
CodiceMuseo tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Nome varchar(200) NOT NULL,
Categoria varchar(100) NOT NULL,
Via varchar(250) NOT NULL,
CAP varchar(5) NOT NULL,
Telefono varchar(15) NOT NULL,
OrarioApertura time NOT NULL,
OrarioChiusura time NOT NULL,
PRIMARY KEY (CodiceMuseo)
) ENGINE=InnoDB;

/*Crea la tabella Dipendente*/
CREATE TABLE IF NOT EXISTS Dipendente
(
CodiceDip smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Stipendio int UNSIGNED NOT NULL DEFAULT 0, 
Contratto ENUM('Part Time', 'Full Time'),
Lavoro varchar(100) NOT NULL,
Sesso ENUM('M', 'F'),
CodiceFiscale varchar(16) NOT NULL,
Nome varchar(25) NOT NULL,
Cognome varchar(25) NOT NULL,
Cellulare varchar(20) DEFAULT NULL,
Email varchar(50) DEFAULT NULL, 
Via varchar(250) NOT NULL,
Citta varchar(100) NOT NULL,
CAP varchar(5) NOT NULL,
DatadiNascita date NOT NULL,
CodMuseo tinyint UNSIGNED NOT NULL,
PRIMARY KEY(CodiceDip),
FOREIGN KEY (CodMuseo) REFERENCES Museo(CodiceMuseo) ON DELETE CASCADE
) ENGINE=InnoDB;

/*Crea la tabella Fornitore*/
CREATE TABLE IF NOT EXISTS Fornitore
(
ID smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Nome varchar(100) NOT NULL,
Ente ENUM ('SI','NO') NOT NULL,
CodiceFiscale varchar(16) NOT NULL,
PartitaIVA varchar(11) DEFAULT NULL,
PRIMARY KEY (ID)
) ENGINE=InnoDB;

/*Crea la tabella Locazione*/
CREATE TABLE IF NOT EXISTS Locazione
(
CodLuogo smallint UNSIGNED NOT NULL AUTO_INCREMENT,
NomeSala varchar(50) NOT NULL,
Tipologia varchar(50) NOT NULL,
CodMuseo tinyint UNSIGNED NOT NULL,
PRIMARY KEY (CodLuogo),
FOREIGN KEY (CodMuseo) REFERENCES Museo(CodiceMuseo) ON DELETE CASCADE
)ENGINE=InnoDB;

/*Crea la tabella Artista*/
CREATE TABLE IF NOT EXISTS Artista
(
IDArtista smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Nome varchar(25) NOT NULL,
Cognome varchar(25) NOT NULL,
DataNascita date null DEFAULT null,
DataMorte date null DEFAULT null,
PRIMARY KEY (IDArtista)
)ENGINE=InnoDB;

/*Crea la tabella RepertoArtistico*/
CREATE TABLE IF NOT EXISTS RepertoArtistico
(
CodA smallint UNSIGNED NOT NULL,
Nome varchar(50) NOT NULL,
Donato ENUM ('SI','NO') NOT NULL,
ValoreStimato bigint UNSIGNED,
InizioRestauro date DEFAULT NULL,
FineRestauro date DEFAULT NULL,
Corrente varchar(25) NOT NULL,
Materiale char(50) DEFAULT NULL,
Tecnica char(50) DEFAULT NULL,
Tipo char(20) NOT NULL,
CodFornitore smallint UNSIGNED DEFAULT NULL,
CodDep smallint UNSIGNED DEFAULT NULL,
PRIMARY KEY (CodA),
FOREIGN KEY (CodFornitore) REFERENCES Fornitore(ID) ON DELETE SET NULL,
FOREIGN KEY (CodDep) REFERENCES Locazione(CodLuogo) ON DELETE SET NULL
) ENGINE=InnoDB;

/*Crea la tabella RepertoStorico*/
CREATE TABLE IF NOT EXISTS RepertoStorico
(
CodS smallint UNSIGNED NOT NULL,
Nome varchar(50) NOT NULL,
Donato ENUM ('SI','NO') NOT NULL,
ValoreStimato bigint UNSIGNED,
InizioRestauro date DEFAULT NULL,
FineRestauro date DEFAULT NULL,
Datazione bigint DEFAULT NULL,
Ritr varchar(50) NOT NULL,
SpecApp varchar(50) DEFAULT NULL,
Materiale varchar(50) DEFAULT NULL,
Tipo varchar(20) NOT NULL,
CodFornitore smallint UNSIGNED DEFAULT NULL,
CodDep smallint UNSIGNED DEFAULT NULL,
PRIMARY KEY (CodS),
FOREIGN KEY (CodFornitore) REFERENCES Fornitore(ID) ON DELETE SET NULL,
FOREIGN KEY (CodDep) REFERENCES Locazione(CodLuogo) ON DELETE SET NULL
) ENGINE=InnoDB;

/*Crea la tabella Creato*/
CREATE TABLE IF NOT EXISTS Creato
(
CodReperto smallint UNSIGNED NOT NULL,
CodArtista smallint UNSIGNED NOT NULL,
PRIMARY KEY (CodReperto,CodArtista),
FOREIGN KEY (CodReperto) REFERENCES RepertoArtistico(CodA) ON DELETE CASCADE,
FOREIGN KEY (CodArtista) REFERENCES Artista(IDArtista) ON DELETE CASCADE
)ENGINE=InnoDB;

/*Trigger*/
DELIMITER $
DROP TRIGGER IF EXISTS ControlloDipIns$

CREATE TRIGGER ControlloDipIns
BEFORE INSERT ON Dipendente
FOR EACH ROW
BEGIN
SET NEW.CodiceFiscale=UPPER(NEW.CodiceFiscale);
END$

DROP TRIGGER IF EXISTS ControlloDipUp$

CREATE TRIGGER ControlloDipUp
BEFORE UPDATE ON Dipendente
FOR EACH ROW
BEGIN
SET NEW.CodiceFiscale=UPPER(NEW.CodiceFiscale);
END$

DROP TRIGGER IF EXISTS ControlloForIns$

CREATE TRIGGER ControlloForIns
BEFORE INSERT ON Fornitore
FOR EACH ROW
BEGIN
SET NEW.CodiceFiscale=UPPER(NEW.CodiceFiscale);
IF NEW.PartitaIVA IS NOT NULL THEN
    IF NEW.Ente=2 THEN
        SET NEW.PartitaIVA=NULL;
	   	INSERT INTO Errori(Descrizione) VALUES (CONCAT ('Il Fornitore Codice Fiscale: ', NEW.CodiceFiscale,' ha generato un errore nella tabella Fornitori. Un privato non ha partita IVA ! '));
	ELSE SET NEW.PartitaIVA=UPPER(NEW.PartitaIVA);
    END IF;
END IF;
END$

DROP TRIGGER IF EXISTS ControlloForUp$

CREATE TRIGGER ControlloForUp
BEFORE UPDATE ON Fornitore
FOR EACH ROW
BEGIN
SET NEW.CodiceFiscale=UPPER(NEW.CodiceFiscale);
IF NEW.PartitaIVA IS NOT NULL THEN
    IF NEW.Ente=2 THEN
        SET NEW.PartitaIVA=NULL;
	   	INSERT INTO Errori(Descrizione) VALUES (CONCAT ('Il Fornitore Codice Fiscale: ', NEW.CodiceFiscale,' ha generato un errore nella tabella Fornitori. Un privato non ha partita IVA ! '));
	ELSE SET NEW.PartitaIVA=UPPER(NEW.PartitaIVA);
    END IF;
END IF;
END$

DROP TRIGGER IF EXISTS ControlloDataReArtIns$

CREATE TRIGGER ControlloDataReArtIns
BEFORE INSERT ON RepertoArtistico
FOR EACH ROW
BEGIN
IF CURDATE() > NEW.InizioRestauro THEN
SET NEW.InizioRestauro=NULL;
    SET NEW.FineRestauro=NULL;
	INSERT INTO Errori(Descrizione) VALUES (CONCAT ('Il reperto ID: ', NEW.CodA,' ha generato un errore nella tabella RepertoArtistico. InizioRestauro antecedente a oggi'));
ELSE IF NEW.FineRestauro < NEW.InizioRestauro THEN
    SET NEW.InizioRestauro=NULL;
    SET NEW.FineRestauro=NULL;
	INSERT INTO Errori(Descrizione) VALUES (CONCAT ('Il reperto ID: ', NEW.CodA,' ha generato un errore nella tabella RepertoArtistico. InizioRestauro > FineRestauro !'));
	END IF;
END IF;
END$

DROP TRIGGER IF EXISTS ControlloDataReArtUP$

CREATE TRIGGER ControlloDataReArtUP
BEFORE UPDATE ON RepertoArtistico
FOR EACH ROW
BEGIN
IF NEW.FineRestauro < NEW.InizioRestauro THEN
    SET NEW.InizioRestauro=NULL;
    SET NEW.FineRestauro=NULL;
	INSERT INTO Errori(Descrizione) VALUES (CONCAT ('Il reperto ID: ', NEW.CodA,' ha generato un errore nella tabella RepertoArtistico. InizioRestauro > FineRestauro ! '));
END IF;
END$

DROP TRIGGER IF EXISTS ControlloDataReStoIns$

CREATE TRIGGER ControlloDataReStoIns
BEFORE INSERT ON RepertoStorico
FOR EACH ROW
BEGIN
IF NEW.FineRestauro < NEW.InizioRestauro THEN
    SET NEW.InizioRestauro=NULL;
    SET NEW.FineRestauro=NULL;
	INSERT INTO Errori(Descrizione) VALUES (CONCAT ('Il reperto ID: ', NEW.CodS,' ha generato un errore nella tabella RepertoStorico. InizioRestauro > FineRestauro ! '));
END IF;
END$

DROP TRIGGER IF EXISTS ControlloDataStoUP$

CREATE TRIGGER ControlloDataStoUP
BEFORE UPDATE ON RepertoStorico
FOR EACH ROW
BEGIN
IF NEW.FineRestauro < NEW.InizioRestauro THEN
    SET NEW.InizioRestauro=NULL;
    SET NEW.FineRestauro=NULL;
	INSERT INTO Errori(Descrizione) VALUES (CONCAT ('Il reperto ID: ', NEW.CodS,' ha generato un errore nella tabella RepertoStorico. InizioRestauro > FineRestauro ! '));
END IF;
END$

DROP TRIGGER IF EXISTS ControlloDataArtistaIns$

CREATE TRIGGER ControlloDataArtistaIns
BEFORE INSERT ON Artista
FOR EACH ROW
BEGIN
IF NEW.DataMorte < NEW.DataNascita THEN
	SET NEW.DataMorte=NULL;
    SET NEW.DataNascita=NULL;
	INSERT INTO Errori(Descrizione) VALUES (CONCAT ('Errore generato da ID: ', NEW.Nome, ' ', New.Cognome, ' nella tabella Artista. DataMorte > DataNascita ! '));
END IF;
END$

DROP TRIGGER IF EXISTS ControlloDataArtistaUP$

CREATE TRIGGER ControlloDataArtistaUP
BEFORE UPDATE ON Artista
FOR EACH ROW
BEGIN
IF NEW.DataMorte < NEW.DataNascita THEN
    SET NEW.DataMorte=NULL;
    SET NEW.DataNascita=NULL;
	INSERT INTO Errori(Descrizione) VALUES (CONCAT ('Errore generato da ID: ', NEW.Nome, ' ', New.Cognome, ' nella tabella Artista. DataMorte > DataNascita ! '));
END IF;
END$

DELIMITER ;

/*Popola*/

LOAD DATA LOCAL INFILE 'Dati/Musei.csv'
INTO TABLE Museo
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n' 
(Nome, Categoria, Via, CAP, Telefono, OrarioApertura, OrarioChiusura)
SET CodiceMuseo=NULL;


LOAD DATA LOCAL INFILE 'Dati/Artisti.csv'
INTO TABLE Artista
FIELDS TERMINATED BY','
LINES TERMINATED BY '\r\n'
(Nome, Cognome, DataNascita, DataMorte)
SET IDArtista=NULL;

LOAD DATA LOCAL INFILE 'Dati/Persone.csv'
INTO TABLE Dipendente
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
(Stipendio, Contratto, Lavoro, Sesso, CodiceFiscale, Nome, Cognome, Cellulare, Email, Via, Citta, CAP, DatadiNascita, CodMuseo)
SET CodiceDip=NULL;


LOAD DATA LOCAL INFILE 'Dati/Fornitori.csv'
INTO TABLE Fornitore
FIELDS TERMINATED BY','
LINES TERMINATED BY '\r\n'
(Nome, Ente, CodiceFiscale, PartitaIVA)
SET ID=NULL;


LOAD DATA LOCAL INFILE 'Dati/Locazioni.csv'
INTO TABLE Locazione
FIELDS TERMINATED BY','
LINES TERMINATED BY '\r\n'
(NomeSala, Tipologia, CodMuseo)
SET CodLuogo=NULL;


LOAD DATA LOCAL INFILE 'Dati/RepertiArtistici.csv'
INTO TABLE RepertoArtistico
FIELDS TERMINATED BY','
LINES TERMINATED BY '\r\n'
(CodA, Nome, Donato, ValoreStimato, InizioRestauro, FineRestauro, Corrente, Materiale, Tecnica, Tipo, CodFornitore, CodDep);


LOAD DATA LOCAL INFILE 'Dati/RepertiStorici.csv'
INTO TABLE RepertoStorico
FIELDS TERMINATED BY','
LINES TERMINATED BY '\r\n'
(CodS, Nome, Donato, ValoreStimato, InizioRestauro, FineRestauro, Datazione, Ritr, SpecApp, Materiale, Tipo, CodFornitore, CodDep);

LOAD DATA LOCAL INFILE 'Dati/Creato.csv'
INTO TABLE Creato
FIELDS TERMINATED BY','
LINES TERMINATED BY '\r\n'
(CodReperto, CodArtista);

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
