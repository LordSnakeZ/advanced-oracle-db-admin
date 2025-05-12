CONNECT sys/system2 AS SYSDBA;

ALTER SYSTEM SET shared_servers = 4 SCOPE = memory;
ALTER SYSTEM SET max_shared_servers = 20 SCOPE = memory;
ALTER SYSTEM SET dispatchers = '(dispatchers = 2)(protocol = tcp)' SCOPE = memory;
ALTER SYSTEM SET shared_server_sessions = 30 SCOPE = memory;

SHOW PARAMETER shared_servers;
SHOW PARAMETER max_shared_servers;
SHOW PARAMETER dispatchers;
SHOW PARAMETER shared_server_sessions;

ALTER SYSTEM REGISTER;
-- Esto fuerza al listener a actualizar su configuración con los nuevos servicios

HOST lsnrctl services

-- Ver servidores compartidos activos
-- SELECT name, status, requests, busy FROM v$shared_server;

-- Ver despachadores
-- SELECT name, status, accepted, refused FROM v$dispatcher;

-- Sesiones actuales
--SELECT server, COUNT(*) FROM v$session GROUP BY server;