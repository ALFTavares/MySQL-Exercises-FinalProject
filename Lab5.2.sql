CREATE USER 'alberto'@'%'			IDENTIFIED BY 'poiuyt';
CREATE USER 'alberto'@'localhost'	IDENTIFIED BY 'poiuyt';

CREATE USER 'armando'@'localhost'	IDENTIFIED BY 'qwert';
CREATE USER 'armando'@'ninja.org'	IDENTIFIED BY 'qwert';

GRANT SELECT, INSERT, UPDATE, DELETE
	ON Estudantes.*
	TO 'armando'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE
	ON Estudantes.*
	TO 'armando'@'ninja.org';

GRANT ALL PRIVILEGES
	ON Estudantes.*
	TO 'alberto'@'%'
	WITH GRANT OPTION;

CREATE USER ''@'localhost'			IDENTIFIED BY '1234';