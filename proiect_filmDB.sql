-- crearea bazei de date
CREATE DATABASE filmDB;
USE filmDB;
-- DROP DATABASE filmDB;

-- creare tabele
CREATE TABLE utilizator(
	id INT(6) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nume VARCHAR(100) NOT NULL,
    email VARCHAR(50) NOT NULL,
    pass VARCHAR(20) NOT NULL
);

CREATE TABLE actor(
	id INT(6) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nume VARCHAR(20) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    data_nasterii DATE,
    locul_nasterii VARCHAR(30),
    inaltime FLOAT(3, 2),
    biografie TEXT
);

CREATE TABLE productie(
	id INT(8) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    titlu VARCHAR(50) NOT NULL,
    data_aparitie DATE NOT NULL,
    tip ENUM('film', 'serial') NOT NULL,
    gen VARCHAR(50) NOT NULL,
    storyline TEXT,
    sezoane TINYINT
);

CREATE TABLE membru(
	id INT(6) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nume VARCHAR(20) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    rol ENUM('scenarist','director','creator'),
    data_nasterii DATE,
    biografie TEXT
);

CREATE TABLE review(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    rating TINYINT NOT NULL,
    titlu_review VARCHAR(50),
    descriere TEXT
);

CREATE TABLE productie_actor(
	rol_principal BOOLEAN,
    id_productie INT(8) NOT NULL,
    id_actor INT(6) NOT NULL,
    FOREIGN KEY (id_productie) REFERENCES productie(id),
    FOREIGN KEY (id_actor) REFERENCES actor(id)
);

CREATE TABLE membru_productie(
	id_productie INT(8) NOT NULL,
    id_membru INT(6) NOT NULL,
    FOREIGN KEY (id_productie) REFERENCES productie(id),
    FOREIGN KEY (id_membru) REFERENCES membru(id)
);

-- modificarea structurii tabelelor
ALTER TABLE review
ADD COLUMN id_utilizator INT(6) NOT NULL;

ALTER TABLE review
ADD CONSTRAINT user_fk
FOREIGN KEY (id_utilizator) REFERENCES utilizator(id);

ALTER TABLE review
ADD COLUMN id_productie INT(8) NOT NULL;

ALTER TABLE review
ADD CONSTRAINT productie_fk
FOREIGN KEY (id_productie) REFERENCES productie(id);

ALTER TABLE review 
MODIFY rating TINYINT(1) NOT NULL;

ALTER TABLE review
CHANGE descriere comentariu TEXT;

ALTER TABLE membru AUTO_INCREMENT = 10;

