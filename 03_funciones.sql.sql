USE ASOGASINGA;

-- ==========================================
-- FUNCIONES CREADAS POR EL USUARIO
-- ==========================================

DROP FUNCTION IF EXISTS fn_CalcularEdadMeses;
DROP FUNCTION IF EXISTS fn_TotalLitrosFinca;
DROP FUNCTION IF EXISTS fn_PromedioPesoPorRaza;
DROP FUNCTION IF EXISTS fn_ContarGanadoPorSocio;
DROP FUNCTION IF EXISTS fn_CostoTotalAlimentacion;


-- 1. Calcular Edad en Meses
DELIMITER //

CREATE FUNCTION fn_CalcularEdadMeses (p_ganado_id INT)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA

BEGIN
	DECLARE v_fecha_nacimiento DATE;

	SELECT fecha_nacimiento 
	INTO v_fecha_nacimiento
	FROM ganado
	WHERE ganado_id = p_ganado_id;
	
	RETURN TIMESTAMPDIFF(MONTH, v_fecha_nacimiento, CURRENT_DATE);
END //

DELIMITER ;

SELECT fn_CalcularEdadMeses(1) AS Edad_meses;




-- 2. Total de Litros por Finca
DELIMITER //

CREATE FUNCTION fn_TotalLitrosFinca (
	p_finca_id     INT, 
	p_fecha_inicio DATE, 
	p_fecha_fin    DATE
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA

BEGIN
	DECLARE v_total_litros DECIMAL(10,2);

	SELECT 
    	SUM(pl.litros) 
    INTO v_total_litros
	FROM ganado g
	JOIN produccion_leche pl
    	ON g.ganado_id = pl.ganado_id
    WHERE g.finca_id = p_finca_id
		AND pl.fecha BETWEEN p_fecha_inicio AND p_fecha_fin;
	
	RETURN COALESCE(v_total_litros, 0);
END //

DELIMITER ;

SELECT fn_TotalLitrosFinca(1, '2026-01-01', '2026-09-30') AS TotalLitros;




-- 3. Promedio de Peso por Raza
DELIMITER //

CREATE FUNCTION fn_PromedioPesoPorRaza (p_raza VARCHAR(50))
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA

BEGIN
	DECLARE v_promedio_peso DECIMAL(10,2);

	SELECT AVG(peso)
	INTO v_promedio_peso
	FROM ganado
	WHERE raza = p_raza;
	
	RETURN COALESCE(v_promedio_peso, 0);
END //

DELIMITER ;

SELECT fn_PromedioPesoPorRaza('Holstein') AS PesoPromedio;




-- 4. Cantidad de Ganado por Socio
DELIMITER //

CREATE FUNCTION fn_ContarGanadoPorSocio (p_socio_id INT)
RETURNS INT
DETERMINISTIC 
READS SQL DATA

BEGIN 
	DECLARE v_cantidad_ganado INT;

	SELECT COUNT(g.ganado_id)
	INTO v_cantidad_ganado
	FROM ganado g
	JOIN fincas f
		ON g.finca_id = f.finca_id
	JOIN socios s
		ON f.socio_id = s.socio_id
	WHERE s.socio_id = p_socio_id;
	
	RETURN v_cantidad_ganado;
END //

DELIMITER ;

SELECT fn_ContarGanadoPorSocio(2) AS CantidadGanado;




-- 5. Costo Total por Alimentación
DELIMITER //

CREATE FUNCTION fn_CostoTotalAlimentacion (p_ganado_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA

BEGIN
	DECLARE v_gasto_historico DECIMAL(10,2);

	SELECT SUM(a.costo * al.cantidad_kg)
	INTO v_gasto_historico
	FROM alimentacion al
	JOIN alimentos a 
		ON al.alimento_id = a.alimento_id
	WHERE al.ganado_id = p_ganado_id;
	
	RETURN COALESCE(v_gasto_historico, 0);
END //
DELIMITER ;

SELECT fn_CostoTotalAlimentacion(1) AS GastoHistorico;