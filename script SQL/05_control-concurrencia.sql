1. Problema (Ejecutar simultáneamente en 2 sesiones de psql o DBeaver/pgAdmin)


Escenario: Dos profesores intentan actualizar simultáneamente los créditos de un curso.
  

Sesión 1:

SQL

BEGIN;
SELECT creditos FROM Cursos WHERE curso_id = 1; -- Lee el valor actual (ej: 4)
-- Espera 10 segundos (para simular el retraso en la lógica de negocio)
UPDATE Cursos SET creditos = 5 WHERE curso_id = 1; -- Actualiza a 5
COMMIT;
Sesión 2 (Inicia antes de que la Sesión 1 haga COMMIT):

SQL

BEGIN;
SELECT creditos FROM Cursos WHERE curso_id = 1; -- Lee el valor actual (ej: 4)
-- Espera 5 segundos
UPDATE Cursos SET creditos = 6 WHERE curso_id = 1; -- Actualiza a 6
COMMIT; -- Si usa READ COMMITTED, el valor de la Sesión 1 se pierde.



2. Solución (Usando SELECT FOR UPDATE)


  
Solución: Utilizar SELECT FOR UPDATE para obtener un bloqueo exclusivo en la fila antes de la actualización, forzando a la segunda transacción a esperar hasta que la primera finalice.

Sesión 1 (Solución):

SQL

BEGIN;
SELECT creditos FROM Cursos WHERE curso_id = 1 FOR UPDATE; -- Bloquea la fila
-- Lógica de negocio
UPDATE Cursos SET creditos = 5 WHERE curso_id = 1;
COMMIT;


Sesión 2 (Solución):

SQL

BEGIN;
SELECT creditos FROM Cursos WHERE curso_id = 1 FOR UPDATE; -- Esperará hasta el COMMIT de Sesión 1
-- Una vez desbloqueada, lee el nuevo valor (5) y procede con su lógica
UPDATE Cursos SET creditos = 6 WHERE curso_id = 1;
COMMIT; -- El valor final es 6, pero la lógica fue secuencial.
