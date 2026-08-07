-- =========================================================
-- Colegio San Marcos - Backend Avanzado
-- Script de creacion de base de datos + datos semilla (seed)
-- Motor: PostgreSQL
-- =========================================================
-- Uso:
--   psql -U <usuario> -d colegio_san_marcos -f database/schema.sql
-- =========================================================

-- Limpieza previa (permite ejecutar el script varias veces sin errores)
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS alumnos;
DROP TYPE IF EXISTS rol_usuario;

-- =========================================================
-- Tipos
-- =========================================================

CREATE TYPE rol_usuario AS ENUM ('ADMIN', 'COORDINADOR');

-- =========================================================
-- Tabla: alumnos
-- =========================================================

CREATE TABLE alumnos (
    id       SERIAL PRIMARY KEY,
    nombre   VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    grado    VARCHAR(50)  NOT NULL,
    seccion  VARCHAR(10)  NOT NULL
);

-- =========================================================
-- Tabla: usuarios
-- Nota: la columna "passwordHash" se mantiene entre comillas
-- dobles porque asi la genera Prisma (sin @map) a partir del
-- campo passwordHash del modelo Usuario.
-- =========================================================

CREATE TABLE usuarios (
    id             SERIAL PRIMARY KEY,
    nombre         VARCHAR(100)  NOT NULL,
    email          VARCHAR(150)  NOT NULL UNIQUE,
    "passwordHash" VARCHAR(255)  NOT NULL,
    rol            rol_usuario   NOT NULL DEFAULT 'COORDINADOR'
);

-- =========================================================
-- SEED: datos de ejemplo
-- =========================================================

-- Usuario administrador de prueba
-- Credenciales de prueba (SOLO para desarrollo/demo):
--   email:    admin@colegiosanmarcos.edu.sv
--   password: Admin123!
-- El hash fue generado con bcrypt (10-12 rondas), compatible con bcryptjs.
INSERT INTO usuarios (nombre, email, "passwordHash", rol) VALUES
('Administrador', 'admin@colegiosanmarcos.edu.sv', '$2b$12$lncruiOOJkpMRyVmaw7HNu2WvAPm1xGOTdaravnyPye/gugTeXORC', 'ADMIN');

-- Usuario coordinador de prueba (misma contraseña: Admin123!)
INSERT INTO usuarios (nombre, email, "passwordHash", rol) VALUES
('Coordinadora Ana Lopez', 'ana.lopez@colegiosanmarcos.edu.sv', '$2b$12$lncruiOOJkpMRyVmaw7HNu2WvAPm1xGOTdaravnyPye/gugTeXORC', 'COORDINADOR');

-- Alumnos de ejemplo
INSERT INTO alumnos (nombre, apellido, grado, seccion) VALUES
('Carlos',   'Martinez', '1er Grado', 'A'),
('Maria',    'Gonzalez', '1er Grado', 'B'),
('Jose',     'Hernandez', '2do Grado', 'A'),
('Ana',      'Ramirez',  '3er Grado', 'A'),
('Luis',     'Perez',    '3er Grado', 'B'),
('Sofia',    'Lopez',    '4to Grado', 'A'),
('Diego',    'Flores',   '5to Grado', 'A'),
('Valeria',  'Castro',   '6to Grado', 'A');
