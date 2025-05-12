-- Parte 1: Conexión como SYSDBA sin usar listener en modo dedicado
CONNECT sys/system2 as sysdba
ALTER SESSION SET CONTAINER = sssbda_s2;

-- Configurar formato de fecha
ALTER SESSION SET nls_date_format='dd/mm/yyyy hh24:mi:ss';

-- B. Creación de la tabla con datos de sesión
CREATE TABLE santiago10.t01_session_data (
    id NUMBER,
    sid NUMBER,
    logon_time DATE,
    username VARCHAR2(30),
    status VARCHAR2(8),
    server VARCHAR2(9),
    osuser VARCHAR2(30),
    machine VARCHAR2(64),
    type VARCHAR2(10),
    process VARCHAR2(24),
    port NUMBER
);

-- Insertar datos de la sesión actual
INSERT INTO santiago10.t01_session_data
SELECT 
    1 AS id,
    s.sid,
    s.logon_time,
    s.username,
    s.status,
    s.server,
    s.osuser,
    s.machine,
    s.type,
    s.process,
    s.port
FROM 
    v$session s
WHERE 
    s.username = 'SYS' 
    AND s.type = 'USER'
    AND s.program LIKE '%sqlplus%';

COMMIT;

-- Verificar los datos insertados
SELECT * FROM santiago10.t01_session_data;

-- Mostrar confirmación
PROMPT Tabla santiago10.t01_session_data creada y poblada exitosamente

-- Parte 2: Cambio a modo dedicado CON listener (sin usar EXIT)
-- Usamos CONNECT manteniendo la ejecución del script
CONNECT sys/system2@sssbda_s2_dedicated AS SYSDBA

INSERT INTO santiago10.t01_session_data
SELECT 
    2 AS id,
    s.sid,
    s.logon_time,
    s.username,
    s.status,
    s.server,
    s.osuser,
    s.machine,
    s.type,
    s.process,
    s.port
FROM 
    v$session s
WHERE 
    s.username = 'SYS' 
    AND s.type = 'USER'
    AND s.program LIKE '%sqlplus%';

COMMIT;

-- Verificar los datos insertados
SELECT * FROM santiago10.t01_session_data;

-- Parte 3: Cambio a modo compartido CON listener (sin usar EXIT)
-- Usamos CONNECT manteniendo la ejecución del script
CONNECT sys/system2@sssbda_s2_shared AS SYSDBA

INSERT INTO santiago10.t01_session_data
SELECT 
    3 AS id,
    s.sid,
    s.logon_time,
    s.username,
    s.status,
    s.server,
    s.osuser,
    s.machine,
    s.type,
    s.process,
    s.port
FROM 
    v$session s
WHERE 
    s.username = 'SYS' 
    AND s.type = 'USER'
    AND s.program LIKE '%sqlplus%';

COMMIT;

-- Verificar los datos insertados
SELECT * FROM santiago10.t01_session_data;