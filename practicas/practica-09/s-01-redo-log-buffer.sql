
CONNECT sys/system2 as sysdba;

CREATE TABLE c##santiago09.t01_redo_log_buffer (
    redo_buffer_size_param_mb NUMBER,
    redo_buffer_sga_info_mb NUMBER,
    resizeable VARCHAR(2)
);

INSERT INTO c##santiago09.t01_redo_log_buffer
SELECT
    (SELECT value/1024/1024 FROM v$parameter WHERE name = 'log_buffer'),
    (SELECT bytes/1024/1024 FROM v$sgainfo WHERE name = 'Redo Buffers'),
    (SELECT resizeable FROM v$sgainfo WHERE name = 'Redo Buffers')
FROM dual;

PROMPT Tabla creada!!!
PROMPT


