SELECT * FROM productie;
SELECT * FROM membru;
SELECT * FROM actor;
SELECT * FROM utilizator;
SELECT * FROM review;
SELECT * FROM membru_productie;
SELECT * FROM productie_actor;

-- toate  filmele din tabela productie
SELECT * FROM productie
WHERE tip = 'film';

-- toate serialele din tabela productie
SELECT titlu, gen, storyline,sezoane
FROM productie
WHERE tip = 'serial';

-- toti actorii care au biografia descrisa
SELECT * FROM actor
WHERE biografie IS NOT NULL;

-- toti membri nascuti intre anii 1950 si 1970
SELECT * FROM membru
WHERE YEAR(data_nasterii) BETWEEN 1950 AND 1970;

-- toate productiile care au genul drama
SELECT titlu,gen FROM productie
WHERE gen LIKE '%drama%';

-- detalii actori nascuti in acelasi an ca Leonardo DiCaprio
SELECT * FROM actor
WHERE YEAR(data_nasterii) = (SELECT YEAR(data_nasterii) FROM actor WHERE nume = 'DiCaprio' AND prenume = 'Leonardo Wilhelm');

-- titlu, tip si storyline pentru productiile aparute in luna in care a aparut "The Shawshank Redemption"
SELECT titlu, tip, storyline FROM productie
WHERE MONTH(data_aparitie) = (SELECT MONTH(data_aparitie) FROM productie WHERE titlu = 'The Shawshank Redemption');

-- rating, comentariu, id_productie din tabela review
-- pentru inregistrarile cu un rating mai mare de 4 (rating-ul dat de utilizatorul cu id 7)
-- ordonat dupa id_productie
SELECT rating, comentariu, id_productie FROM review
WHERE rating > (SELECT rating FROM review WHERE id_utilizator = 7)
ORDER BY id_productie;

-- membrii cu rolul lui Chris Nolan (drector) si nascuti in aceeasi luna
SELECT CONCAT(prenume, ' ', nume) nume, biografie FROM membru
WHERE (rol, MONTH(data_nasterii)) = (SELECT rol, MONTH(data_nasterii) FROM membru WHERE nume = 'Nolan' AND prenume = 'Christopher Edward');

-- lista productii grupate dupa tip (film sau serial)
SELECT tip, GROUP_CONCAT(titlu SEPARATOR '*') productie
FROM productie
GROUP BY tip;

-- lista membrii grupati dupa rolul acestora
SELECT rol, GROUP_CONCAT(CONCAT(prenume, ' ', nume)) membru
FROM membru
GROUP BY rol;

-- numarul de productii aparute intr-un an cu conditia sa fie minim 2 productii/an
SELECT YEAR(data_aparitie) an, COUNT(*) numar_productii
FROM productie
GROUP BY an
HAVING numar_productii >= 2;

-- rating, titlu_review, comentariu review si nume utilizatorului care a scris review-ul
SELECT rating, titlu_review, comentariu, nume utilizator
FROM review JOIN utilizator
ON utilizator.id = review.id_utilizator;

-- rating, comentariu review si titlu productie
SELECT rating, comentariu, titlu
FROM review JOIN productie
ON review.id_productie = productie.id;

-- actorii care au avut un rol principal intr-una dintre productii
SELECT CONCAT(prenume, ' ', nume) actor
FROM actor LEFT JOIN productie_actor
ON actor.id = productie_actor.id_actor
WHERE rol_principal IS NOT NULL;

-- titlu productie si actorii care au jucat in productia respectiva
SELECT titlu, CONCAT(prenume, ' ', nume) actor
FROM productie JOIN productie_actor ON productie.id = productie_actor.id_productie
JOIN actor ON productie_actor.id_actor = actor.id;

-- lista cu actorii din fiecare productie
SELECT titlu, GROUP_CONCAT(CONCAT(prenume, ' ', nume)) cast
FROM productie JOIN productie_actor ON productie.id = productie_actor.id_productie
JOIN actor ON productie_actor.id_actor = actor.id
GROUP BY titlu;

-- lista cu productiile in care au jucat actorii
SELECT CONCAT(prenume, ' ', nume) actor, GROUP_CONCAT(titlu) productii
FROM productie JOIN productie_actor ON productie.id = productie_actor.id_productie
JOIN actor ON productie_actor.id_actor = actor.id
GROUP BY actor;

-- lista cu productiile in care actorii au fost protagonisti
SELECT CONCAT(prenume, ' ', nume) protagonist, GROUP_CONCAT(titlu) productii
FROM productie JOIN productie_actor ON productie.id = productie_actor.id_productie
JOIN actor ON productie_actor.id_actor = actor.id
WHERE rol_principal IS NOT NULL
GROUP BY protagonist;

-- titlu productie, nume membru si rolul pe care acesta l-a avut in productia respectiva
SELECT titlu, CONCAT(prenume, ' ', nume) membru, rol
FROM productie JOIN membru_productie ON productie.id = membru_productie.id_productie
JOIN membru on membru.id = membru_productie.id_membru;

-- titlu productie, nume membru si rolul pe care acesta l-a avut in productia respectiva
-- pentru productiile de tip film
SELECT titlu, CONCAT(prenume, ' ', nume) membru, rol
FROM membru_productie JOIN (SELECT * FROM productie WHERE tip = 'film') film ON film.id = membru_productie.id_productie
JOIN membru on membru.id = membru_productie.id_membru;

