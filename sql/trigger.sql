
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
