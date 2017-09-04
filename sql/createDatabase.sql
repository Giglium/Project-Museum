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
