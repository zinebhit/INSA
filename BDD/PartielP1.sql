PRAGMA foreign_keys = ON;
SELECT "PARTIE 1 SQL :";
SELECT "";
---Question 1 & 2 :
SELECT " --Question 1 et 2 : Creation de la base de donnees";
SELECT "";
CREATE TABLE CLIENT (
    cid INT PRIMARY KEY,
    nom VARCHAR(50)
    );

CREATE TABLE VEHICULE (
    vid INT PRIMARY KEY,
    marque VARCHAR(20),
    annee INT,
    type CHAR(1),
    CONSTRAINT checktype CHECK ( type='U' or type='T' ),
    CONSTRAINT checkyear CHECK ( annee > 2000 )  
    );

CREATE TABLE LOCATION (
    cid INT,
    vid INT,
    debut DATE NOT NULL, 
    fin DATE,
    PRIMARY KEY (cid, vid, debut),
    FOREIGN KEY (cid) REFERENCES CLIENT(cid) ON DELETE CASCADE,
    FOREIGN KEY (vid) REFERENCES VEHICULE(vid) ON DELETE CASCADE,
    CONSTRAINT checkdate CHECK ( fin >= debut )
    ); 
SELECT "CREATION DES TABLES RÉUSSIE ";
SELECT "";
---Question 3 :
SELECT " --Question 3: Ajout dans la BDD";
SELECT "";


INSERT INTO CLIENT VALUES (1, "Jean Serrien");
INSERT INTO CLIENT VALUES (2, "Paul Ochon");
INSERT INTO CLIENT VALUES (3, "Zineb Hitait");



INSERT INTO VEHICULE VALUES (88, "Renault", 2016, "U");
INSERT INTO VEHICULE VALUES (89, "Peugeot", 2018, "T");
INSERT INTO VEHICULE VALUES (90, "Renault", 2020, "U");


INSERT INTO LOCATION VALUES (1, 88, '2020-02-15', '2020-02-20');
INSERT INTO LOCATION VALUES (1, 88, '2020-03-10', NULL);
INSERT INTO LOCATION VALUES (2, 88, '2020-01-20', '2020-01-24');
INSERT INTO LOCATION VALUES (2, 89, '2020-03-02', '2020-03-08');
INSERT INTO LOCATION VALUES (2, 90, '2020-04-02', '2020-04-08');

SELECT "AJOUT DANS LA BASE DE DONNEES RÉUSSIE ";
SELECT "";

---Question 4 :
SELECT " --Question 4: la marque et le type de tous les vehicules de 2018";
SELECT "";
SELECT marque,type
from VEHICULE 
WHERE annee="2018";
SELECT "";

---Question 5 :
SELECT " --Question 5: Pour chaque location: le locataire, la marque, l’annee, le type et les dates de debut et de fin de la location";
SELECT "";
SELECT nom, marque, annee, type, debut, fin 
from LOCATION
NATURAL JOIN CLIENT
NATURAL JOIN VEHICULE;
SELECT "";

---Question 6 :
SELECT "--Question 6: Idem que précédemment avec la contrainte marque = Renault";
SELECT "";
SELECT nom, marque, annee, type, debut, fin 
FROM LOCATION
NATURAL JOIN CLIENT
NATURAL JOIN VEHICULE
WHERE marque="Renault";

SELECT "";
---Question 7 :
SELECT "--Question 7: idem que la 6 avec la contrainte : la date de fin de la location != NULL ";
SELECT "";
SELECT nom, marque, annee, type, debut, fin 
FROM LOCATION
NATURAL JOIN CLIENT 
NATURAL JOIN VEHICULE
WHERE marque="Renault" AND fin IS NOT NULL;
SELECT "";
---Question 8 :
SELECT "--Question 8: Nombres de locations effectuées pour chaque client  ";
SELECT "";
SELECT nom, COUNT(l.cid) as nbLocations
FROM CLIENT c LEFT JOIN LOCATION l
ON l.cid=c.cid
GROUP BY c.cid
ORDER BY nbLocations DESC;
SELECT "";
---Question 9 :
SELECT "--Question 9: les noms de clients qui ont loués tous les vehicules de la base de donnees";
SELECT "";
SELECT "-Version 1 ";
SELECT nom
FROM CLIENT c
WHERE NOT EXISTS (
    SELECT * 
    FROM VEHICULE v
    WHERE NOT EXISTS (
        SELECT * 
        FROM LOCATION l
        WHERE l.vid=v.vid and l.cid=c.cid
        )
);
SELECT "";
SELECT "-Version 2";
SELECT nom
FROM LOCATION, VEHICULE, CLIENT
WHERE LOCATION.vid=VEHICULE.vid AND CLIENT.cid=LOCATION.cid
GROUP BY CLIENT.cid HAVING COUNT(DISTINCT LOCATION.vid) = (SELECT COUNT(DISTINCT vid)FROM VEHICULE);
SELECT "";
SELECT "";

---Question 10 :
SELECT "--Question 10";
SELECT count(*) FROM client LEFT OUTER JOIN location USING(cid);
SELECT"La requete  1 retourne le nombre entier de clients ayant ou pas des locations donc elle prend en compte ceux à 0 Locations également";
SELECT count(*) FROM location LEFT OUTER JOIN client USING (cid);
SELECT"La requete  2 retourne le nombre de locations propres aux clients et le nombre de ceux qui n'ont pas été louées";
SELECT"et donc il manque dans la deuxième les clients avec NULL Location";
SELECT"(ii) est vrai : la modification de l'instance serai dans nos considérations : On ne prendra des clients que lorsqu'il auront effectué au moins une location et dans ce cas la sortie des deux requetes sera la meme";
SELECT "";

---Question 11 :
SELECT "--Question 11";
SELECT "";

CREATE TABLE FIDELITY (
    cid INT PRIMARY KEY,
    score FLOAT);
    
INSERT INTO FIDELITY 
SELECT cid, (nblU*0.75 + nblT*0.5) AS score
FROM (SELECT cid, COUNT(VEHICULE.type='U') AS nblU, COUNT(VEHICULE.type='T') AS nblT 
FROM CLIENT 
NATURAL JOIN LOCATION 
NATURAL JOIN VEHICULE
GROUP BY cid
) AS nbLType
WHERE score > 1;

SELECT * FROM FIDELITY;
SELECT "";
---Question 12 :
SELECT "--Question 12: BDD hopital Coronavirus";
SELECT "";
SELECT "--a:";
CREATE TABLE MALADE (
	patient VARCHAR(20) PRIMARY KEY, 
	dateDiagnostic DATE); 
select "CREATION DE LA TABLE REUSSIE";
select "";
INSERT INTO MALADE VALUES ('Paul Ochon','2020-02-28');
INSERT INTO MALADE VALUES('Anna Park','2021-03-29');
SELECT "AJOUT DANS LA BASE DE DONNEES RÉUSSIE ";
SELECT "";
SELECT "--b:";
CREATE View idMalade as
SELECT cid,dateDiagnostic FROM CLIENT,MALADE
WHERE nom = patient;
SELECT "";
SELECT "Affichage view ";
SELECT *
FROM idMalade;

SELECT "--c:";
SELECT nom
FROM client
WHERE cid=(SELECT l1.cid
            FROM location l1, location l2, idMalade m
            WHERE m.DateDiagnostic<l1.debut AND l1.cid<>l2.cid AND l1.vid=l2.vid AND l2.cid=m.cid);
SELECT "";





