DROP DATABASE IF EXISTS libreria; --Condicionar sentencias
CREATE TABLE IF NOT EXISTS libreria;
USE libreria;
CREATE TABLE IF NOT EXISTS autor(
  autor_id INT,
  nombre VARCHAR(25),
  apellido VARCHAR(25),
  genero CHAR(1),
  fecha_nacimiento DATE,
  pais_origen VARCHAR(15)
);
-- SHOW TABLES;
-- SELECT DATABSE();
-- DROP TABLE autor;
-- SHOW COLUMNS FROM autor;
-- DESC autor; abrebiatura de show columns FROM
-- CREATE TABLE usuario LIKE autor; crear tablas apartir de otras
-- INSERTAR REGISTROS
 INSERT INTO autor(autor_id, nombre, apellido, genero, fecha_nacimiento, pais_origen)
 VALUES(1, 'Test autor', 'Test autor','M', '2020-07-23', 'México');

 /*
 Para ejecurar archivos .SQL
1° Forma
 mysql -u root -p < CursoDB/sentencias.sql
2° Forma
 SOURCE CursoDB/sentencias.sql;
 */

-- CONSULTAS RAPIDAS
-- mysql -u root -p libreria -e 'SELECT * FROM autor;'



/*
  Funciones sobre strings
*/
SELECT CONCATC(nombre,' ',apellido) AS nombre_completo FROM autor; -- Concatenar
SELECT LENGTH("Hola mundo"); -- muestra la cantidad de caracteres
SELECT UPER(nombre), LOWER(nombre) FROM autor; -- UPER mayusculas  LOWER minusculas
SELECT TRIM("  con espacios al inicio y al final  "); -- Los espacios son removidos
SELECT LEFT("Esta es una cadena de caracteres", 5) AS subsstring_izquierdo, RIGHT("Esta es una cadena", 10) AS subsytring_derecho; -- Retorna los primeros 5 caracteres
SELECT * FROM libro WHERE LEFT(titulo, 12) = "Harry Poter";
/*
  Funciones sobre numeros
*/
SELECT RAND(); -- Numero randon
SELECT RAND(RAND() * 100); --
SELECT TRUNCATE(1.12133455, 3); -- Me permite dejar solo 3 decimales o segun lo desee
SELECT POWER(2, 16); -- ELEva un numero a una potencia
