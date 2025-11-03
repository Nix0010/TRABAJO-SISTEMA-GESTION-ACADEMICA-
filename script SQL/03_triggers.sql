Función Trigger
SQL

CREATE OR REPLACE FUNCTION validar_nueva_inscripcion()
RETURNS TRIGGER AS $$
DECLARE
    veces_reprobado INT;
BEGIN
    -- Contar cuántas veces el estudiante ha tenido una nota menor a 3.00 (reprobado) en este curso
    SELECT
        COUNT(C.nota) INTO veces_reprobado
    FROM
        Inscripciones I
    JOIN
        Calificaciones C ON I.inscripcion_id = C.inscripcion_id
    WHERE
        I.estudiante_id = NEW.estudiante_id AND I.curso_id = NEW.curso_id
        AND C.nota < 3.00;

    IF veces_reprobado >= 3 THEN -- Si ha reprobado 3 o más veces
        RAISE EXCEPTION 'El estudiante % ya ha reprobado el curso % 3 veces o más. No se permite una nueva inscripción.', NEW.estudiante_id, NEW.curso_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;




2. Definición del Trigger

  
SQL

CREATE TRIGGER trig_validar_inscripcion
BEFORE INSERT ON Inscripciones
FOR EACH ROW
EXECUTE FUNCTION validar_nueva_inscripcion();
