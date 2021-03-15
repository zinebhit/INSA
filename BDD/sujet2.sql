--Exercice 1.a/ Creation de la BDD
SELECT "EXERCICE 1";

CREATE TABLE EMPLOYEE (
employee_name VARCHAR(30) PRIMARY KEY,street VARCHAR(30),city VARCHAR(30) );

CREATE TABLE COMPANY (
company_name VARCHAR(30) PRIMARY KEY,city VARCHAR(30) );

CREATE TABLE WORKS (
employee_name VARCHAR(30) PRIMARY KEY,company_name VARCHAR (30),salary INT, 
FOREIGN KEY (employee_name) REFERENCES EMPLOYEE(employee_name) ON DELETE CASCADE,
FOREIGN KEY (company_name) REFERENCES COMPANY(company_name) ON DELETE CASCADE) ;

CREATE TABLE MANAGES (
employee_name VARCHAR(30) PRIMARY KEY,manager_name VARCHAR(30),
FOREIGN KEY (employee_name) REFERENCES EMPLOYEE(employee_name) ON DELETE CASCADE,
FOREIGN KEY (manager_name) REFERENCES EMPLOYEE(employee_name) ON DELETE CASCADE);

SELECT"TABLES CREATED";
--Exercice 1.b/ Population de la table bdd
INSERT INTO EMPLOYEE VALUES ("Anas","Oxford street","London");
INSERT INTO EMPLOYEE VALUES ("Lina", "Hay Riad","Rabat");
INSERT INTO EMPLOYEE VALUES ("Nadia", "7th avenue","London");
INSERT INTO EMPLOYEE VALUES ("Sam", "5th avenue", "London");
INSERT INTO EMPLOYEE VALUES ("Ibriza", "Avenue Ernest Renan", "Bourges");
INSERT INTO EMPLOYEE VALUES ("Zineb", "Avenue Ernest Renan", "Bourges");
INSERT INTO EMPLOYEE VALUES ("Jones", "Rue Lahitolle", "Bourges");
INSERT INTO EMPLOYEE VALUES ("Chris","Rue de Rivoli","Paris");



INSERT INTO WORKS VALUES ("Anas", "First Bank Corporation", 11000);
INSERT INTO WORKS VALUES ("Lina", "First Bank Corporation", 20000);
INSERT INTO WORKS VALUES ("Nadia", "Small Bank Corporation",1000);
INSERT INTO WORKS VALUES ("Sam", "Small Bank Corporation",100);
INSERT INTO WORKS VALUES ("Ibriza", "PWC", 7000);
INSERT INTO WORKS VALUES ("Zineb", "PWC", 3000);
INSERT INTO WORKS VALUES ("Jones", "Small Bank Corporation", 4000);
INSERT INTO WORKS VALUES ("Chris", "First Bank Corporation", 8000);



INSERT INTO COMPANY VALUES ("First Bank Corporation", "London");
INSERT INTO COMPANY VALUES ("PWC", "Paris");
INSERT INTO COMPANY VALUES ("Small Bank Corporation", "London");

INSERT INTO MANAGES VALUES ("Anas","Lina");
INSERT INTO MANAGES VALUES ("Ibriza","Zineb");
INSERT INTO MANAGES VALUES ("Nadia", "Sam");
INSERT INTO MANAGES VALUES ("Jones","Sam");
INSERT INTO MANAGES VALUES ("Lina","Chris");
SELECT"ADDED VALUES TO TABLES";


--Exercice 2 : Les requêtes 
SELECT "EXERCICE 2";
SELECT " --a: Les noms et les villes de tous les employes de First Bank Corporation.";
SELECT "";
SELECT employee_name,city FROM EMPLOYEE NATURAL JOIN WORKS
WHERE company_name="First Bank Corporation";
SELECT "";


SELECT " --b: Les noms, rues et villes de tous les employes de First Bank Corporation qui gagnent plus de $10 000.
";
SELECT "";
SELECT employee_name,street,city FROM EMPLOYEE NATURAL JOIN WORKS
WHERE company_name="First Bank Corporation" AND salary>=10000;
SELECT "";

SELECT "--c: Les noms des employes qui ne travaillent pas pour First Bank Corporation.";
SELECT "";
SELECT employee_name FROM EMPLOYEE NATURAL JOIN WORKS
WHERE company_name!="First Bank Corporation";
SELECT "";

SELECT "--d: Les noms des employ ́es qui gagnent plus que tous les employ es de Small Bank Corporation.";
SELECT "";
SELECT employee_name FROM EMPLOYEE NATURAL JOIN WORKS
WHERE salary > (SELECT MAX(salary) FROM EMPLOYEE NATURAL JOIN WORKS
            	WHERE company_name="Small Bank Corporation");
SELECT "";

SELECT "--e: Les noms des compagnies qui sont localis ́ees dans la mˆeme ville que Small Bank Corporation.";
SELECT "";
SELECT company_name FROM COMPANY WHERE company_name!="Small Bank Corporation" 
	AND city IN (SELECT CITY 
				FROM COMPANY
				WHERE company_name="Small Bank Corporation");
