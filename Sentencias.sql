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
/*
  FUNCIONES SoBRE FECHAS
*/
SELECT NOW();
SELECT @now = NOW();
SELECT SECOND(@now), MINUTE(@now), HOUR(@now), MONTH(@now), YEAR(@now);
SELECT DATEOFWEEK(@now), DAYOFMONTH(@now), DATEOFYEAR(@@now);
SELECT DATE(@now);
SELECT CURDATE();
SELECT @now + INTERVAL 30 DAY;

/*
Funciones sobre condiciones
*/
SELECT IF(10>9, "El numero si es mayor", "El numero no es mayor");
SELECT IF(paginas = 0, "El libro no posee paginas", paginas) FROM libro;
SELECT IFNULL(seudonimo, "El autor no cuenta con seudonimo") FROM autor;
/*
  CREAR FUNCIONES
  */
  DELIMITER //   -- para terminar la sentencia se usara doble slash
  CREATE FUNCTION agregar_dias(fecha DATE, dias INT)
  RETURNS DATE
  BEGIN
  RETURN fecha + INTERVAL dias DAY;
  END//
  DELIMITER ;
/*
Listar Funciones
*/
SELECT name FROM mysql.proc WHERE db = database() AND type = 'FUNCTION';
DROP FUNCTION agregar_dias;
/*
Ejecutar sentencias dentro de FUNCIONES
*/
DELIMITER //
CREATE FUNCTION obtener_paginas()
RETURNS INT
BEGIN
  SET @paginas = (SELECT (ROUND(RAND() * 100) * 4));
  RETURN @paginas;
END //

DELIMITER ;
UPDATE libro SET  paginas = obtener_paginas();
/*
Mostar contenido de tabla en forma de cartas
*/
SELECT * FROM libro\G;
/*
Sentencias avanzadas
*/
--  busqueda mediante strings
SELECT * FROM libro WHERE titulo LIKE 'Harry Potter%'\G;
SELECT * FROM libro WHERE titulo LIKE '%anillo';
SELECT * FROM libro WHERE titulo LIKE '%la%';
SELECT * FROM libro WHERE titulo LIKE '_a%';
SELECT * FROM libro WHERE titulo LIKE '__b__';
SELECT * FROM libro WHERE titulo LIKE '_a__o%';

-- Expresiones regulares
SELECT titulo FROM libro WHERE titulo REGEXP '^[HL]' -- titulos que comiencen con  H o L

-- ORdenar REGISTROS
SELECT * FROM libro ORDER BY titulo AND id_libro ASC; -- ascendente
SELECT * FROM libro ORDER BY titulo DESC; -- Desendente

-- Limitar REGISTROS
SELECT titulo FROM libro LIMIT 10;
SELECT titulo FROM libro WHERE autor_id = 2 LIMIT 50;
SELECT libro_id, titulo FROM libro LIMIT 0, 5; -- limitar por partes comienza en la posicion 0 y me muestra 5

-- Funciones de agregacion: funciones que se ejecutan en un grupo de datos
COUNT(); -- Cuenta REGISTROS
SELECT COUNT(*) FROM autor; -- * indica que se cuenten todos los registros
SELECT COUNT(*) FROM autor WHERE seudonimo IS NOT NULL;
SELECT COUNT(seudonimo) autor; -- trabajar columnas siempre y cuando el registro tenga valor
-- Si es null no se tomara en Cuenta
DELIMITER //
CREATE FUNCTION obtener_ventas()
RETURNS INT
BEGIN
  SET @paginas = (SELECT (ROUND(RAND() *100) * 4));
  RETURN @paginas;
END//
DELIMITER ;

UPDATE libro SET ventas = obtener_ventas;

SUM() -- SUMA
SELECT SUM(ventas) FROM libro;
MAX() -- Maximo
SELECT MAX(ventas) FROM libro;
MIN() -- Minimo
SELECT MIN(ventas) FROM libro;
AVG() -- Promedio
SELECT AVG(ventas) FROM libro;

-- Agrupamiento
SELECT autor_id, SUM(ventas) FROM libro GROUP BY autor_id;
SELECT autor_id,SUM(ventas) AS total FROM libro GROUP BY autor_id ORDER BY DESC LIMIT 1;

-- Condiciones bajo Agrupamiento
SELECT autor_id, SUM(ventas) AS total FROM libro GROUP BY autor_id HAVING SUM(ventas) > 100;
-- HAVING clausula de soporte a la clausula WHERE nos permite hacer filtros sobre un grupo de datos


