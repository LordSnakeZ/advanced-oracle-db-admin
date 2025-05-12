-- A. Conectarse como SYSDBA en CDB$ROOT
CONNECT sys/system2 AS SYSDBA;

-- B. Iniciar el connection pool por defecto
BEGIN
  DBMS_CONNECTION_POOL.START_POOL();
  DBMS_OUTPUT.PUT_LINE('Connection pool SYS_DEFAULT_CONNECTION_POOL iniciado');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al iniciar pool: ' || SQLERRM);
END;
/

-- C. Configurar tamaño del pool (N entre 30 y 50)
BEGIN
  -- Configurar tamaño máximo
  DBMS_CONNECTION_POOL.ALTER_PARAM('', 'MAXSIZE', '50');
  
  -- Configurar tamaño mínimo (usando N=35 como ejemplo)
  DBMS_CONNECTION_POOL.ALTER_PARAM('', 'MINSIZE', '35');
  
  DBMS_OUTPUT.PUT_LINE('Configuración de tamaño del pool completada');
  DBMS_OUTPUT.PUT_LINE(' - MAXSIZE: 50');
  DBMS_OUTPUT.PUT_LINE(' - MINSIZE: 35');
END;
/

-- D. Configurar parámetros de tiempo
BEGIN
  -- INACTIVITY_TIMEOUT: 1800 segundos (30 minutos)
  DBMS_CONNECTION_POOL.ALTER_PARAM('', 'INACTIVITY_TIMEOUT', '1800');
  
  -- MAX_THINK_TIME: 1800 segundos (30 minutos)
  DBMS_CONNECTION_POOL.ALTER_PARAM('', 'MAX_THINK_TIME', '1800');
  
  DBMS_OUTPUT.PUT_LINE('Configuración de tiempos completada');
  DBMS_OUTPUT.PUT_LINE(' - INACTIVITY_TIMEOUT: 1800 segundos');
  DBMS_OUTPUT.PUT_LINE(' - MAX_THINK_TIME: 1800 segundos');
END;
/

COMMIT;
PROMPT Configuración del Resident Connection Pool completada exitosamente