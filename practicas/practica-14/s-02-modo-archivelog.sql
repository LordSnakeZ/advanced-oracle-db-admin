--@Autor: Sanchez Sanchez Santiago
--@Fecha creación: 12/05/2025
--@Descripción: Activación del modo Archive Log con verificación integrada

-- Conectar como sysdba
CONNECT sys/system2 AS sysdba;

-- Crear el PFILE inicial
CREATE PFILE='/opt/oracle/product/23ai/dbhomeFree/dbs/p14_initfree.ora' FROM SPFILE;

-- Configurar parámetros de Archive Log
ALTER SYSTEM SET log_archive_format='arch_free_%t_%s_%r.arc' SCOPE=SPFILE;
ALTER SYSTEM SET log_archive_dest_1='LOCATION=/unam/bda/archivelogs/FREE/disk_a MANDATORY' SCOPE=SPFILE;
ALTER SYSTEM SET log_archive_dest_2='LOCATION=/unam/bda/archivelogs/FREE/disk_b OPTIONAL' SCOPE=SPFILE;
ALTER SYSTEM SET log_archive_min_succeed_dest=1 SCOPE=SPFILE;
ALTER SYSTEM SET log_archive_max_processes=2 SCOPE=SPFILE;

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
ARCHIVE LOG LIST;

-- Crear PFILE con la nueva configuración
CREATE PFILE='/opt/oracle/product/23ai/dbhomeFree/dbs/p14_2_initfree.ora' FROM SPFILE;

-- Forzar archivado del log actual
ALTER SYSTEM ARCHIVE LOG CURRENT;

-- Mostrar estado de Archive Log (comando directo de SQL*Plus)
ARCHIVE LOG LIST;

SET LINESIZE WINDOW

SELECT 
    name AS "Nombre (Ruta absoluta)",
    dest_id AS "Número de destino",
    sequence# AS "Número de secuencia",
    status AS "Status",
    archived AS "Archivado",
    completion_time AS "Fecha de completado",
    blocks AS "Bloques",
    block_size AS "Tamaño de bloque"
FROM v$archived_log
ORDER BY sequence# DESC;