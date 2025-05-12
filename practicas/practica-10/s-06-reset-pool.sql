CONNECT sys/system2@free_dedicated AS SYSDBA;

-- Detener y resetear el pool
BEGIN
  DBMS_CONNECTION_POOL.STOP_POOL();
  DBMS_CONNECTION_POOL.RESTORE_DEFAULTS();
  DBMS_OUTPUT.PUT_LINE('Pool de conexiones detenido y configurado a valores por defecto');
END;
/

COMMIT;
PROMPT Configuración del pool restablecida exitosamente