SELECT "";

SELECT "--f: Les noms des compagnies qui ont le plus d’employes.";
SELECT "";
WITH 
	nb_employee as 
		(SELECT company_name as name, count(*) as value
		FROM WORKS NATURAL JOIN COMPANY
		GROUP BY company_name),
	max_nb_employee as 
		(SELECT MAX(value) as max_value
		FROM nb_employee)
SELECT name
FROM nb_employee, max_nb_employee
WHERE value = max_value;
SELECT "";

SELECT "--g: Les noms des compagnies pour lesquelles le salaire moyen des employes est superieur au salaire moyen des employes de Small Bank Corporation";
SELECT "";
WITH avg_company_salary as(SELECT company_name, avg(salary) as value
		FROM WORKS NATURAL JOIN COMPANY
		GROUP BY company_name)
SELECT A1.company_name
FROM avg_company_salary as A1, avg_company_salary as A2
WHERE A2.company_name="Small Bank Corporation" and A2.value< A1.value;
SELECT "";



SELECT "--h:  Les noms des employes qui habitent dans la meme ville que les compagnies pour lesquelles ils travaillent.";
SELECT "";
WITH info_employee(name_employee, city_employee, company_employee) as 
	(SELECT E.employee_name, city, company_name
	FROM EMPLOYEE E NATURAL JOIN WORKS)
SELECT name_employee
FROM info_employee as INFO, COMPANY as COMP
WHERE company_employee=COMP.company_name and city_employee=COMP.city;
SELECT "";

SELECT "--i: Les noms des employes qui habitent sur la meme rue et dans la meme ville que leurs managers.";
SELECT "";
SELECT M.employee_name
FROM (EMPLOYEE NATURAL JOIN MANAGES) as M, employee as E
WHERE M.employee_name != E.employee_name AND M.manager_name = E.employee_name AND  E.street = M.street AND E.city = M.city ;
SELECT "";


SELECT "--j: Les noms des employ ́es qui gagnent plus que le salaire moyen des employ ́es de leur compagnie.";
SELECT "";
WITH avg_company_salary as(SELECT company_name, avg(salary) as value
		FROM WORKS NATURAL JOIN COMPANY
		GROUP BY company_name),
	info_employee as
		(SELECT E.employee_name as name_employee, company_name, salary
		FROM EMPLOYEE E, WORKS W
		WHERE name_employee=W.employee_name)
SELECT IE.name_employee
FROM avg_company_salary as A, info_employee as IE
WHERE A.company_name=IE.company_name AND IE.salary>value;
SELECT "";


SELECT "--k: Les noms de compagnies pour lesquelles la somme de tous les salaires est minimale.";
SELECT "";
WITH 
	sum_salary_company(name, value) as 
		(SELECT company_name, SUM(salary)
		FROM WORKS NATURAL JOIN EMPLOYEE
		GROUP BY company_name),
	min_sum_salary_company(min_value) as 
		(SELECT MIN(value)
		FROM sum_salary_company)
SELECT name
FROM sum_salary_company, min_sum_salary_company
WHERE value=min_value;
SELECT "";



--Exercice 3 : Les mises à jour ! 
SELECT "Exercice 3 ";

SELECT "--a: La nouvelle ville de residence de l’employe Jones est Newtown.";
SELECT "";
UPDATE EMPLOYEE
SET city="Newton"
WHERE employee_name="Jones";
SELECT "Completed";
SELECT "";

SELECT "--b: Auguementation de salaire sous conditions ";
SELECT "";
UPDATE WORKS
SET salary = CASE
		when salary*1.1 < 100000 then salary*1.1
		else salary*1.03
		end
WHERE company_name = 'First Bank Corporation' AND employee_name IN (SELECT manager_name FROM manages);
SELECT "Completed";
SELECT "";
--v2 too repetitive with the WHERE REQUETTE
/*UPDATE WORKS */
/*raise of 3% only if the maximum of 10% was reached*/
/*SET salary = salary * 1.03;
WHERE employee_name IN (SELECT manager_name FROM manages) AND salary * 1.1 > 100000 AND company_name = 'First Bank Corporation';
/*raise in case of the maximum salary with raise is not reached */
/*UPDATE WORKS 
SET salary = salary * 1.1
WHERE employee_name IN (SELECT manager_name FROM manages) AND salary * 1.1 <= 100000 AND company_name = 'First Bank Corporation';*/


SELECT "--c: Augmentez avec 10% le salaire de tous les employes de First Bank Corporation.";
SELECT "";
UPDATE WORKS 
SET salary = salary * 1.1
WHERE company_name="First Bank Corporation";
SELECT "Completed";
SELECT "";

SELECT "--d: Supprimez tous les tuples de la table works pour les employes de Small Bank Corporation.";
SELECT "";
DELETE FROM WORKS
WHERE company_name="Small Bank Corporation";
SELECT "Completed";
SELECT "";