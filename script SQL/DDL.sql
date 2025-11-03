-- DDL para el Sistema de Gestión Académica

-- 1. Tabla Departamentos
CREATE TABLE Departamentos (
    departamento_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Tabla Profesores
CREATE TABLE Profesores (
    profesor_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    departamento_id INT NOT NULL,
    FOREIGN KEY (departamento_id) REFERENCES Departamentos(departamento_id)
);

-- 3. Tabla Cursos
CREATE TABLE Cursos (
    curso_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    creditos INT NOT NULL CHECK (creditos > 0 AND creditos <= 10),
    departamento_id INT NOT NULL,
    profesor_id INT, -- El profesor puede ser asignado después
    FOREIGN KEY (departamento_id) REFERENCES Departamentos(departamento_id),
    FOREIGN KEY (profesor_id) REFERENCES Profesores(profesor_id)
);

-- 4. Tabla Estudiantes
CREATE TABLE Estudiantes (
    estudiante_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT chk_edad CHECK (fecha_nacimiento < CURRENT_DATE) -- Restricción básica de fecha
);

-- 5. Tabla Inscripciones (Relación Muchos a Muchos entre Estudiantes y Cursos)
CREATE TABLE Inscripciones (
    inscripcion_id SERIAL PRIMARY KEY,
    estudiante_id INT NOT NULL,
    curso_id INT NOT NULL,
    fecha_inscripcion DATE NOT NULL DEFAULT CURRENT_DATE,
    UNIQUE (estudiante_id, curso_id), -- Un estudiante solo se inscribe una vez a un curso
    FOREIGN KEY (estudiante_id) REFERENCES Estudiantes(estudiante_id) ON DELETE CASCADE,
    FOREIGN KEY (curso_id) REFERENCES Cursos(curso_id) ON DELETE CASCADE
);

-- 6. Tabla Calificaciones
CREATE TABLE Calificaciones (
    calificacion_id SERIAL PRIMARY KEY,
    inscripcion_id INT NOT NULL UNIQUE, -- Una inscripción tiene un conjunto de calificaciones (simplificado a una entrada única aquí)
    nota NUMERIC(3, 2) NOT NULL CHECK (nota >= 0.00 AND nota <= 5.00),
    fecha_evaluacion DATE NOT NULL,
    FOREIGN KEY (inscripcion_id) REFERENCES Inscripciones(inscripcion_id) ON DELETE CASCADE
);
