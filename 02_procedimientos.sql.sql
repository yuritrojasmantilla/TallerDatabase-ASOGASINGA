USE ASOGASINGA;

-- ==========================================
-- PROCEDIMIENTOS ALMACENADOS
-- ==========================================

DROP PROCEDURE IF EXISTS sp_RegistrarProduccionLeche;
DROP PROCEDURE IF EXISTS sp_ActualizarSalarioEmpleado;
DROP PROCEDURE IF EXISTS sp_TrasladarGanadoFinca;
DROP PROCEDURE IF EXISTS sp_RegistrarVacunacion;
DROP PROCEDURE IF EXISTS sp_ReporteGastoAlimento;


-- 1. Registrar Producción de Leche
DELIMITER //

CREATE PROCEDURE sp_RegistrarProduccionLeche (
	IN p_codigo_arete VARCHAR(50),
	IN p_fecha        DATE,
	IN p_litros       DECIMAL(10,2)
)
BEGIN 
	DECLARE v_ganado_id INT;
	DECLARE v_sexo      VARCHAR(10);
	DECLARE v_tipo      VARCHAR(50);
	
	SELECT 
		g.ganado_id,
		g.sexo,
		tg.nombre_tipo
	INTO 
		v_ganado_id,
		v_sexo,
		v_tipo
	FROM ganado g
	JOIN tipos_ganado tg
		ON g.tipo_id = tg.tipo_id
	WHERE g.codigo_arete = p_codigo_arete;
	
	IF v_ganado_id IS NULL THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Error: El código de arete ingresado no existe.';
	END IF;

	IF v_sexo <> 'Hembra' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'El animal debe ser de sexo Hembra.';
	ELSEIF v_tipo <> 'Lechero' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'El animal debe ser de tipo Lechero.';
	ELSE 
		INSERT INTO produccion_leche (ganado_id, fecha, litros)
			VALUES (v_ganado_id, p_fecha, p_litros);
	END IF;
END //

DELIMITER ;

CALL sp_RegistrarProduccionLeche('A001', '2026-09-13', 20.5);
SELECT * FROM produccion_leche;




-- 2. Actualizar Salario de Empleados
DELIMITER //

CREATE PROCEDURE sp_ActualizarSalarioEmpleado (
	IN p_empleado_id  INT,
	IN p_porcentaje DECIMAL(5,2)
)
BEGIN 
    IF NOT EXISTS (
        SELECT 1
        FROM empleados
        WHERE empleado_id = p_empleado_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El empleado ingresado no existe en el sistema';
    END IF;

    IF p_porcentaje <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El aumento debe ser mayor a cero';
    END IF;
    
	UPDATE empleados
	SET salario = salario + ( salario * p_porcentaje / 100)
	WHERE empleado_id = p_empleado_id;
END //

DELIMITER ;

CALL sp_ActualizarSalarioEmpleado (1, 20);
SELECT * FROM empleados;




-- 3. Trasladar Ganado a otra Finca
DELIMITER // 

CREATE PROCEDURE sp_TrasladarGanadoFinca (
	IN p_ganado_id INT,
	IN p_finca_id  INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM ganado
        WHERE ganado_id = p_ganado_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El animal no existe.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM fincas
        WHERE finca_id = p_finca_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La finca de destino no existe.';
    END IF;
    
	UPDATE ganado
	SET finca_id = p_finca_id
	WHERE ganado_id = p_ganado_id;
END //

DELIMITER ;

CALL sp_TrasladarGanadoFinca (1, 1);
SELECT * FROM ganado;




-- 4. Registrar Vacunación
DELIMITER //

CREATE PROCEDURE sp_RegistrarVacunacion (
	IN p_codigo_arete   VARCHAR(50),
	IN p_nombre         VARCHAR(100),
	IN p_veterinario_id INT,
	IN p_observaciones  VARCHAR(200)
)
BEGIN
	DECLARE v_vacuna_id INT;
	DECLARE v_ganado_id INT;

	SELECT ganado_id
	INTO v_ganado_id
	FROM ganado
	WHERE codigo_arete = p_codigo_arete;
	
	SELECT vacuna_id
	INTO v_vacuna_id
	FROM vacunas
	WHERE nombre = p_nombre;
	
    IF v_ganado_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La cabeza de ganado con este arete no existe.';
    END IF;

    IF v_vacuna_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La vacuna no existe.';
    END IF;
	
	INSERT INTO vacunacion (ganado_id, vacuna_id, veterinario_id, fecha_aplicacion, observaciones)
	VALUES (v_ganado_id, v_vacuna_id, p_veterinario_id, CURRENT_DATE, p_observaciones);
END //

DELIMITER ;

CALL sp_RegistrarVacunacion ('A002', 'Fiebre Aftosa', 2, 'Dosis de refuerzo');
SELECT * FROM vacunacion;




-- 5. Reportar Gastos en Alimentos
DELIMITER //

CREATE PROCEDURE sp_ReporteGastoAlimento (
	IN P_ganado_id    INT,
	IN P_fecha_inicio DATE,
	IN p_fecha_fin    DATE
)
BEGIN
	IF p_fecha_inicio > p_fecha_fin THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La fecha de inicio no puede ser mayor a la fecha de fin.';
    END IF;
	
	SELECT 
		al.ganado_id AS ID_Ganado,
		CONCAT(p_fecha_inicio, ' to ', p_fecha_fin) AS Fecha,
		SUM(a.costo * al.cantidad_kg) AS Total_gastado
	FROM alimentacion al
	JOIN alimentos a
		ON a.alimento_id = al.alimento_id
	WHERE al.ganado_id = p_ganado_id
		AND al.fecha BETWEEN p_fecha_inicio AND p_fecha_fin
	GROUP BY al.ganado_id;
END //

DELIMITER ;

CALL sp_ReporteGastoAlimento (1, '2026-01-01', '2026-09-30');