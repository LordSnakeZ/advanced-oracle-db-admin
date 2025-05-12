-- A. Conexión como sysbda en modo compartido
CONNECT sys/system2@sssbda_s2_shared AS SYSDBA;

-- B. Crear tabla t02_dispatcher_config
CREATE TABLE santiago10.t02_dispatcher_config AS 
SELECT
    1 AS id,
    dispatchers,
    connections,
    sessions,
    service
FROM v$dispatcher_config;


-- C. Crear tabla t03_dispatcher
CREATE TABLE santiago10.t03_dispatcher AS
SELECT 
    ROWNUM AS id,
    d.name,
    d.network,
    d.status,
    d.messages,
    ROUND(d.bytes/1024/1024, 2) AS messages_mb,
    d.created AS circuits_created,
    ROUND(d.idle/60, 2) AS idle_min
FROM 
    v$dispatcher d;

/*
P4: circuits_created indica el número de circuitos virtuales creados por el dispatcher.
Un valor cero significa que el dispatcher no ha manejado ninguna conexión cliente.
*/

-- D. Crear tabla t04_shared_server
CREATE TABLE santiago10.t04_shared_server AS
SELECT 
    ROWNUM AS id,
    s.name,
    s.status,
    s.messages,
    ROUND(s.bytes/1024/1024, 2) AS messages_mb,
    s.requests,
    ROUND(s.idle/60, 2) AS idle_min,
    ROUND(s.busy/60, 2) AS busy_min
FROM 
    v$shared_server s;

-- E. Crear tabla t05_queue
CREATE TABLE santiago10.t05_queue AS
SELECT 
    ROWNUM AS id,
    q.queued,
    ROUND(q.wait/60, 2) AS wait,
    q.totalq
FROM 
    v$queue q;

/*
P5: Un valor alto en queued indica congestión. Para reducirlo:
1. Aumentar shared_servers
2. Ajustar dispatchers
3. Optimizar consultas frecuentes
*/

-- F. Crear tabla t06_virtual_circuit
CREATE TABLE santiago10.t06_virtual_circuit AS
SELECT
    1 AS id,
    (SELECT circuit FROM v$circuit) AS circuit,
    (SELECT d.name 
        FROM v$dispatcher d, v$circuit c
        WHERE d.paddr = c.dispatcher) AS name,
    (SELECT server FROM v$circuit) AS server,
    (SELECT status FROM v$circuit) AS status,
    (SELECT queue FROM v$circuit) AS queue
FROM dual;

/*
P6: Cero registros indica que no hay conexiones activas en modo compartido.

P7: La columna queue indica dónde está esperando el circuito:
- COMMON: Cola común
- DISPATCHER: Cola del dispatcher
- SERVER: Cola del servidor
Otros valores posibles: NONE, WAIT
*/

COMMIT;

PROMPT Tablas creadas exitosamente en el esquema santiago10