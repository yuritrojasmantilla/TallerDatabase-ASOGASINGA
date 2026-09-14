USE ASOGASINGA;

-- ==========================================
-- TRIGGERS: BEFORE Y AFTER
-- ==========================================

DROP TRIGGER IF EXISTS trg_ValidarPesoGanado_Insert;
DROP TRIGGER IF EXISTS trg_ValidarPesoGanado_Update;
DROP TRIGGER IF EXISTS trg_AuditarAumentoSalario; 
DROP TRIGGER IF EXISTS trg_ValidarIntervaloVacunacion; 
DROP EVENT IF EXISTS evt_DepuracionAuditoriaMensual;
DROP EVENT IF EXISTS evt_CierreSemanalProduccionLeche;

-- 1. Validar Peso del Ganado
DELIMITER //

CREATE TRIGGER trg_ValidarPesoGanado_Insert
BEFORE INSERT ON ganado
FOR EACH ROW 
BEGIN
	IF NEW.peso <= 0 OR NEW.peso > 1500.00 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error: El peso ingresado está fuera de los rangos biológicos válidos (1 - 1500 kg).';
	END IF;
END //

CREATE TRIGGER trg_ValidarPesoGanado_Update
BEFORE UPDATE ON ganado
FOR EACH ROW 
BEGIN
	IF NEW.peso <= 0 OR NEW.peso > 1500.00 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error: El peso ingresado está fuera de los rangos biológicos válidos (1 - 1500 kg).';
	END IF; 
END //

DELIMITER ;


INSERT INTO ganado (codigo_arete, nombre, raza, sexo, fecha_nacimiento, peso, finca_id, tipo_id)
VALUES ('A005', 'Juana', 'Brahman', 'Hembra', '2024-01-10', 1000, 1, 1);

UPDATE ganado
SET peso = 1200
WHERE ganado_id = 3;

SELECT * FROM ganado;




-- 2. Auditar Aumento de Salario a Empleados
DELIMITER //

CREATE TRIGGER trg_AuditarAumentoSalario
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN
	IF NEW.salario <> OLD.salario THEN
		INSERT INTO auditoria_salarios (empleado_id, salario_anterior, salario_nuevo, diferencia, fecha_modificacion)
		VALUES (OLD.empleado_id, OLD.salario, NEW.salario, NEW.salario - OLD.salario, CURRENT_TIMESTAMP);
	END IF;
END //

DELIMITER ;


SELECT * FROM empleados;

UPDATE empleados
SET salario = 5600000
WHERE empleado_id = 2;

SELECT * FROM auditoria_salarios;




-- 3. Validar Intervalo de Tiempo para la Vacunación
DELIMITER // 

CREATE TRIGGER trg_ValidarIntervaloVacunacion
BEFORE INSERT ON vacunacion
FOR EACH ROW
BEGIN
	IF EXISTS (
		SELECT 1
		FROM vacunacion
		WHERE ganado_id = NEW.ganado_id
			AND vacuna_id = NEW.vacuna_id
			AND fecha_aplicacion >= DATE_SUB(NEW.fecha_aplicacion, INTERVAL 30 DAY)
			AND fecha_aplicacion <= NEW.fecha_aplicacion
	) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error: El animal ya recibió esta vacuna en un periodo menor a 30 días.';
	END IF;
END //

DELIMITER ;


INSERT INTO vacunacion (ganado_id, vacuna_id, veterinario_id, fecha_aplicacion, observaciones)
VALUES (1, 1, 1, '2026-03-01', 'Prueba del trigger');

SELECT * FROM vacunacion;




-- ==========================================
-- EVENTOS
-- ==========================================

SET GLOBAL event_scheduler = ON;

-- 1. Depuración de Auditorias Mensualmente
DELIMITER //

CREATE EVENT evt_DepuracionAuditoriaMensual
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
ON COMPLETION PRESERVE
DO
BEGIN
    DELETE FROM auditoria_salarios
    WHERE fecha_modificacion < NOW() - INTERVAL 6 MONTH;

    INSERT INTO bitacora (evento, registros_purgados)
    VALUES ('Depuración mensual de auditoria_salarios', ROW_COUNT());
END //

DELIMITER ;




-- 2. Reporte de Cierre Semanal de Produccion de Leche
DELIMITER // 

CREATE EVENT evt_CierreSemanalProduccionLeche 
ON SCHEDULE EVERY 1 WEEK
START '2026-09-13 23:59:00'
ON COMPLETION PRESERVE
DO
BEGIN
	INSERT INTO resumen_semanal_fincas
		(finca_id, litros_totales, semana_anio, fecha_cierre)
	
	SELECT
		g.finca_id,
		SUM(pl.litros),
		CURDATE(),
		CURDATE()
	FROM ganado g
	JOIN produccion_leche pl
		ON g.ganado_id = pl.ganado_id
	WHERE pl.fecha >= CURDATE() - INTERVAL 6 DAY
		AND pl.fecha <= CURDATE()
	GROUP BY g.finca_id;
END //

DELIMITER ;

