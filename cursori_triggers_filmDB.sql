-- rutine cu cursori

-- o procedura care primeste genul unei productii
-- afiseaza o lista cu titlul productiilor

DELIMITER //
CREATE OR REPLACE PROCEDURE productii_dupa_gen(IN gen VARCHAR(50))
BEGIN
	DECLARE titlu_productie VARCHAR(50);
	DECLARE lista_productii VARCHAR(500);
    DECLARE ok TINYINT(1) DEFAULT 1;
    DECLARE cursor_productii CURSOR FOR
		SELECT titlu
        FROM productie
        WHERE productie.gen = gen;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET ok = 0;
    OPEN cursor_productii;
    productii: LOOP
		FETCH cursor_productii INTO titlu_productie;
        IF ok = 0 THEN
			LEAVE productii;
		ELSE 
			SET lista_productii = CONCAT_WS('-', lista_productii, titlu_productie);
		END if;
    END LOOP productii;
    CLOSE cursor_productii;
    SELECT lista_productii;
END;
//
DELIMITER ;

CALL productii_dupa_gen('drama');

-- tabela serial

CREATE TABLE serial(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    titlu VARCHAR(50),
    data_aparitie DATE,
    gen VARCHAR(50)
);

-- procedura care populeaza tabela serial

DELIMITER //
CREATE OR REPLACE PROCEDURE populare_serial()
BEGIN
	DECLARE titlu_serial VARCHAR(50);
    DECLARE data_aparitie DATE;
    DECLARE gen VARCHAR(50);
    DECLARE ok TINYINT(1) DEFAULT 1;
    DECLARE cursor_seriale CURSOR FOR
		SELECT productie.titlu, productie.data_aparitie, productie.gen
        FROM productie
        WHERE tip = 'serial';
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET ok = 0;
    OPEN cursor_seriale;
    TRUNCATE serial;
    seriale: LOOP
		FETCH cursor_seriale INTO titlu_serial, data_aparitie, gen;
        IF ok = 0 THEN 
			LEAVE seriale;
		ELSE
			INSERT INTO serial VALUES(NULL, titlu_serial, data_aparitie, gen);
        END IF;
    END LOOP seriale;
    CLOSE cursor_seriale;
    SELECT * FROM serial;

END;
//
DELIMITER ;
CALL populare_serial();

-- functie care primeste ca parametru numele unui membru
-- returneaza o lista cu productiile la care acesta a lucrat

DELIMITER //
CREATE FUNCTION productii_dupa_membru(nume VARCHAR(70)) RETURNS VARCHAR(200)
BEGIN
	DECLARE titlu_productie VARCHAR(50);
    DECLARE lista_productii VARCHAR(200);
    DECLARE ok TINYINT(1) DEFAULT 1;
    DECLARE cursor_membru CURSOR FOR 
		SELECT titlu
        FROM membru JOIN membru_productie ON membru.id = membru_productie.id_membru
        JOIN productie ON membru_productie.id_productie = productie.id
        WHERE CONCAT(membru.prenume, ' ', membru.nume) = nume;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET ok = 0;
    OPEN cursor_membru;
    productii: LOOP
		FETCH cursor_membru INTO titlu_productie;
        IF ok = 0 THEN
			LEAVE productii;
		ELSE
			SET lista_productii = CONCAT_WS('-', lista_productii, titlu_productie);
        END IF;
    END LOOP productii;
	CLOSE cursor_membru;
    RETURN lista_productii;

END;
//
DELIMITER ;

SELECT productii_dupa_membru('Stephen Edwin King');
SELECT productii_dupa_membru('Christopher Edward Nolan');

-- triggers

-- inainte de a adauga un actor se fac prelucrarile:
-- data de nastere a actorului e mai mare decat current date -> mesaj de eroare
-- nume, prenume scrise capitalize

DELIMITER //
CREATE TRIGGER bi_actor BEFORE INSERT
ON actor FOR EACH ROW
BEGIN
	SET NEW.nume = CONCAT(UCASE(LEFT(NEW.nume, 1)), LCASE(SUBSTRING(NEW.nume, 2)));
    SET NEW.prenume = CONCAT(UCASE(LEFT(NEW.prenume,1)), LCASE(SUBSTRING(NEW.prenume,2)));
    IF NEW.data_nasterii > CURDATE() THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data nasterii este mai mare decat data curenta';
    END IF;
END;
//
DELIMITER ;

INSERT INTO actor VALUES (NULL, 'lawrenCE', 'JeNNifer', '1990-08-15', 'Louisville', 1.75, NULL);
-- DROP TRIGGER bi_actor;  
INSERT INTO actor VALUES(NULL, 'anthony', 'LITTLE', '2022-02-02',NULL,NULL,NULL);

-- actualizarea parolei unui utilizator
-- daca e aceeasi parola se va trimite un mesaj de eroare
-- lungimea parolei minim 10 caractere


DELIMITER //
CREATE OR REPLACE TRIGGER bu_utilizator BEFORE UPDATE
ON utilizator FOR EACH ROW
BEGIN
	IF NEW.pass = OLD.pass THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Parola a fost deja asociata acestui cont.Va rugam introduceti o noua parola';
    END IF;
    IF CHAR_LENGTH(NEW.pass) < 10 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Parola prea scurta. Noua parola trebuie sa contina minim 10 caractere';
    END IF;
END;
//
DELIMITER ;

UPDATE utilizator SET pass = 'PassALEX' WHERE id = 5;
UPDATE utilizator SET pass = 'PassA' WHERE id = 5;

-- pentru un membru decedat se va actualiza tabela membru
-- se adauga o noua coloana data_decesului in care se salveaza data 
-- in tabela in_memoriam se va salva nume, prenume si data decesului

CREATE TABLE in_memoriam(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    data_decesului DATE NOT NULL
);
ALTER TABLE membru
ADD COLUMN data_decesului DATE;

DELIMITER //
CREATE OR REPLACE TRIGGER au_membru AFTER UPDATE
ON membru FOR EACH ROW
BEGIN
	INSERT INTO in_memoriam VALUES(NULL, OLD.nume, OLD.prenume, NEW.data_decesului);
END;
//
DELIMITER ;

UPDATE membru SET data_decesului = '1999-03-07' WHERE id = 25;
SELECT * FROM in_memoriam;

