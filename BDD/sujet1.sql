--Exercice 1 :
--Question 1:

SELECT DISTINCT Format FROM ARTICLE
--Question 2:

SELECT Titre from ARTICLE WHERE TypeArt LIKE 'long';
--Question 3:

SELECT Titre from(SELECT * from ARTICLE WHERE TypeArt = 'Court' OR TypeArt='Poster')WHERE Taille >8192;
--V2

SELECT Titre from ARTICLE
WHERE (TypeArt LIKE 'Court' OR TypeArt LIKE 'Poster') AND (Taille >8000);

--V3
SELECT Titre from ARTICLE 
WHERE (TypeArt='Court'and Taille > 8000)OR (TypeArt='Poster'and Taille > 8000)
--Question 4 :

SELECT COUNT(*) FROM ARTICLE 
WHERE TypeArt='Poster';
--Question 5 :

SELECT Titre from  ARTICLE WHERE Format LIKE 'Pdf'
ORDER BY Taille DESC;
--Question 6 : en join

SELECT CONF.IdConf from ANNEECONF AN , CONFERENCE CONF  WHERE PorteeConf='Internationale' AND AN.Annee > 2006;
--Question 7 :

SELECT TypeArt,count(*) from ARTICLE
GROUP BY TypeArt;
--Question 8 :

SELECT Format,AVG(Taille) from ARTICLE
GROUP BY Format;
--Question 9:

SELECT Pays,COUNT(IdPersonne) FROM LECTEUR
   ...> GROUP BY Pays
   ...> HAVING COUNT(IdPersonne) < 10;
--Question 10 :

SELECT Ville ,COUNT(IdPersonne) FROM LECTEUR WHERE Pays='France'
   ...> GROUP BY Ville
   ...> HAVING COUNT(IdPersonne) > 2;
--Question 11 :

SELECT Pays, COUNT(IdConf) FROM ANNEECONF
   ...> GROUP BY Pays
   ...> ORDER BY COUNT(IdConf) DESC;
--Question 12 :

SELECT Pays, COUNT(IdConf) FROM ANNEECONF
   ...> GROUP BY Pays
   ...> HAVING COUNT(IdConf)>5
   ...> ORDER BY COUNT(IdConf) DESC;
--Question 13 :
Affichage total en dessous, juste modfie la base de données et pas de la table :

    SELECT Pays, COUNT(IdConf) FROM ANNEECONF
    GROUP BY Pays
    UNION ALL
    SELECT 'Total', COUNT (IdConf) FROM ANNEECONF;
--Question 14 :

SELECT Nom,Prenom,IFNULL(Mail,'à préciser') from LECTEUR LEC,PERSONNE PER
WHERE LEC.IdPersonne=PER.IdPersonne 
--Question 15 :(wrong diff)

SELECT Titre,PER.Nom,PER.Prenom,AUT.Labo from ARTICLE AR,PERSONNE PER,AUTEUR AUT,ECRIT EC
WHERE EC.IdPersonne=AUT.IdPersonne
AND AUT.IdPersonne=PER.IdPersonne 
AND AR.IdArticle=EC.IdArticle;

--V2

SELECT DISTINCT Titre,Nom,Prenom,Labo from ECRIT EC
JOIN ARTICLE AR ON AR.IdArticle=EC.IdArticle
JOIN AUTEUR AUT ON AUT.IdPersonne=EC.IdPersonne 
JOIN PERSONNE PER ON AUT.IdPersonne=PER.IdPersonne ;
--Question 16 :(wrong diff)

SELECT DISTINCT Titre,Nom,Prenom,Labo from ECRIT EC
JOIN ARTICLE AR ON AR.IdArticle=EC.IdArticle  
JOIN AUTEUR AUT ON AUT.IdPersonne=EC.IdPersonne 
JOIN PERSONNE PER ON AUT.IdPersonne=PER.IdPersonne 
WHERE TypeArt ='Poster';

--V2

SELECT DISTINCT Titre,Nom,Prenom,Labo from ECRIT EC
JOIN ARTICLE AR ON AR.IdArticle=EC.IdArticle AND TypeArt ='Poster'
JOIN AUTEUR AUT ON AUT.IdPersonne=EC.IdPersonne 
JOIN PERSONNE PER ON AUT.IdPersonne=PER.IdPersonne 
--Question 17 :

SELECT Nom,Prenom,COUNT(Prenom)from PERSONNE
GROUP BY Prenom
HAVING  COUNT(Prenom) > 1
ORDER BY Nom ASC;

--V2

SELECT Nom,Prenomfrom PERSONNE
GROUP BY Nom,Prenom
HAVING  COUNT() > 1
--Question 18 :

SELECT PER.Nom,PER.Prenom,LEC.Adresse,LEC.Code,LEC.Ville,LEC.Pays from PERSONNE PER,LECTEUR LEC
WHERE LEC.IdPersonne=PER.IdPersonne;
--Question 19 :
/*TODO:REDO*/

/*SELECT AR.Titrefrom ARTICLE AR,ANNEECONF ANN
WHERE AR.IdConf=ANN.IdConf AND ANN.Ville ='France';*/
 

SELECT DISTINCT Titre from ARTICLE A
JOIN ANNEECONF ANN ON A.IdConf=ANN.IdConf
WHERE ANN.Ville ='France';
--Question 20 :

SELECT DISTINCT Pays
from CONFERENCE CONF,ANNEECONF ANN
WHERE CONF.IdConf=ANN.IdConf
GROUP BY Pays,Annee
HAVING COUNT(DISTINCT CONF.IdConf)>5;
--Question 21 :

SELECT Pays, COUNT(IdConf) FROM ANNEECONF
    GROUP BY Pays
    UNION ALL
    SELECT 'Total', COUNT (IdConf) FROM ANNEECONF;
    ORDER BY VALUE DESC
--Question 22 :

SELECT Pays, COUNT(IdConf) FROM ANNEECONF
    GROUP BY Pays
    UNION ALL
    SELECT 'Total', COUNT (IdConf) FROM ANNEECONF;
    ORDER BY VALUE DESC
