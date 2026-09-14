USE ASOGASINGA;

-- ==========================================
-- SEGURIDAD: USUARIOS, ROLES Y PERMISOS
-- ==========================================

DROP USER IF EXISTS 'usuario_admin'@'localhost', 'usuario_veterinario'@'localhost', 'usuario_operador'@'localhost', 'usuario_rrhh'@'localhost', 'usuario_auditor'@'localhost';
DROP ROLE IF EXISTS 'rol_administrador', 'rol_veterinario', 'rol_operador', 'rol_rrhh', 'rol_auditor';


-- 1.  usuario_admin (Rol: Administrador del Sistema)
CREATE ROLE 'rol_administrador';

GRANT ALL PRIVILEGES 
ON ASOGASINGA.*
TO 'rol_administrador';

CREATE USER 'usuario_admin'@'localhost'
IDENTIFIED BY 'Admin123';

GRANT 'rol_administrador'
TO 'usuario_admin'@'localhost';

SET DEFAULT ROLE 'rol_administrador'
TO 'usuario_admin'@'localhost';



-- 2.   usuario_veterinario (Rol: Personal de Salud Animal)
CREATE ROLE 'rol_veterinario';

GRANT SELECT 
ON ASOGASINGA.ganado
TO 'rol_veterinario';

GRANT SELECT 
ON ASOGASINGA.fincas
TO 'rol_veterinario';

GRANT INSERT 
ON ASOGASINGA.vacunacion
TO 'rol_veterinario';

GRANT INSERT 
ON ASOGASINGA.vacunas
TO 'rol_veterinario';

GRANT EXECUTE 
ON PROCEDURE ASOGASINGA.sp_RegistrarVacunacion
TO 'rol_veterinario';

CREATE USER 'usuario_veterinario'@'localhost'
IDENTIFIED BY 'Veterinario123';

GRANT 'rol_veterinario'
TO 'usuario_veterinario'@'localhost';

SET DEFAULT ROLE 'rol_veterinario'
TO 'usuario_veterinario'@'localhost';



-- 3. usuario_operador (Rol: Encargado de Finca / Producción)
CREATE ROLE 'rol_operador';

GRANT SELECT, INSERT, UPDATE 
ON ASOGASINGA.produccion_leche
TO 'rol_operador';

GRANT SELECT, INSERT, UPDATE 
ON ASOGASINGA.alimentacion
TO 'rol_operador';

GRANT SELECT, INSERT, UPDATE 
ON ASOGASINGA.ganado
TO 'rol_operador';

GRANT EXECUTE 
ON PROCEDURE ASOGASINGA.sp_RegistrarProduccionLeche
TO 'rol_operador';

GRANT EXECUTE 
ON FUNCTION ASOGASINGA.fn_CalcularEdadMeses
TO 'rol_operador';

CREATE USER 'usuario_operador'@'localhost'
IDENTIFIED BY 'Operador123';

GRANT 'rol_operador'
TO 'usuario_operador'@'localhost';

SET DEFAULT ROLE 'rol_operador'
TO 'usuario_operador'@'localhost';



-- 4. usuario_rrhh (Rol: Recursos Humanos)
CREATE ROLE 'rol_rrhh';

GRANT SELECT, INSERT, UPDATE, DELETE
ON ASOGASINGA.empleados
TO 'rol_rrhh';

GRANT EXECUTE
ON PROCEDURE ASOGASINGA.sp_ActualizarSalarioEmpleado
TO 'rol_rrhh';

CREATE USER 'usuario_rrhh'@'localhost'
IDENTIFIED BY 'RRHH123';

GRANT 'rol_rrhh'
TO 'usuario_rrhh'@'localhost';

SET DEFAULT ROLE 'rol_rrhh'
TO 'usuario_rrhh'@'localhost';



-- 5. usuario_auditor (Rol: Auditor Externo / Consulta)
CREATE ROLE 'rol_auditor';

GRANT SELECT 
ON ASOGASINGA.*
TO 'rol_auditor';

CREATE USER 'usuario_auditor'@'localhost'
IDENTIFIED BY 'Auditor123';

GRANT 'rol_auditor'
TO 'usuario_auditor'@'localhost';

SET DEFAULT ROLE 'rol_auditor'
TO 'usuario_auditor'@'localhost';
