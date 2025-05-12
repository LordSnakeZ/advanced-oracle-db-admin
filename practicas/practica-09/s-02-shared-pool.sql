CONNECT sys/system2 AS SYSDBA

-- Crear la tabla para almacenar la información del Shared Pool
CREATE TABLE c##santiago09.t02_shared_pool (
    shared_pool_param_mb NUMBER,
    shared_pool_sga_info_mb NUMBER,
    resizeable VARCHAR2(3),
    shared_pool_component_total NUMBER,
    shared_pool_free_memory NUMBER
);

-- Insertar datos en la tabla
INSERT INTO c##santiago09.t02_shared_pool
SELECT 
    (SELECT value/1048576 FROM v$parameter WHERE name = 'shared_pool_size') AS shared_pool_param_mb,
    (SELECT bytes/1024/1024 FROM v$sgainfo WHERE name = 'Shared Pool Size') AS shared_pool_sga_info_mb,
    (SELECT resizeable FROM v$sgainfo WHERE name = 'Shared Pool Size') AS resizeable,
    (SELECT COUNT(*) FROM v$sgastat WHERE pool = 'shared pool') AS shared_pool_component_total,
    (SELECT bytes/1024/1024 FROM v$sgastat WHERE name = 'free memory' AND pool = 'shared pool') AS shared_pool_free_memory
FROM dual;

COMMIT;

-- Mostrar los resultados
SELECT * FROM c##santiago09.t02_shared_pool;

-- Respuestas a las preguntas
PROMPT P3: ¿Por qué razón el valor de la columna shared_pool_param_mb es cero?
PROMPT R3: Porque en versiones recientes de Oracle (11g en adelante), el parámetro shared_pool_size
PROMPT       puede estar en 0 cuando se usa Automatic Shared Memory Management (ASMM) o
PROMPT       Automatic Memory Management (AMM), donde Oracle gestiona automáticamente este espacio.

PROMPT
PROMPT P4: ¿Por qué razón el número de componentes que hacen uso del shared pool es relativamente alto?
PROMPT R4: El shared pool contiene múltiples estructuras como SQL áreas, diccionario de datos,
PROMPT       procedimientos almacenados compilados, estructuras de control, etc. Cada consulta SQL,
PROMPT       cursor, objeto del diccionario de datos y otros elementos crean componentes individuales
PROMPT       en el shared pool, lo que explica el alto número.

-- D. Crear tabla para estadísticas del Library Cache
CREATE TABLE c##santiago09.t03_library_cache_hits (
    id NUMBER,
    reloads NUMBER,
    invalidations NUMBER,
    pins NUMBER,
    pinhits NUMBER,
    pinhitratio NUMBER
);

-- Insertar datos iniciales (id=1)
INSERT INTO c##santiago09.t03_library_cache_hits
SELECT 1, reloads, invalidations, pins, pinhits, pinhitratio
FROM v$librarycache
WHERE namespace='SQL AREA';

COMMIT;

-- E. Crear tabla test_orden_compra
CREATE TABLE c##santiago09.test_orden_compra (id NUMBER);

-- F. Bloque PL/SQL con consultas estáticas (sin placeholders)
PROMPT Ejecutando 50,000 consultas con sentencias SQL estáticas...
SET TIMING ON

DECLARE
    v_orden_compra c##santiago09.test_orden_compra%ROWTYPE;
BEGIN
    FOR i IN 1..50000 LOOP
        BEGIN
            EXECUTE IMMEDIATE 
                'SELECT * FROM c##santiago09.test_orden_compra WHERE id='||i 
            INTO v_orden_compra;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
    END LOOP;
END;
/

SET TIMING OFF

-- G. Capturar estadísticas después de consultas estáticas (id=2)
PROMPT Capturando estadísticas después de consultas estáticas...
INSERT INTO c##santiago09.t03_library_cache_hits
SELECT 2, reloads, invalidations, pins, pinhits, pinhitratio
FROM v$librarycache
WHERE namespace='SQL AREA';

COMMIT;

-- H. Reiniciar instancia
PROMPT Reiniciando instancia...
SHUTDOWN IMMEDIATE;
STARTUP;

-- I. Capturar estadísticas después de reinicio (id=3)
PROMPT Capturando estadísticas después de reinicio...
INSERT INTO c##santiago09.t03_library_cache_hits
SELECT 3, reloads, invalidations, pins, pinhits, pinhitratio
FROM v$librarycache
WHERE namespace='SQL AREA';

COMMIT;

-- J. Bloque PL/SQL con placeholders (consultas optimizadas)
PROMPT Ejecutando 50,000 consultas con placeholders...
SET TIMING ON

DECLARE
    v_orden_compra c##santiago09.test_orden_compra%ROWTYPE;
    v_sql VARCHAR2(100) := 'SELECT * FROM c##santiago09.test_orden_compra WHERE id = :id';
BEGIN
    FOR i IN 1..50000 LOOP
        BEGIN
            EXECUTE IMMEDIATE v_sql INTO v_orden_compra USING i;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
    END LOOP;
END;
/

SET TIMING OFF

-- K. Capturar estadísticas después de consultas con placeholders (id=4)
PROMPT Capturando estadísticas después de consultas con placeholders...
INSERT INTO c##santiago09.t03_library_cache_hits
SELECT 4, reloads, invalidations, pins, pinhits, pinhitratio
FROM v$librarycache
WHERE namespace='SQL AREA';

COMMIT;

-- L. Mostrar resultados finales
PROMPT Resultados finales:
SELECT * FROM c##santiago09.t03_library_cache_hits
ORDER BY id;