-- UNir resultados
CREATE TABLE usuario(
  usuario_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(30) NOT NULL,
  apellido VARCHAR(23),
  username VARCHAR(25) NOT NULL,
  email VARCHAR(50) NOT NULL,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
SELECT CONCAT(nombre, " ", apellido) AS nombre_completo FROM autor
UNION
SELECT CONCAT(nombre, " ", apellido) AS nombre_completo FROM usuario;

-- Subconsultas: consultas anidadas
SELECT AVG(ventas) FROM libro;
SELECT
  autor_id
FROM libro
GROUP BY autor_id
HAVING SUM(ventas) > 328.1818 ;

SELECT CONCAT(nombre, " ", apellido)
FROM autor_id
WHERE autor_id IN(
SELECT
  autor_id
FROM libro
GROUP BY autor_id
HAVING SUM(ventas) > (SELECT AVG(ventas) FROM libro;));
 -- PRimero se ejecuta la del promedio, despues la
-- del siguiente nivel (del nivel mas bajo al mas alto)

-- VALIDAR registros
SELECT IF(
  EXISTS(SELECT libro_id FROM libro WHERE titulo = 'EL hobbit'),
  "Disponible",
  "No disponible"
) AS message;


/*
  JOIN
*/
-- Inner join
SELECT
  libro.titulo,
  CONCAT(autor.nombre, " ", autor.apellido) AS nombre_autor,
  libro.fecha_crecion
FROM libro
INNER JOIN autor ON libro.autor_id = autor.autor_id;

SELECT
  libro.titulo,
  CONCAT(autor.nombre, " ", autor.apellido) AS nombre_autor,
  libro.fecha_crecion
FROM libro
INNER JOIN autor ON libro.autor_id = autor.autor_id
AND autor.seudonimo IS NOT NULL;
-- sub clausula using
SELECT
  libro.titulo,
  CONCAT(autor.nombre, " ", autor.apellido) AS nombre_autor,
  libro.fecha_crecion
FROM libro
INNER JOIN autor USING(autor_id);

-- LEFT JOIN
CREATE TABLE libro_usuario(
  libro_id INT UNSIGNED NOT NULL,
  usuario_id INT UNSIGNED NOT NULL,
  FOREIGN KEY(libro_id) REFERENCES libro(libro_id),
  FOREIGN KEY(autor_id) REFERENCES autor(autor_id),
  fecha_crecion DATETIME DEFAULT CURRENT_TIMESTAMP
);
SELECT
  CONCAT(nombre, " ", apellido),
  libro_usuario.libro_id
FROM usuario
LEFT JOIN libro_usuario ON usuario.usuario_id = libro_usuario.usuario_id
WHERE libro_usuario.usuario_id IS NOT NULL;

-- RIGHT JOIN
SELECT
  CONCAT(nombre, " ", apellido),
  libro_usuairo.libro_id
FROM libro_usuario
LEFT JOIN usuario ON usuario.usuario_id = libro_usuario.usuario_id
WHERE libro_usuario.usuario_id IS NOT NULL;

-- Multiples Joins
SELECT DISTINCT
  CONCAT(usuario.nombre, " ", usuario.apellido) AS nombre_usuario
FROM usuario
INNER JOIN libro_usuario.usuario_id = libro.usuario_id
            AND DATE(libro.fecha_crecion) = CURDATE()
INNER JOIN libro ON libro_usuario.libro_id = libro.libro_id
INNER JOIN autor ON libro.autor_id = autor.autor_id
            AND autor.seudonimo IS NOT NULL;

-- Productos cartecianos
SELECT
  usuario.username, libro.titulo
FROM usuario
CROSS JOIN libro
ORDER BY username DESC;

INSERT INTO
  libro.usuario(libro_id, usuario_id)
SELECT
  libro_id, usuario_id
FROM usuario CROSS JOIN libro;

/*
Vistas
*/
-- CREAR Vistas
-- Debemos utilizar un estandar, en este caso vw al final de nuestra vista
CREATE VIEW prestamos_usuarios_vw AS
SELECT
  usuario.usuario_id,
  usuario.nombre,
  usuario.email,
  usuario.username,
  COUNT(usuario.usuario_id) AS total_prestamos
FROM usuario
INNER JOIN libro_usuario ON usuario.usuario_id = libro_usuario.usuario_id
GROUP BY usuario.usuario_id;
-- borrar Vistas
DROP VIEW prestamos_usuarios_vw;

-- Editar Vistas
CREATE OR REPLACE VIEW prestamos_usuarios_vw AS
SELECT
  usuario.usuario_id,
  usuario.nombre,
  usuario.email,
  usuario.username,
  COUNT(usuario.usuario_id) AS total_prestamos
FROM usuario
INNER JOIN libro_usuario ON usuario.usuario_id = libro_usuario.usuario_id
            AND libro_usuario.fecha_creacion >= CURDATE() - INTERVAL 5 DAY
GROUP BY usuario.usuario_id;

 /*
  Procedimientos almacenados
*/
-- Crear Procedimientos
DELIMITER //
CREATE PROCEDURE prestamo(usuario_id INT, libro_id INT)
BEGIN
  INSERT INTO libro_usuario(usuario_id, libro_id) VALUES(usuario_id, libro_id);
  UPDATE libro SET stock = stock - 1 WHERE linbro.libro_id = libro_id;
END //
DELIMITER ;

SELECT name FROM mysql.proc WHERE db = database() AND type = 'PROCEDURE';

CALL prestamo(3, 20); -- llamar al procedimiento

-- Eliminar procedimientos
DROP PROCEDURE prestamo();

-- obtenr valores
DELIMITER //
CREATE PROCEDURE prestamo(usuario_id INT, libro_id INT, OUT cantidad INT)
BEGIN
  INSERT INTO libro_usuario(usuario_id, libro_id) VALUES(usuario_id, libro_id);
  UPDATE libro SET stock = stock - 1 WHERE linbro.libro_id = libro_id;

  SET cantidad = (SELECT stock FROM libro where libro.libro_id = libro_id);
END //
DELIMITER ;

-- Condiciones
DELIMITER //
CREATE PROCEDURE prestamo(usuario_id INT, libro_id INT, OUT cantidad INT)
BEGIN
  SET cantidad = (SELECT stock FROM libro where libro.libro_id = libro_id);
  IF cantidad > 0 THEN
    INSERT INTO libro_usuario(usuario_id, libro_id) VALUES(usuario_id, libro_id);
    UPDATE libro SET stock = stock - 1 WHERE linbro.libro_id = libro_id;
    SET cantidad = cantidad - 1;
  ELSE
    SELECT "No es posible realizar el prestamo" AS mensaje_error;
  END IF;
END //
DELIMITER ;
 -- se puede colocar n cantidad de ELSEIF
SET @cantidad = -1;
CALL prestamoi(4, 20, @cantidad);
SELECT @cantidad;

-- Casos
CREATE PROCEDURE tipo_lector(usuario_id INT)
BEGIN
  SET @cantidad = (SELECT COUNT(*) FROM libro_usuario
                    WHERE libro_usuario.usuario_id = usuario_id);
  CASE
    WHEN @cantidad > 20 THEN
      SELECT "Fanatico" AS message;
    WHEN @cantidad > 10 AND @cantidad < 20 THEN
      SELECT "Aficionado" AS message;
    WHEN @cantidad > 5 AND @cantidad < 10 THEN
      SELECT "Promedio" AS message;
    ELSE
      SELECT "nuevo" AS message;
  END CASE;
END//

-- Ciclos
-- WHILE
CREATE PROCEDURE libro_azar()
BEGIN
  SET @Iteracion = 0;

  WHILE @iteracion < 5 DO
    SELECT libro_id, titulo FROM libro ORDER BY RAND() LIMIT 1;
    SET @Iteracion = @iteracion + 1;
  END WHILE;
END //
-- REPEAT
CREATE PROCEDURE libro_azar()
BEGIN
  SET @Iteracion = 0;
  REPEAT
    SELECT libro_id, titulo FROM libro ORDER BY RAND() LIMIT 1;
    SET @Iteracion = @iteracion + 1;
    UNTIL @iteracion >= 5
  END REPEAT;
END //
/*
  Transacciones
*/
-- Bloqueo de tablas
-- Trnsaccones
--  Implementar transacciones
START TRANSACTION;
SET @libro_id = 20, @usuario_id = 3;

UPDATE libro SET stock = stock - 1 WHERE libro_id = @libro_id;
SELECT stock FROM libro WHERE libro_id = @libro_id;

INSERT INTO libro_usuario(libro_id, usuario_id) VALUES(@libro_id, @usuario_id);
SELECT * FROM libro_usuario;

COMMIT; -- Termina la transaccion  persiten de forma permanente

ROLLBACK; -- Termina la transaccion y regresa al estado antes de iniciarse la transaccion

-- Transacciones and store PROCEDURE
DELIMITER //
CREATE PROCEDURE prestamo(usuario_id INT, libro_id INT)
BEGIN
  DECLARE EXIT SQLEXCEPTION -- ocurre un error
  BEGIN
    ROLLBACK;
  END;

  START TRANSACTION;
    INSERT INTO libro_usuario(libro_id, usuario_id) VALUES(libro_id, usuario_id);
    UPDATE libro SET stock = stock - 1 WHERE libro.libro_id = libro_id;
  COMMIT;

END //
DELIMITER ;

CALL prestamo(3, 3);
