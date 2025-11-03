# 🎓 Sistema de Gestión Académica (Taller PostgreSQL 16)

Este repositorio contiene la implementación completa de un sistema de gestión académica diseñado en **PostgreSQL 16**, integrando los conceptos de DDL, DML, consultas avanzadas (CTEs/Window Functions), Triggers y control de concurrencia.

---

## ⚙️ Requisitos del Sistema

Para la instalación y prueba del sistema, se requieren los siguientes componentes:

* **Motor de Base de Datos:** PostgreSQL 16+.
* **Herramientas de Administración:** pgAdmin 4 o DBeaver.
* **Editor de Código:** VSCode o similar para ejecutar scripts SQL.

---

## 🚀 Guía de Instalación y Ejecución

Sigue estos pasos para levantar la base de datos y probar el sistema:

### Paso 1: Creación de la Base de Datos

Conéctate a tu servidor PostgreSQL y ejecuta el siguiente comando para crear la base de datos:

```sql
CREATE DATABASE gestion_academica_db;
Paso 2: Ejecución de Scripts SQLConéctate a la base de datos gestion_academica_db y ejecuta los archivos de la carpeta sql/ en el orden numérico exacto para asegurar la integridad de los datos.ArchivoContenidoObjetivo01_DDL.sqlData Definition LanguageCrea todas las tablas con sus PK, FK, y restricciones (CHECK, UNIQUE).02_DML_data.sqlData Manipulation LanguageInserta datos de prueba para Departamentos, Profesores, Estudiantes, Cursos e Inscripciones.04_Triggers.sqlValidación de NegocioDefine y activa el Trigger de control de inscripciones.Paso 3: Prueba de FuncionalidadUna vez que el esquema y los datos están cargados, ejecuta los siguientes scripts para demostrar los requisitos avanzados:ArchivoConcepto DemostradoDescripción03_Consultas_Complejas.sqlÁlgebra Relacional AvanzadaEjecuta las 5 consultas que utilizan CTEs y Window Functions para obtener información compleja (e.g., rankings, promedios por curso).05_Concurrencia.sqlControl de ConcurrenciaContiene el script para demostrar el problema de Actualización Perdida (Lost Update) y su solución mediante el uso de SELECT ... FOR UPDATE.📐 Diseño del Modelo EREl modelo se diseñó con 6 entidades principales y sus respectivas relaciones: Departamentos, Profesores, Cursos, Estudiantes, Inscripciones, y Calificaciones.El diagrama Entidad-Relación completo se encuentra en la carpeta diagramas/.🛡️ Integridad y Concurrencia1. Trigger de Validación de NegocioImplementación: El script 04_Triggers.sql crea un trigger que se ejecuta BEFORE INSERT en la tabla Inscripciones.Regla: El trigger impide que un estudiante se inscriba a un curso si ya lo ha reprobado 3 o más veces (nota menor a 3.00).2. Control de ConcurrenciaEl script 05_Concurrencia.sql simula dos transacciones simultáneas que intentan modificar los créditos de un curso.La solución implementada utiliza el bloqueo explícito con SELECT ... FOR UPDATE para garantizar la integridad transaccional y evitar que la primera actualización se pierda.
