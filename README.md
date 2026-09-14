# Taller de Base de Datos - ASOGASINGA

## Descripción

Este repositorio contiene el desarrollo del taller de bases de datos realizado sobre el sistema de gestión de la asociación ganadera **ASOGASINGA**.

El proyecto implementa diferentes componentes de una base de datos relacional utilizando **MySQL**, incluyendo procedimientos almacenados, funciones definidas por el usuario, gestión de roles y privilegios, triggers y eventos programados.

El objetivo es aplicar conceptos de programación y administración de bases de datos para automatizar procesos relacionados con la gestión del ganado, producción de leche, vacunación, alimentación, empleados y seguridad de la información.

---

## Contenido del repositorio

El repositorio está organizado en los siguientes archivos:

### 1. Creación y configuración de la base de datos

Archivo:

`01_base_datos.sql`

Contiene la creación de la base de datos **ASOGASINGA**, sus tablas, relaciones, claves primarias y foráneas, además de los datos necesarios para realizar las pruebas del sistema.

### 2. Procedimientos almacenados

Archivo:

`02_procedimientos.sql`

Contiene los cinco procedimientos almacenados desarrollados:

- `sp_RegistrarProduccionLeche`
- `sp_ActualizarSalarioEmpleado`
- `sp_TrasladarGanadoFinca`
- `sp_RegistrarVacunacion`
- `sp_ReporteGastoAlimento`

Estos procedimientos permiten automatizar operaciones frecuentes y aplicar validaciones antes de modificar la información.

### 3. Funciones definidas por el usuario

Archivo:

`03_funciones.sql`

Contiene las siguientes funciones:

- `fn_CalcularEdadMeses`
- `fn_TotalLitrosFinca`
- `fn_PromedioPesoPorRaza`
- `fn_ContarGanadoPorSocio`
- `fn_CostoTotalAlimentacion`

Estas funciones permiten realizar cálculos y consultas reutilizables dentro de la base de datos.

### 4. Seguridad y gestión de usuarios

Archivo:

`04_seguridad.sql`

Contiene la configuración de usuarios y roles de MySQL, aplicando el principio de **mínimo privilegio**.

Se implementan los siguientes roles:

- Administrador
- Veterinario
- Operador
- Recursos Humanos
- Auditor

Cada rol posee únicamente los permisos necesarios para realizar sus funciones dentro del sistema.

### 5. Triggers y eventos

Archivo:

`05_triggers_eventos.sql`

Contiene los triggers y eventos programados utilizados para automatizar procesos y aplicar reglas de integridad.

Entre ellos se encuentran:

- Validación del peso del ganado al insertar o actualizar registros.
- Auditoría de modificaciones salariales.
- Validación del intervalo mínimo entre vacunaciones.
- Depuración periódica de registros de auditoría.
- Consolidación semanal de la producción de leche por finca.

### 6. Documento de explicación

Archivo:

`Explicacion_Taller.pdf`

Documento que contiene la explicación del desarrollo realizado, incluyendo la lógica utilizada, ejemplos y pruebas de los diferentes componentes implementados.

---

## Tecnologías utilizadas

- **MySQL**
- **SQL**
- Procedimientos almacenados
- Funciones definidas por el usuario (UDF)
- Triggers
- Eventos programados
- Roles y privilegios
- Control de acceso mediante usuarios

---

## Orden recomendado de ejecución

Para ejecutar correctamente el proyecto, se recomienda seguir este orden:

```text
01_base_datos.sql
        ↓
02_procedimientos.sql
        ↓
03_funciones.sql
        ↓
04_seguridad.sql
        ↓
05_triggers_eventos.sql
