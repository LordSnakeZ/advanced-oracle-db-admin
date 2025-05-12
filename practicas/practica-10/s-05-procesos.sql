CONNECT sys/system2@sssbda_s2_pooled AS SYSDBA

INSERT INTO santiago10.t01_session_data
SELECT 
    4 AS id,
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


/*
P8: El valor en 'server' para este registro será 'POOLED', indicando que la conexión
se estableció mediante el pool de conexiones residente.
*/

-- C. Crear tabla t07_foreground_process
CREATE TABLE santiago10.t07_foreground_process AS
SELECT 
    p.spid AS sosid,
    p.pname,
    s.osuser AS os_username,
    s.username AS bd_username,
    s.server,
    ROUND(p.pga_max_mem/1024/1024, 2) AS pga_max_mem_mb,
    p.tracefile
FROM 
    v$process p 
LEFT JOIN 
    v$session s ON p.addr = s.paddr
WHERE 
    p.background IS NULL
ORDER BY 
    s.username, p.pname;

/*
P9: Los procesos del pool aparecerán con:
- pname: 'S000', 'S001', etc. (shared servers)
- server: 'POOLED' o 'SHARED'
- bd_username: nulo (esperado para conexiones pool)
El número debería coincidir con el MINSIZE configurado (35 en el ejemplo anterior)
*/
SELECT * FROM santiago10.t07_foreground_process;

-- D. Crear tabla t08_f_process_actual
CREATE TABLE santiago10.t08_f_process_actual AS
SELECT 
    p.spid AS sosid,
    p.pname,
    s.osuser AS os_username,
    s.username AS bd_username,
    s.server,
    ROUND(p.pga_max_mem/1024/1024, 2) AS pga_max_mem_mb,
    p.tracefile
FROM 
    v$process p 
JOIN 
    v$session s ON p.addr = s.paddr
WHERE 
    s.sid = SYS_CONTEXT('USERENV','SID');

/*
P10: La memoria PGA asignada se puede ver en pga_max_mem_mb.
Ejemplo de consulta:
SELECT pga_max_mem_mb FROM santiago10.t08_f_process_actual;
*/


SELECT * FROM santiago10.t08_f_process_actual;

-- E. Crear tabla t09_background_process
CREATE TABLE santiago10.t09_background_process AS
SELECT 
    p.sosid,
    p.pname,
    s.osuser AS os_username,
    s.username AS bd_username,
    s.server,
    TRUNC(p.pga_max_mem/1024/1024, 2) AS pga_max_mem_mb,
    p.tracefile
FROM v$process p
    LEFT JOIN v$session s
    ON p.addr = s.paddr
WHERE p.background IS NOT NULL
ORDER BY s.username, p.pname;
/*
P11: El proceso background con mayor PGA sería el primer registro.
Ejemplo de consulta:
SELECT * FROM santiago10.t09_background_process WHERE ROWNUM = 1;
*/

SELECT * FROM santiago10.t09_background_process;

COMMIT;
PROMPT Tablas creadas exitosamente en el esquema santiago10