-- adaugarea inregistrarilor
INSERT INTO membru 
VALUES
(NULL, 'Franck', 'Darabont', 'director', '1959-01-28', 'Frank Darabont este un regizor și producător maghiaro-american care a fost nominalizat la 
trei premii Oscar și la un Glob de Aur'),
(NULL, 'Noxon', 'Martha Mills', 'director','1964-08-25', 'Marti Noxon este o regizoare și producătoare americană de televiziune și film. 
Este cunoscută mai ales pentru munca sa ca scenarist și producător executiv în serialul de dramă supranaturală Buffy the Vampire Slayer.' ),
(NULL, 'Spielberg', 'Steven Allan' ,'director', '1946-12-18', 'Steven Spielberg este un regizor, producător și scenarist american. 
Spielberg este de trei ori câștigător al premiului Oscar și este producătorul de film cu cel mai bun succes financiar al tuturor timpurilor; 
filmele sale având încasări de aproape 8 miliarde de dolari la nivel mondial.'),
(NULL, 'Gilligan', 'George Vincent','creator' ,'1967-02-10', 'Vince Gilligan este un producător și regizor american cunoscut pentru munca sa de televiziune,
 în special ca creator și regizor al filmului Breaking Bad și al spin-off-ului său, Better Call Saul. A fost scriitor și producător pentru The X-Files'),
(NULL, 'King', 'Stephen Edwin', 'scenarist','1947-09-21', 'Stephen King este un autor american celebru prin romanele sale horror, acestea fiind ecranizate 
aproape în totalitate pe micul sau marele ecran' ),
(NULL, 'Flynn', 'Gillian Schieber', 'scenarist','1971-02-24', 'Gillian Schieber Flynn este un scriitor american. Flynn a publicat trei romane, Sharp Objects, 
Dark Places și Gone Girl, toate trei adaptate pentru film sau televiziune' ),
(NULL, 'Nathanson', 'Jeffrey', 'scenarist','1965-10-12', 'Jeff Nathanson este scenarist și regizor american nascut in Los Angeles cunoscut pentru Rush Hour, 
Catch Me If You Can si The Terminal' ),
(NULL, 'Redding', 'Stan','scenarist', NULL, NULL),
(NULL, 'Abagnale', 'Frank William', 'scenarist' ,'1948-04-27', NULL),
(NULL, 'Walley-Beckett', 'Moira','scenarist', NULL, NULL),
(NULL, 'Gould', 'Peter','scenarist', NULL, NULL),
(NULL, 'Mastras', 'George','scenarist', NULL, NULL),
(NULL, 'Levitan', 'Steven', 'creator', 	'1962-04-06', NULL ),
(NULL, 'Lloyd', 'Christopher', 'creator','1960-06-18', NULL),
(NULL, 'Ko', 'Elaine','scenarist', NULL, NULL),
(NULL, 'Kubrick', 'Stanley', 'director', '1928-07-26', 'Stanley Kubricka fost un producător de film american, câștigător al Premiului Oscar. 
Kubrick a fost renumit prin grija cu care își alegea subiectele, metoda lentă de a lucra, varietatea de genuri pe care le-a abordat și perfecționismul său.'),
(NULL, 'Johnson', 'Diane', 'scenarist', '1934-04-28', NULL),
(NULL, 'Nolan', 'Christopher Edward', 'director', '1970-07-30', 'Christopher Nolan este cel mai bine cunoscut pentru filmele sale cerebrale, adesea neliniare. 
Pe parcursul a celor 15 ani de filmare, Nolan a trecut de la filme independente cu buget redus, la unele dintre cele mai mari blockbuster realizate vreodată.'),
(NULL, 'Knight', 'Steven', 'creator', '1959-08-05', 'Steven Knight este un scenarist și regizor de film britanic cunoscut pentru Peaky Blinder.
Knight este unul dintre cei trei creatori ai Who Wants to Be a Millionaire?, o emisiune care a fost refăcută și difuzată în aproximativ 160 de țări din întreaga lume.');

INSERT INTO actor
VALUES
(NULL, 'Freeman','Morgan', '1937-06-01', 'Memphis', 1.88, 'Morgan Freeman este un actor american, regizor de film și narator, câștigător al Premiului Oscar. 
A devenit cunoscut în anii 1990, după ce a avut roluri într-o serie de filme de succes produse la Hollywood.'),
(NULL, 'Hanks', 'Thomas Jeffrey', '1956-07-09', 'Concord', 1.83, 'Tom Hanks este un actor, regizor și producător de film american, 
câștigător a două premii Oscar pentru cel mai bun actor. 
El și-a început cariera în comedii înainte de a obține succese notabile ca actor dramatic.'),
(NULL, 'Clarkson', 'Patricia','1959-12-29', 'New Orleans', 1.65, 'Patricia Clarkson este o actriță americană. 
A jucat în numeroase roluri principale și secundare într-o varietate de filme, variind de la filme independente la producții majore de studiouri de film.' ),
(NULL, 'Adams', 'Amy Lou', '1974-08-20', 'Vicenza', 1.63, 'Amy Lou Adams este o actriță și cântăreață americană. 
Cunoscută pentru versatilitatea sa de a interpreta roluri comice și dramatice, a fost de trei ori pe listele anuale ale celor mai bine plătite actrițe din lume'),
(NULL, 'DiCaprio', 'Leonardo Wilhelm', '1974-11-11', 'Hollywood', 1.83, 'Puțini actori din lume au avut o carieră la fel de diversă precum cea a lui Leonardo DiCaprio. 
DiCaprio a trecut de la începuturi relativ umile, ca membru al distribuției secundare al sitcomului Growing Pains, 
la un adolescent care în anii 1990 a obtinut rolul principal în filme precum Romeo + Juliet și Titanic, 
pentru a deveni apoi actorul principal în filme de succes de la Hollywood, realizate de regizori de renume internațional precum Martin Scorsese și Christopher Nolan.'),
(NULL, 'Cranston', 'Bryan Lee', '1956-03-07', 'Hollywood', 1.79, 'Bryan Cranston este un actor american. Este cunoscut pentru rolul lui Walter White pe care 
l-a jucat în serialul de dramă Breaking Bad, rolul lui Hal în serialul de comedie Malcolm in the Middle și al lui Tim Whatley în serialul Seinfeld'),
(NULL, 'Sturtevant', 'Aaron Paul', '1979-08-27', 'Emmett', 1.72, 'Aaron Paul, este un actor și producător american. El este cel mai bine cunoscut pentru 
interpretarea lui Jesse Pinkman în serialul AMC Breaking Bad. Personajul trebuia să dureze doar un sezon, dar creatorul seriei s-a răzgândit, datorita chimiei 
lui Aaron cu Bryan Cranston. A câștigat trei premii Emmy pentru pentru acest rol (in 2010, 2012 și 2014). ' ),
(NULL, 'O Neill', 'Edward Leonard ', '1946-04-12', 'Youngstown', 1.84, NULL),
(NULL, 'Vergara', 'Sofía Margarita', '1972-07-10','Barranquilla', 1.7, NULL),
(NULL, 'Bowen', 'Julie', '1970-03-03', 'Baltimore', 1.68, NULL),
(NULL, 'Nicholson', 'John Joseph', '1937-04-22', 'Neptune', 1.77, 'Jack Nicholson a câștigat de trei ori premiul Oscar și a fost nominalizat de douăsprezece ori. 
Nicholson este, de asemenea, unul dintre cei doi actori care au primit o nominalizare la Oscar în fiecare deceniu din anii 1960 până în anii 2000.'),
(NULL, 'Gordon-Levitt', 'Joseph Leonard', '1981-02-17', 'Los Angeles', 1.76, NULL),
(NULL, 'Murphy', 'Cillian', '1976-05-25', 'Douglas', 1.72, NULL ),
(NULL, 'Page', 'Elliot', '1987-02-21', 'Halifax', 1.55, NULL),
(NULL, 'Hardy','Edward Thomas', '1977-09-15','Hammersmith', 1.75, NULL),
(NULL, 'Anderson', 'Paul', NULL, NULL, 1.77, 'Paul Anderson este un actor englez cunoscut pentru rolul lui Arthur Shelby în serialul BBC Peaky Blinders.
De asemenea, a apărut în multe filme importante, inclusiv Legend (2015) și The Revenant (2015).'),
(NULL, 'McCrory', 'Helen Elizabeth', '1968-08-17', 'Paddington', 1.63, NULL);

INSERT INTO productie
VALUES
(NULL, 'The Shawshank Redemption', '1994-09-22','film', 'drama', 
'Andy Dufresne, un tânăr bancher, este condamnat la închisoare pe viață pentru uciderea soției și a amantului acesteia, deși Andy declară că este nevinovat. 
În închisoare, Andy il întâlnește pe Red, un bărbat de culoare închis de 20 de ani. 
Andy va pune la cale un ingenios plan de evadare, dar și de pedepsire a tiranicului director al închisorii', NULL ),
(NULL, 'The Green Mile', '1999-12-06', 'film','drama',
'Actiunea se petrece în anul 1935, în sectorul condamnatilor la moarte al unei închisori din sudul Statelor Unite si 
dezvoltã povestea uimitoare a unui gardian despre relatia neobisnuitã ce se înfiripã între acesta si unul dintre condamnati, 
posesor al unui har magic, pe cât de misterios, pe atât de miraculos', NULL),
(NULL, 'Sharp Objects', '2018-07-08', 'serial', 'crima', 'Un reporter se confruntă cu demonii psihologici din trecutul ei 
când se întoarce în orașul natal pentru a acoperi o crimă violentă.', 1 ),
(NULL, 'Catch Me If You Can', '2002-12-25', 'film','politist', 'Frank W. Abagnale este un falsificator priceput care a lucrat ca doctor, avocat şi 
copilot – toate înainte de a împlini 21 de ani. Agentul FBI Carl devine obsedat să-l urmărească pe escroc, dar Frank se află întotdeauna cu un pas înaintea sa.', NULL ),
(NULL, 'Breaking Bad', '2008-01-20', 'serial', 'drama', 'Un profesor de chimie de liceu diagnosticat cu cancer pulmonar inoperabil 
se orientează către fabricarea și vânzarea de metamfetamină pentru a asigura viitorul familiei sale.', 5),
(NULL, 'Modern Family', '2009-09-23','serial', 'comedie', 'Trei familii diferite, dar înrudite, se confruntă cu încercări și necazuri în propriile lor 
moduri unice de comedie.', 11 ),
(NULL, 'The Shining', '1980-05-23', 'film', 'horror', 'O familie se îndreaptă spre un hotel izolat pentru iarnă, unde o prezență sinistră îl influențează 
pe tată la violență, în timp ce fiul său are presimțiri oribile atât din trecut, cât și din viitor.', NULL),
(NULL, 'Inception', '2010-07-30', 'film', 'SF', 'Unui hoț care fură secrete corporative prin folosirea tehnologiei de partajare a viselor i se încredințează 
sarcina de a planta o idee în mintea unui CEO, dar trecutul său tragic poate condamna proiectul și echipa sa la dezastru.', NULL),
(NULL, 'Bridesmaids', '2011-05-13', 'film', 'comedie', 'Kristen Wiig este Annie, o domnișoară de onoare a cărei viață o ia razna din momentul în care, 
împreună cu o gașcă de domnișoare de onoare una mai trăznită decât alta, trebuie s-o conducă la altar pe cea mai bună prietenă a ei, Lillian.', NULL),
(NULL, 'Peaky Blinders', '2013-09-12', 'serial', 'crima', 'O epopee de familie de gangsteri plasată în Anglia anilor 1900, 
centrată pe o bandă care coase lame de ras în vârfurile șepcilor și pe șeful lor fioros Tommy Shelby.', 6);

INSERT INTO utilizator
VALUES
(NULL,'Erica Abeel', 'erica.abeel@yahoo.com', 'EricaAbeel1!' ),
(NULL, 'Robert ALexe', 'robert_alexe@hotmail.com', 'Primavara123!'),
(NULL, 'Josefine Braham', 'j.braham@hotmail.com', 'MyPass123!'),
(NULL, 'Raphael John', 'raphaeljohn@gmail.com', 'MySecretPass1!'),
(NULL, 'Alex Dumitrescu', 'a_dumitrescu@gmail.ro', 'PassAlex'),
(NULL, 'Maria Ene', 'eusuntmaria@hotmail.com', 'Parola123'),
(NULL, 'Michael Haynes', 'michael_h@yahoo.com','Sofia98'),
(NULL, 'Brian Tang', 'brian.tang@hotmail.fr', 'MyPassword123'),
(NULL, 'James Taylor', 'jamest@gmail.com', 'IamJames1!'),
(NULL, 'Kate Thompson', 'kate_thompson@yahoo.com', 'KatePass123');

INSERT INTO review
VALUES
(NULL, 5, NULL, 'Un scenariu incredibil, regie minunată și performanțe fenomenale ale lui Freeman și Robbins. Cinematograful nu poate fi mai bun decât acest film', 10, 1),
(NULL, 1, 'Cel mai prost film', 'Shawshank Redemption abandonează continuu plauzibilitatea pentru a celebra triumful speranței asupra disperării, al decenței asupra cruzimii, 
al dreptății asupra nedreptății.', 5, 1),
(NULL, 5, NULL, 'O poveste genială care nu va fi uitată niciodată de toți cei care au văzut-o.', 5, 5 ),
(NULL, 5, NULL, 'O comedie relaxanta atat de necesara in zilele grele. Perfecta pentru vizionarea in familie', 2, 6),
(NULL, 1, NULL, 'Pur și simplu nu mi-a vorbit. Am crezut că este mult prea lung și puțin prea lent ca ritm.', 8, 7),
(NULL, 4, NULL, 'Mi-a plăcut cartea mai mult decât filmul. Stanley Kubrick a oferit viziunile lui multor filme pe care le-a făcut atât de perfecte.', 7, 8),
(NULL, 3, NULL, NULL, 9, 2),
(NULL, 2, NULL, NULL, 4, 9),
(NULL, 5, NULL, 'Unul dintre cele mai bune miniseriale pe care le-am văzut vreodată. Intriga este foarte bună și interesantă, iar actorii sunt grozavi.',1 ,3),
(NULL, 4, NULL, NULL, 3, 10 );

INSERT INTO membru_productie
VALUES
(1, 10),(1, 14),(2, 10),(2, 14),(3, 11),(3, 15),(4, 12),(4, 16),(4, 17),(4, 18),(5, 13),(5, 20),
(5, 19),(5, 21),(6, 22),(6, 23),(6, 24),(7, 25),(7, 26),(8, 27),(10, 28);

INSERT INTO productie_actor
VALUES
(true, 1, 1), (true, 2, 2), (NULL, 2, 3), (NULL, 3, 3), (true, 3, 4), (true, 4, 5), (NULL, 4, 4), (true, 4, 2), (true, 5, 6),
(true, 5, 7), (true, 6, 8), (true, 6, 9), (true, 6, 10), (true, 7, 11), (NULL, 8, 12), (true, 8, 5), (NULL, 8, 13), (NULL, 8, 14),
(NULL, 8, 15), (NULL, 10, 16), (NULL, 10, 17), (NULL, 10, 15), (true, 10, 13);


-- actualizarea date
UPDATE actor 
SET data_nasterii = '1978-02-12', locul_nasterii = 'Londra'
WHERE id = 16;

UPDATE utilizator
SET pass = 'KateyKate1!'
WHERE nume = 'Kate Thompson';

SET SQL_SAFE_UPDATES = 0;

UPDATE review
SET titlu_review = 'Un miniserial de neratat'
WHERE id = 9;

-- stergere date
DELETE FROM membru_productie
WHERE id_productie = 4;

DELETE FROM review
WHERE rating = 3;

DELETE FROM productie_actor
WHERE id_actor = 17;

INSERT INTO productie
VALUES
(NULL, 'The Social Network', '2010-10-01', 'film', 'biografic', NULL, NULL),
(NULL, 'Tangled', '2010-11-24', 'film', 'animatie', NULL, NULL);








