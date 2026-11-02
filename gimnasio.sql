-- ENTREGA SQL - GIMNASIO FITVAL

-- ==================================
-- B1 - CREACIÓN DE TABLAS
-- ==================================

-- Ejercicio B1: crear las ocho tablas
CREATE TABLE planes (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    precio_mensual NUMERIC(6,2) NOT NULL CHECK (precio_mensual >= 0)
);

CREATE TABLE socios (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dni VARCHAR(9) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    fecha_alta DATE NOT NULL,
    plan_id INTEGER NOT NULL REFERENCES planes(id)
);

CREATE TABLE tarjetas (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    activa BOOLEAN NOT NULL,
    socio_id INTEGER UNIQUE NOT NULL REFERENCES socios(id)
);

CREATE TABLE monitores (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dni VARCHAR(9) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE clases (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    actividad VARCHAR(100) NOT NULL,
    sala VARCHAR(50) NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    plazas INTEGER NOT NULL CHECK (plazas > 0),
    monitor_id INTEGER NOT NULL REFERENCES monitores(id)
);

CREATE TABLE reservas (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    socio_id INTEGER NOT NULL REFERENCES socios(id),
    clase_id INTEGER NOT NULL REFERENCES clases(id),
    fecha_reserva DATE NOT NULL,
    UNIQUE (socio_id, clase_id)
);

CREATE TABLE especialidades (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE monitor_especialidades (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    monitor_id INTEGER NOT NULL REFERENCES monitores(id),
    especialidad_id INTEGER NOT NULL REFERENCES especialidades(id),
    UNIQUE (monitor_id, especialidad_id)
);

-- ==================================
-- B2 - INSERCIÓN DE DATOS
-- ==================================

-- Ejercicio B2: cargar los datos de prueba
INSERT INTO planes (nombre, precio_mensual)
VALUES
    ('Básico', 29.90),
    ('Completo', 44.90),
    ('Estudiante', 24.90),
    ('Mañanas', 19.90);

INSERT INTO socios (dni, nombre, email, fecha_alta, plan_id)
VALUES
    ('11111111A', 'Ana Pérez', 'ana@gym.com', '2026-01-10', 2),
    ('22222222B', 'Luis García', 'luis@gym.com', '2026-02-03', 1),
    ('33333333C', 'Marta López', 'marta@gym.com', '2026-03-15', 3),
    ('44444444D', 'Hugo Sanz', 'hugo@gym.com', '2026-03-20', 2),
    ('55555555E', 'Lucía Ruiz', 'lucia@gym.com', '2026-05-02', 3),
    ('66666666F', 'Pablo Martín', 'pablo@gym.com', '2026-06-11', 1),
    ('77777777G', 'Sara Gil', 'sara@gym.com', '2026-09-01', 2),
    ('88888888H', 'Diego Vidal', 'diego@gym.com', '2026-10-01', 1);

INSERT INTO tarjetas (codigo, activa, socio_id)
VALUES
    ('TJ-0001', TRUE, 1),
    ('TJ-0002', TRUE, 2),
    ('TJ-0003', TRUE, 3),
    ('TJ-0004', FALSE, 4),
    ('TJ-0005', TRUE, 5),
    ('TJ-0006', TRUE, 6),
    ('TJ-0007', TRUE, 7);

INSERT INTO monitores (dni, nombre, email)
VALUES
    ('90000001J', 'Carla Navarro', 'carla@gym.com'),
    ('90000002K', 'Javier Ortega', 'javier@gym.com'),
    ('90000003L', 'Elena Romero', 'elena@gym.com'),
    ('90000004M', 'Rubén Castro', 'ruben@gym.com');

INSERT INTO clases (actividad, sala, fecha_hora, plazas, monitor_id)
VALUES
    ('Spinning', 'Sala 1', '2026-11-02 09:00', 12, 1),
    ('Yoga', 'Sala 2', '2026-11-02 18:00', 10, 2),
    ('Pilates', 'Sala 2', '2026-11-03 10:00', 8, 3),
    ('Spinning', 'Sala 1', '2026-11-03 19:00', 12, 1),
    ('Zumba', 'Sala 3', '2026-11-04 18:30', 20, 3),
    ('Yoga', 'Sala 2', '2026-11-05 09:30', 10, 2),
    ('Crossfit', 'Sala 3', '2026-11-05 20:00', 3, 1);

INSERT INTO reservas (socio_id, clase_id, fecha_reserva)
VALUES
    (1, 1, '2026-10-28'),
    (1, 3, '2026-10-28'),
    (1, 7, '2026-10-29'),
    (2, 1, '2026-10-29'),
    (2, 2, '2026-10-29'),
    (3, 2, '2026-10-30'),
    (3, 5, '2026-10-30'),
    (4, 1, '2026-10-30'),
    (4, 7, '2026-10-31'),
    (5, 3, '2026-10-31'),
    (5, 5, '2026-10-31'),
    (6, 4, '2026-11-01'),
    (7, 5, '2026-11-01'),
    (7, 7, '2026-11-01');

INSERT INTO especialidades (nombre)
VALUES
    ('Ciclo indoor'),
    ('Yoga'),
    ('Pilates'),
    ('Baile'),
    ('Fuerza');

INSERT INTO monitor_especialidades (monitor_id, especialidad_id)
VALUES
    (1, 1),
    (1, 5),
    (2, 2),
    (2, 3),
    (3, 3),
    (3, 4),
    (4, 5);

-- ==================================
-- B3 - RESTRICCIONES
-- ==================================

-- Ejercicio B3.1: socio con un plan inexistente
INSERT INTO socios (dni, nombre, email, fecha_alta, plan_id)
VALUES ('99999999Z', 'Nora Prueba', 'nora@gym.com', '2026-10-27', 99);

-- Ejercicio B3.2: email duplicado
INSERT INTO socios (dni, nombre, email, fecha_alta, plan_id)
VALUES ('99999999Z', 'Nora Prueba', 'ana@gym.com', '2026-10-27', 1);

-- Ejercicio B3.3: segunda tarjeta para Ana
INSERT INTO tarjetas (codigo, activa, socio_id)
VALUES ('TJ-0099', TRUE, 1);

-- Ejercicio B3.4: reserva duplicada
INSERT INTO reservas (socio_id, clase_id, fecha_reserva)
VALUES (1, 1, '2026-10-30');

-- Ejercicio B3.5: clase inexistente
INSERT INTO reservas (socio_id, clase_id, fecha_reserva)
VALUES (2, 50, '2026-10-30');

-- Ejercicio B3.6: borrar un plan usado por socios
DELETE FROM planes
WHERE nombre = 'Básico';

-- Ejercicio B3.7: borrar un plan sin socios
DELETE FROM planes
WHERE nombre = 'Mañanas';

-- Restaurar el plan Mañanas para B4.5
INSERT INTO planes (nombre, precio_mensual)
VALUES ('Mañanas', 19.90);

-- ==================================
-- B4 - CONSULTAS
-- ==================================

-- Ejercicio B4.1: socios con su plan y precio
SELECT
    s.nombre AS socio,
    p.nombre AS plan,
    p.precio_mensual
FROM socios s
INNER JOIN planes p ON s.plan_id = p.id
ORDER BY s.nombre;

-- Ejercicio B4.2: clases con sala y monitor
SELECT
    c.actividad,
    c.fecha_hora,
    c.sala,
    m.nombre AS monitor
FROM clases c
INNER JOIN monitores m ON c.monitor_id = m.id
ORDER BY c.fecha_hora;

-- Ejercicio B4.3: todos los socios con su tarjeta
SELECT
    s.nombre AS socio,
    t.codigo AS tarjeta
FROM socios s
LEFT JOIN tarjetas t ON s.id = t.socio_id
ORDER BY s.nombre;

-- Ejercicio B4.4: socios sin tarjeta
SELECT
    s.nombre AS socio
FROM socios s
LEFT JOIN tarjetas t ON s.id = t.socio_id
WHERE t.id IS NULL;

-- Ejercicio B4.5: número de socios por plan
SELECT
    p.nombre AS plan,
    COUNT(s.id) AS numero_socios
FROM planes p
LEFT JOIN socios s ON p.id = s.plan_id
GROUP BY p.id, p.nombre
ORDER BY p.nombre;

-- Ejercicio B4.6: reservas con socio y clase
SELECT
    s.nombre AS socio,
    c.actividad,
    c.fecha_hora
FROM reservas r
INNER JOIN socios s ON r.socio_id = s.id
INNER JOIN clases c ON r.clase_id = c.id
ORDER BY s.nombre, c.fecha_hora;

-- Ejercicio B4.7: socios de la clase 1
SELECT
    s.nombre AS socio
FROM reservas r
INNER JOIN socios s ON r.socio_id = s.id
WHERE r.clase_id = 1
ORDER BY s.nombre;

-- Ejercicio B4.8: número de reservas por clase
SELECT
    c.actividad,
    c.fecha_hora,
    c.plazas,
    COUNT(r.id) AS numero_reservas
FROM clases c
LEFT JOIN reservas r ON c.id = r.clase_id
GROUP BY c.id, c.actividad, c.fecha_hora, c.plazas
ORDER BY c.fecha_hora;

-- Ejercicio B4.9: monitores sin clases
SELECT
    m.nombre AS monitor
FROM monitores m
LEFT JOIN clases c ON m.id = c.monitor_id
WHERE c.id IS NULL;

-- Ejercicio B4.10: especialidades de cada monitor
SELECT
    m.nombre AS monitor,
    e.nombre AS especialidad
FROM monitor_especialidades me
INNER JOIN monitores m ON me.monitor_id = m.id
INNER JOIN especialidades e ON me.especialidad_id = e.id
ORDER BY m.nombre, e.nombre;

-- ==================================
-- B5 - MODIFICAR Y BORRAR
-- ==================================

-- Ejercicio B5.1: cambiar a Luis al plan Completo
SELECT *
FROM socios
WHERE email = 'luis@gym.com';

UPDATE socios
SET plan_id = 2
WHERE email = 'luis@gym.com';

-- Ejercicio B5.2: activar la tarjeta de Hugo
SELECT *
FROM tarjetas
WHERE codigo = 'TJ-0004';

UPDATE tarjetas
SET activa = TRUE
WHERE codigo = 'TJ-0004';

-- Ejercicio B5.3: dar una tarjeta a Diego
SELECT
    s.id,
    s.nombre,
    t.codigo,
    t.activa
FROM socios s
LEFT JOIN tarjetas t ON s.id = t.socio_id
WHERE s.email = 'diego@gym.com';

INSERT INTO tarjetas (codigo, activa, socio_id)
VALUES ('TJ-0008', TRUE, 8);

-- Ejercicio B5.4: Diego reserva la clase 6
SELECT *
FROM reservas
WHERE socio_id = 8 AND clase_id = 6;

INSERT INTO reservas (socio_id, clase_id, fecha_reserva)
VALUES (8, 6, '2026-11-02');

-- Ejercicio B5.5: cancelar solo la reserva de Luis en la clase 2
SELECT *
FROM reservas
WHERE socio_id = 2 AND clase_id = 2;

DELETE FROM reservas
WHERE socio_id = 2 AND clase_id = 2;

-- Ejercicio B5.6: dar de baja a Pablo
SELECT *
FROM socios
WHERE email = 'pablo@gym.com';

DELETE FROM socios
WHERE email = 'pablo@gym.com';

SELECT *
FROM reservas
WHERE socio_id = 6;

DELETE FROM reservas
WHERE socio_id = 6;

SELECT *
FROM tarjetas
WHERE socio_id = 6;

DELETE FROM tarjetas
WHERE socio_id = 6;

SELECT *
FROM socios
WHERE email = 'pablo@gym.com';

DELETE FROM socios
WHERE email = 'pablo@gym.com';
