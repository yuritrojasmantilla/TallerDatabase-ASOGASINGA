-- ==========================================
-- BASE DE DATOS: ASOGASINGA
-- Asociación de Ganaderos Sin Ganado
-- ==========================================

DROP DATABASE IF EXISTS ASOGASINGA;
CREATE DATABASE ASOGASINGA;
USE ASOGASINGA;


-- ==========================================
-- TABLAS
-- ==========================================

CREATE TABLE socios (
    socio_id      INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    apellido      VARCHAR(100) NOT NULL,
    cedula        VARCHAR(20) NOT NULL UNIQUE,
    telefono      VARCHAR(20),
    correo        VARCHAR(100),
    direccion     VARCHAR(150),
    fecha_ingreso DATE
);


CREATE TABLE municipios (
    municipio_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    departamento VARCHAR(100)
);


CREATE TABLE fincas (
    finca_id     INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    ubicacion    VARCHAR(150) NOT NULL,
    hectareas    DECIMAL(10,2),
    socio_id     INT,
    municipio_id INT,
    FOREIGN KEY (socio_id) REFERENCES socios(socio_id),
    FOREIGN KEY (municipio_id) REFERENCES municipios(municipio_id)
);


CREATE TABLE tipos_ganado (
    tipo_id     INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo VARCHAR(50) UNIQUE,
    descripcion VARCHAR(150)
);


CREATE TABLE ganado (
    ganado_id        INT AUTO_INCREMENT PRIMARY KEY,
    codigo_arete     VARCHAR(50) NOT NULL UNIQUE,
    nombre           VARCHAR(50),
    raza             VARCHAR(50) NOT NULL,
    sexo             VARCHAR(10) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    peso             DECIMAL(10,2) NOT NULL,
    finca_id         INT,
    tipo_id          INT,
    FOREIGN KEY (finca_id) REFERENCES fincas(finca_id),
    FOREIGN KEY (tipo_id) REFERENCES tipos_ganado(tipo_id)
);


CREATE TABLE veterinarios (
    veterinario_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    telefono       VARCHAR(20) NOT NULL,
    especialidad   VARCHAR(100)
);


CREATE TABLE vacunas (
    vacuna_id   INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    descripcion VARCHAR(150),
    dosis       VARCHAR(50)
);


CREATE TABLE vacunacion (
    vacunacion_id    INT AUTO_INCREMENT PRIMARY KEY,
    ganado_id        INT NOT NULL,
    vacuna_id        INT NOT NULL,
    veterinario_id   INT NOT NULL,
    fecha_aplicacion DATE NOT NULL,
    observaciones    VARCHAR(200),
    FOREIGN KEY (ganado_id) REFERENCES ganado(ganado_id),
    FOREIGN KEY (vacuna_id) REFERENCES vacunas(vacuna_id),
    FOREIGN KEY (veterinario_id) REFERENCES veterinarios(veterinario_id)
);


CREATE TABLE produccion_leche (
    produccion_id        INT AUTO_INCREMENT PRIMARY KEY,
    ganado_id INT NOT NULL,
    fecha     DATE NOT NULL,
    litros    DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ganado_id) REFERENCES ganado(ganado_id)
);


CREATE TABLE empleados (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    cargo       VARCHAR(100) NOT NULL,
    telefono    VARCHAR(20) NOT NULL,
    salario     DECIMAL(10,2) NOT NULL,
    finca_id    INT NOT NULL,
    FOREIGN KEY (finca_id) REFERENCES fincas(finca_id)
);


CREATE TABLE alimentos (
    alimento_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    tipo        VARCHAR(50) NOT NULL,
    costo       DECIMAL(10,2)
);


CREATE TABLE alimentacion (
    alimentacion_id INT AUTO_INCREMENT PRIMARY KEY,
    ganado_id       INT NOT NULL,
    alimento_id     INT NOT NULL,
    fecha           DATE,
    cantidad_kg     DECIMAL(10,2),
    FOREIGN KEY (ganado_id) REFERENCES ganado(ganado_id),
    FOREIGN KEY (alimento_id) REFERENCES alimentos(alimento_id)
);


