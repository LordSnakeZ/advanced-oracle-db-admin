CONNECT sys/system2@sssbda_s2 AS sysdba;

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';


-- DROP TABLE santiago04op.t01_sga_components;

CREATE TABLE santiago04op.t01_sga_components (
    memory_target_param NUMBER(10,2),
    fixed_size          NUMBER(10,2),
    variable_size       NUMBER(10,2),
    database_buffers    NUMBER(10,2),
    redo_buffers        NUMBER(10,2),
    total_sga           NUMBER(10,2)
);


INSERT INTO santiago04op.t01_sga_components (
  memory_target_param,
  fixed_size,
  variable_size,
  database_buffers,
  redo_buffers,
  total_sga
)
SELECT
  ROUND((SELECT value FROM v$parameter WHERE name = 'memory_target') / 1024 / 1024, 2),
  ROUND((SELECT value FROM v$SGA WHERE name = 'Fixed Size') / 1024 / 1024, 2),
  ROUND((SELECT value FROM v$SGA WHERE name = 'Variable Size') / 1024 / 1024, 2),
  ROUND((SELECT value FROM v$SGA WHERE name = 'Database Buffers') / 1024 / 1024, 2),
  ROUND((SELECT value FROM v$SGA WHERE name = 'Redo Buffers') / 1024 / 1024, 2),
  ROUND((SELECT SUM(value) FROM v$sga) / 1024 / 1024, 2)
FROM dual;


-- DROP TABLE santiago04op.t02_sga_dynamic_components;

CREATE TABLE santiago04op.t02_sga_dynamic_components (
    component_name VARCHAR2(64),
    current_size_mb NUMBER(10,2),
    operation_count     NUMBER(10,0),
    last_operation_type VARCHAR2(13),
    last_operation_time DATE
);

INSERT INTO santiago04op.t02_sga_dynamic_components (
    component_name,
    current_size_mb,
    operation_count,
    last_operation_type,
    last_operation_time
)
SELECT
    component,
    ROUND(current_size / 1024 / 1024, 2),
    oper_count,
    last_oper_type,
    last_oper_time
FROM v$sga_dynamic_components ORDER BY current_size DESC;


-- DROP TABLE santiago04op.t03_sga_max_dynamic_component;

CREATE TABLE santiago04op.t03_sga_max_dynamic_component (
    component_name  VARCHAR2(64),
    current_size_mb NUMBER(10,2)
);


INSERT INTO santiago04op.t03_sga_max_dynamic_component (
    component_name,
    current_size_mb
)
SELECT
    component,
    ROUND(current_size / 1024 / 1024, 2) AS current_size_mb 
FROM v$sga_dynamic_components ORDER BY current_size DESC FETCH FIRST 1 ROW ONLY;


-- DROP TABLE santiago04op.t04_sga_min_dynamic_component;

CREATE TABLE santiago04op.t04_sga_min_dynamic_component (
    component_name  VARCHAR2(64),
    current_size_mb NUMBER(10,2)
);

INSERT INTO santiago04op.t04_sga_min_dynamic_component (
    component_name,
    current_size_mb
)
SELECT
    component,
    ROUND(current_size / 1024 / 1024, 2) AS current_size_mb
FROM v$sga_dynamic_components ORDER BY current_size ASC FETCH FIRST 1 ROW ONLY;


-- DROP TABLE santiago04op.t05_sga_memory_info;

CREATE TABLE santiago04op.t05_sga_memory_info (
    name            VARCHAR2(64),
    current_size_mb NUMBER(10,2)
);

INSERT INTO santiago04op.t05_sga_memory_info (
    name,
    current_size_mb
)
SELECT
    name,
    ROUND(bytes / 1024 / 1024, 2)
FROM v$sgainfo WHERE name IN ('Maximum SGA Size', 'Free SGA Memory Available');


-- DROP TABLE santiago04op.t06_sga_resizeable_components;

CREATE TABLE santiago04op.t06_sga_resizeable_components (
    name VARCHAR2(64)
);

INSERT INTO santiago04op.t06_sga_resizeable_components (
     name
)
SELECT name FROM v$sgainfo WHERE RESIZEABLE = 'Yes';

COMMIT;

-- DROP TABLE santiago04op.t07_sga_resize_ops;

CREATE TABLE santiago04op.t07_sga_resize_ops (
    component       VARCHAR2(64),
    oper_type       VARCHAR2(13),
    parameter       VARCHAR2(80),
    initial_size_mb NUMBER(12, 2),
    target_size_mb  NUMBER(12, 2),
    final_size_mb   NUMBER(12, 2),
    increment_mb    NUMBER(12, 2),
    status          VARCHAR2(9),
    start_time      DATE,
    end_time        DATE
);

INSERT INTO santiago04op.t07_sga_resize_ops (
    component,
    oper_type,
    parameter,
    initial_size_mb,
    target_size_mb,
    final_size_mb,
    increment_mb,
    status,
    start_time,
    end_time
)
SELECT
    component,
    oper_type,
    parameter,
    initial_size,
    target_size,
    final_size,
    ROUND(final_size - initial_size, 2),
    status,
    start_time,
    end_time
FROM v$sga_resize_ops
WHERE component IN ('DEFAULT buffer cache', 'Shared IO Pool', 'java pool', 'large pool', 'shared pool')
ORDER BY component, end_time;

