1. Promedio de Notas por Curso y Profesor (Usando CTEs)
Objetivo: Calcular la nota promedio de cada curso y mostrar el nombre del profesor que lo imparte.

SQL

WITH CursoPromedio AS (
    SELECT
        I.curso_id,
        AVG(C.nota) AS nota_promedio
    FROM
        Inscripciones I
    JOIN
        Calificaciones C ON I.inscripcion_id = C.inscripcion_id
    GROUP BY
        I.curso_id
)
SELECT
    CU.nombre AS nombre_curso,
    CP.nota_promedio,
    P.nombre || ' ' || P.apellido AS nombre_profesor
FROM
    Cursos CU
JOIN
    Profesores P ON CU.profesor_id = P.profesor_id
JOIN
    CursoPromedio CP ON CU.curso_id = CP.curso_id
ORDER BY
    CP.nota_promedio DESC;
2. Ranking de Estudiantes por Promedio General (Usando Window Functions)
Objetivo: Listar a los estudiantes con su promedio general y su posición en el ranking (1er, 2do, etc.).

SQL

SELECT
    E.nombre || ' ' || E.apellido AS nombre_estudiante,
    AVG(CA.nota) AS promedio_general,
    RANK() OVER (ORDER BY AVG(CA.nota) DESC) AS ranking_general
FROM
    Estudiantes E
JOIN
    Inscripciones I ON E.estudiante_id = I.estudiante_id
JOIN
    Calificaciones CA ON I.inscripcion_id = CA.inscripcion_id
GROUP BY
    E.estudiante_id, E.nombre, E.apellido
ORDER BY
    ranking_general;
3. Cursos con más de N Estudiantes (Usando CTEs y Subconsulta)
Objetivo: Identificar los cursos que tienen más de 5 estudiantes inscritos (cambiar 5 por el número deseado).

SQL

WITH ConteoEstudiantes AS (
    SELECT
        curso_id,
        COUNT(estudiante_id) AS total_estudiantes
    FROM
        Inscripciones
    GROUP BY
        curso_id
)
SELECT
    C.nombre AS nombre_curso,
    CE.total_estudiantes
FROM
    Cursos C
JOIN
    ConteoEstudiantes CE ON C.curso_id = CE.curso_id
WHERE
    CE.total_estudiantes > 5 -- N = 5 en este caso
ORDER BY
    CE.total_estudiantes DESC;
4. Estudiantes que superaron el Promedio de su Curso (Usando Window Functions)
Objetivo: Encontrar estudiantes cuya nota individual en un curso sea mayor que la nota promedio de ese mismo curso.

SQL

SELECT
    E.nombre || ' ' || E.apellido AS estudiante,
    CU.nombre AS curso,
    CA.nota AS nota_individual,
    AVG(CA.nota) OVER (PARTITION BY CU.curso_id) AS promedio_curso
FROM
    Calificaciones CA
JOIN
    Inscripciones I ON CA.inscripcion_id = I.inscripcion_id
JOIN
    Estudiantes E ON I.estudiante_id = E.estudiante_id
JOIN
    Cursos CU ON I.curso_id = CU.curso_id
WHERE
    CA.nota > AVG(CA.nota) OVER (PARTITION BY CU.curso_id)
ORDER BY
    curso, nota_individual DESC;
5. Histórico de Calificaciones por Estudiante (Usando CTEs para Agregación)
Objetivo: Mostrar todas las calificaciones de un estudiante, incluyendo su promedio histórico general.

SQL

WITH EstudiantePromedio AS (
    SELECT
        I.estudiante_id,
        AVG(CA.nota) AS promedio_general
    FROM
        Inscripciones I
    JOIN
        Calificaciones CA ON I.inscripcion_id = CA.inscripcion_id
    WHERE
        I.estudiante_id = 1 -- Filtrar por un estudiante específico
    GROUP BY
        I.estudiante_id
)
SELECT
    E.nombre || ' ' || E.apellido AS estudiante,
    CU.nombre AS curso,
    CA.nota,
    EP.promedio_general
FROM
    Estudiantes E
JOIN
    Inscripciones I ON E.estudiante_id = I.estudiante_id
JOIN
    Calificaciones CA ON I.inscripcion_id = CA.inscripcion_id
JOIN
    EstudiantePromedio EP ON E.estudiante_id = EP.estudiante_id
WHERE
    E.estudiante_id = 1; -- Asegurar que solo se muestre el estudiante filtrado
