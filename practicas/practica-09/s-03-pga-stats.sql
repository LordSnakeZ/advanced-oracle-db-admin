CONNECT sys/system2 AS SYSDBA

-- Primero eliminar la tabla si ya existe
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE c##santiago09.t04_pga_stats';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

-- Crear tabla para estadísticas de PGA
CREATE TABLE c##santiago09.t04_pga_stats (
    max_pga_mb NUMBER(10,2),
    pga_target_param_calc_mb NUMBER(10,2),
    pga_target_param_actual_mb NUMBER(10,2),
    pga_total_actual_mb NUMBER(10,2),
    pga_in_use_actual_mb NUMBER(10,2),
    pga_free_memory_mb NUMBER(10,2),
    pga_process_count NUMBER,
    pga_cache_hit_percentage NUMBER(5,2)
);

-- Bloque PL/SQL para insertar datos correctamente
DECLARE
    v_cache_hit NUMBER;
    v_total_pga NUMBER;
BEGIN
    -- Calcular el porcentaje de cache hit
    SELECT value INTO v_cache_hit 
    FROM v$pgastat 
    WHERE name = 'cache hit percentage' AND con_id = 0;
    
    SELECT value INTO v_total_pga
    FROM v$pgastat
    WHERE name = 'total PGA allocated' AND con_id = 0;
    
    -- Insertar estadísticas de PGA
    INSERT INTO c##santiago09.t04_pga_stats
    SELECT 
        (SELECT ROUND(value/1048576, 2) FROM v$pgastat WHERE name = 'maximum PGA allocated' AND con_id = 0),
        (SELECT ROUND(value/1048576, 2) FROM v$pgastat WHERE name = 'total PGA allocated' AND con_id = 0),
        (SELECT ROUND(value/1048576, 2) FROM v$parameter WHERE name = 'pga_aggregate_target'),
        (SELECT ROUND(value/1048576, 2) FROM v$pgastat WHERE name = 'total PGA allocated' AND con_id = 0),
        (SELECT ROUND(value/1048576, 2) FROM v$pgastat WHERE name = 'total PGA inuse' AND con_id = 0),
        (SELECT ROUND(value/1048576, 2) FROM v$pgastat WHERE name = 'total freeable PGA memory' AND con_id = 0),
        (SELECT value FROM v$pgastat WHERE name = 'process count' AND con_id = 0),
        ROUND(100 * (1 - v_cache_hit/NULLIF(v_total_pga, 0)), 2)
    FROM dual;
    
    COMMIT;
END;
/

-- Mostrar resultados
SELECT * FROM c##santiago09.t04_pga_stats;

-- Respuestas a preguntas
PROMPT P6: ¿Por qué el valor de la columna pga_target_param_actual_mb es cero, y el valor de la
PROMPT       columna pga_target_param_calc_mb es mayor a cero?
PROMPT R6: Porque pga_target_param_actual_mb viene de v$parameter (parámetro configurado)
PROMPT       mientras que pga_target_param_calc_mb viene de v$pgastat (memoria realmente asignada).
PROMPT       Si pga_aggregate_target=0, Oracle usa Automatic Memory Management (AMM) y asigna
PROMPT       memoria dinámicamente según necesidad.

PROMPT
PROMPT P7: Si se decidiera configurar manualmente la cantidad total de memoria de la PGA, ¿qué
PROMPT       columna y valor de la consulta anterior serían los adecuados?
PROMPT R7: Se debería usar el valor de pga_target_param_calc_mb como referencia, ya que
PROMPT       representa la memoria que Oracle ha calculado como necesaria basada en la carga real.
PROMPT       Este valor podría asignarse al parámetro pga_aggregate_target.

