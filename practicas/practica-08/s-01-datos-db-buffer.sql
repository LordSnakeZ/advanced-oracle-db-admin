-- Nombre: Santiago Sánchez Sánchez
-- Fecha: 24/03/2025
-- Descripcion: Creacion de 2 tablas con parametros acerca del DB Buffer Cache

CONNECT sys/system2@sssbda_s2 as sysdba;

CREATE TABLE santiago08.t01_db_buffer_cache (
    block_size NUMBER(15,2),
    current_size NUMBER(15,2),
    buffers NUMBER(15,2),
    target_buffers NUMBER(15,2),
    prev_size NUMBER(15,2),
    prev_buffers NUMBER(15,2),
    default_pool_size NUMBER(15,2)
);

INSERT INTO santiago08.t01_db_buffer_cache (
    block_size,
    current_size,
    buffers,
    target_buffers,
    prev_size,
    prev_buffers,
    default_pool_size
)
SELECT
    ROUND(block_size / 1024, 2),
    current_size,
    buffers,
    target_buffers,
    prev_size,
    prev_buffers,
    (SELECT value FROM v$parameter WHERE name = 'db_cache_size')
FROM v$buffer_pool;

-- Tabla #2

CREATE TABLE santiago08.t02_db_buffer_sysstats (
    db_blocks_gets_from_cache NUMBER(15,2),
    consistent_gets_from_cache NUMBER(15,2),
    physical_reads_cache NUMBER(15,2),
    cache_hit_ratio NUMBER(10,6)
);

INSERT INTO santiago08.t02_db_buffer_sysstats (
    db_blocks_gets_from_cache,
    consistent_gets_from_cache,
    physical_reads_cache,
    cache_hit_ratio
)
WITH stats AS (
    SELECT
        (SELECT value FROM v$sysstat WHERE name = 'db block gets from cache') AS db,
        (SELECT value FROM v$sysstat WHERE name = 'consistent gets from cache') AS con,
        (SELECT value FROM v$sysstat WHERE name = 'physical reads cache') AS phy
    FROM dual
)
SELECT
    db,
    con,
    phy,
    TRUNC(1- (phy / NULLIF((db + con), 0)), 6)
FROM stats;