-- titlu productie, nume membru cu rolul de creator
-- pentru productiile de tip serial
SELECT titlu, CONCAT(prenume, ' ', nume) membru, rol
FROM membru_productie JOIN (SELECT * FROM productie WHERE tip = 'serial') serial ON serial.id = membru_productie.id_productie
JOIN (SELECT * FROM membru WHERE rol = 'creator') creator on creator.id = membru_productie.id_membru;

-- rating, comentariu review, titlul productiei si numele utilizatorului care a lasat review-ul
SELECT rating, comentariu, titlu, nume utilizator
FROM review JOIN productie ON review. id_productie = productie.id
JOIN utilizator ON review.id_utilizator = utilizator.id;

-- media rating-ului pentru o productie, titlu productie
-- cu un numar minim de review-uri egal cu 2
SELECT AVG(rating) rating_film, titlu, COUNT(*) numar_reviewuri
FROM review JOIN productie ON review.id_productie = productie.id
JOIN utilizator ON review.id_utilizator = utilizator.id
GROUP BY titlu
HAVING numar_reviewuri >= 2;

-- procedura care primeste id-ul unui actor 
-- si afiseaza numele complet al acestuia, data nasterii si biografia

DELIMITER //
CREATE PROCEDURE detalii_actor(IN id INT)
BEGIN
	DECLARE nume_complet VARCHAR(100);
    DECLARE data_nasterii DATE;
    DECLARE biografie_scurta TEXT;
    
	SELECT CONCAT(prenume, ' ', nume), actor.data_nasterii, biografie
    INTO nume_complet, data_nasterii, biografie_scurta
    FROM actor
    WHERE actor.id = id;
    
    SELECT nume_complet, data_nasterii, biografie_scurta;
END;
//
DELIMITER ;

CALL detalii_actor(1);

-- procedura care primeste ca parametru de intrare id-ul unei productii
-- salveaza in parametrii de iesire titlu, data_aparitie si actorii din productia respectiva

DELIMITER //
CREATE PROCEDURE actori_productie(
		IN id INT, 
        OUT titlu_productie VARCHAR(50), 
        OUT data_aparitie DATE, 
        OUT cast VARCHAR(300))
BEGIN
	SELECT titlu, productie.data_aparitie, GROUP_CONCAT(CONCAT(prenume, ' ', nume))
    INTO titlu_productie, data_aparitie, cast
	FROM productie JOIN productie_actor ON productie.id = productie_actor.id_productie
	JOIN actor ON productie_actor.id_actor = actor.id
    WHERE productie.id = id
	GROUP BY titlu;
    
END;
//
DELIMITER ;

CALL actori_productie(8, @titlu, @data_lansare, @cast);
SELECT @titlu, @data_lansare, @cast;

CALL actori_productie(5, @titlu, @data_lansare, @cast);
SELECT @titlu, @data_lansare, @cast;

-- procedura care primeste ca parametru de intrare id-ul utilizatorului
-- afiseaza rating, comentariu si titlul productiei

DELIMITER //
CREATE PROCEDURE review_productie_dupa_user(IN id INT)
BEGIN
	SELECT rating, comentariu, titlu
	FROM utilizator JOIN review ON utilizator.id = review.id_utilizator
	JOIN productie ON productie.id = review.id_productie
    WHERE utilizator.id = id;
END;
//
DELIMITER ;

CALL review_productie_dupa_user(5);

-- functie care returneaza numele utilizatorului ptr un review

DELIMITER //
CREATE FUNCTION user_review(id INT) RETURNS VARCHAR(100)
BEGIN
	DECLARE nume_user VARCHAR(100);
    
	SELECT nume
    INTO nume_user
	FROM utilizator JOIN review ON utilizator.id = review.id_utilizator
	WHERE review.id = id;
    
    RETURN nume_user;
END;
//
DELIMITER ;

SELECT user_review(9);

-- functie care returneaza o lista cu scenaristii unei productii 

DELIMITER //
CREATE FUNCTION scenaristi_dupa_id_productie(id INT) RETURNS VARCHAR(200)
BEGIN
	DECLARE lista_scenaristi VARCHAR(200);
    
	SELECT DISTINCT GROUP_CONCAT(CONCAT(prenume, ' ', nume))
    INTO lista_scenaristi
	FROM membru JOIN membru_productie ON membru.id = membru_productie.id_membru
	JOIN productie ON productie.id = membru_productie.id_productie
	WHERE rol LIKE 'scenarist' AND productie.id = id
	GROUP BY rol;
    
    RETURN lista_scenaristi;
END;
//
DELIMITER ;

SELECT scenaristi_dupa_id_productie(5);
SELECT scenaristi_dupa_id_productie(1);

-- functie care returneaza o lista cu productiile unui actor

DELIMITER //
CREATE FUNCTION productii_actor(id INT) RETURNS VARCHAR(300)
BEGIN
	DECLARE lista_productii VARCHAR(300);
    
	SELECT GROUP_CONCAT(titlu)
    INTO lista_productii
    FROM actor JOIN productie_actor ON actor.id = productie_actor.id_actor
    JOIN productie ON productie.id = productie_actor.id_productie
    WHERE actor.id = id
    GROUP BY actor.id;
    
    RETURN lista_productii;
END;
//
DELIMITER ;

SELECT productii_actor(5);