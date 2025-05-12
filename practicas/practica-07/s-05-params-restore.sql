-- Conectar como SYSDBA
CONNECT sys/system2 AS sysdba;

PROMPT 1
ALTER SYSTEM RESET db_writer_processes;

PROMPT 2
ALTER SYSTEM RESET log_buffer;

PROMPT 3
ALTER SYSTEM RESET db_files;

PROMPT 4
ALTER SESSION SET CONTAINER=sssbda_s2;

PROMPT 5
ALTER SYSTEM RESET sort_area_size;

PROMPT 6
ALTER SYSTEM RESET  db_files;

ALTER SESSION SET CONTAINER=CDB$ROOT;

PROMPT 7
ALTER SYSTEM RESET dml_locks;

PROMPT 8
ALTER SYSTEM RESET transactions;
ALTER SYSTEM RESET hash_area_size;
ALTER SYSTEM RESET optimizer_mode;

PROMPT Reiniciando instancia posterior a la restauración de parámetros
PAUSE  Presionar ENTER para continuar

SHUTDOWN IMMEDIATE

PROMPT shutdown completo, iniciando..

STARTUP

PROMPT Listo!