CREATE TABLE auditoria_salarios (
	auditoria_id       INT AUTO_INCREMENT PRIMARY KEY,
	empleado_id        INT,
	salario_anterior   DECIMAL(10,2),
	salario_nuevo      DECIMAL(10,2),
	diferencia         DECIMAL(10,2),
	fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE bitacora (
    bitacora_id        INT AUTO_INCREMENT PRIMARY KEY,
    evento             VARCHAR(100),
    registros_purgados INT,
    fecha_ejecucion    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE resumen_semanal_fincas (
	resumen_id     INT AUTO_INCREMENT PRIMARY KEY,
	finca_id       INT,
	litros_totales DECIMAL(10,2),
	semana_anio    DATE,
	fecha_cierre   DATE
);


-- ==========================================
-- INSERTS
-- ==========================================

INSERT INTO municipios (nombre, departamento)
VALUES
	('Yopal', 'Casanare'),
	('Villavicencio', 'Meta');

INSERT INTO socios (nombre, apellido, cedula, telefono, correo, direccion, fecha_ingreso)
VALUES
	('Carlos', 'Perez', '12345678', '3001111111', 'carlos@gmail.com', 'Calle 1', '2025-01-10'),
	('Ana', 'Gomez', '87654321', '3002222222', 'ana@gmail.com', 'Calle 2', '2025-02-15');

INSERT INTO fincas (nombre, ubicacion, hectareas, socio_id, municipio_id)
VALUES
	('La Esperanza', 'Vereda Norte', 120.5, 1, 1),
	('El Descanso', 'Vereda Sur', 80.0, 2, 2);

INSERT INTO tipos_ganado (nombre_tipo, descripcion)
VALUES
	('Lechero', 'Ganado para producción de leche'),
	('Carne', 'Ganado para producción cárnica');

INSERT INTO ganado (codigo_arete, nombre, raza, sexo, fecha_nacimiento, peso, finca_id, tipo_id)
VALUES
	('A001', 'Lola', 'Holstein', 'Hembra', '2023-01-10', 450, 1, 1),
	('A002', 'ToroMax', 'Brahman', 'Macho', '2022-05-12', 600, 2, 2);

INSERT INTO veterinarios (nombre, telefono, especialidad) 
VALUES
	('Dr. Ramirez', '3111111111', 'Bovinos'),
	('Dra. Lopez', '3222222222', 'Vacunación');

INSERT INTO vacunas (nombre, descripcion, dosis) 
VALUES
	('Brucelosis', 'Prevención brucelosis', '10ml'),
	('Fiebre Aftosa', 'Prevención aftosa', '5ml');

INSERT INTO vacunacion (ganado_id, vacuna_id, veterinario_id, fecha_aplicacion, observaciones)
VALUES
	(1, 1, 1, '2026-01-10', 'Sin novedades'),
	(2, 2, 2, '2026-01-15', 'Aplicación correcta');

INSERT INTO produccion_leche (ganado_id, fecha, litros)
VALUES
	(1, '2026-02-01', 18.5),
	(1, '2026-02-02', 19.2);

INSERT INTO empleados (nombre, cargo, telefono, salario, finca_id)
VALUES
	('Pedro Ruiz', 'Administrador', '3333333333', 2500000, 1),
	('Luis Mora', 'Ordeñador', '3444444444', 1800000, 2);

INSERT INTO alimentos (nombre, tipo, costo) 
VALUES
	('Pasto Premium', 'Natural', 50000),
	('Concentrado Bovino', 'Procesado', 120000);

INSERT INTO alimentacion (ganado_id, alimento_id, fecha, cantidad_kg)
VALUES
	(1, 1, '2026-02-01', 15),
	(2, 2, '2026-02-01', 10);