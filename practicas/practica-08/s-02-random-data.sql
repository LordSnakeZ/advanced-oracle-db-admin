connect santiago08/santiago08@sssbda_s2;

prompt Creando tabla t03_random_data
create table t03_random_data(
    id number,
    random_string varchar2(1024)
);

prompt Creando tabla t04_db_buffer_status
create table t04_db_buffer_status(
    id number generated always as identity,
    total_bloques number,
    status varchar2(10),
    evento varchar2(30)
);

prompt Cargando datos en la tabla t03_random_data
DECLARE
    v_rows NUMBER := 10000;
    v_query VARCHAR2(100) := 'INSERT INTO t03_random_data(id, random_string) VALUES (:ph1, :ph2)';
BEGIN
    FOR v_index IN 1..v_rows LOOP
        EXECUTE IMMEDIATE v_query
        USING v_index, dbms_random.string('P',1016);
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se insertaron '||v_rows||' registros en t03_random_data');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar datos: '||SQLERRM);
        ROLLBACK;
END;
/

prompt Entrando a sesión con el usuario sys
connect sys/system2@sssbda_s2 as sysdba;

prompt Verificando existencia de la tabla
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM dba_tables 
    WHERE table_name = 'T03_RANDOM_DATA' AND owner = 'SANTIAGO08';
    
    DBMS_OUTPUT.PUT_LINE('Tabla encontrada: '||CASE WHEN v_count > 0 THEN 'SÍ' ELSE 'NO' END);
END;
/

prompt Insertando registro en t04_db_buffer_status después de la carga
DECLARE
    v_objd NUMBER;
BEGIN
    SELECT data_object_id INTO v_objd 
    FROM dba_objects 
    WHERE object_name='T03_RANDOM_DATA' AND owner = 'SANTIAGO08';
    
    INSERT INTO santiago08.t04_db_buffer_status (total_bloques, status, evento)
    SELECT COUNT(*) total_bloques, status, 'Después de carga'
    FROM v$bh
    WHERE objd = v_objd
    GROUP BY status;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Registro insertado en t04_db_buffer_status (después de carga)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en inserción después de carga: '||SQLERRM);
        ROLLBACK;
END;
/

prompt Vaciando el buffer caché
ALTER SYSTEM FLUSH BUFFER_CACHE;
DBMS_OUTPUT.PUT_LINE('Buffer cache vaciado');

prompt Insertando registro en t04_db_buffer_status después de vaciar db buffer
DECLARE
    v_objd NUMBER;
BEGIN
    SELECT data_object_id INTO v_objd 
    FROM dba_objects 
    WHERE object_name='T03_RANDOM_DATA' AND owner = 'SANTIAGO08';
    
    INSERT INTO santiago08.t04_db_buffer_status (total_bloques, status, evento)
    SELECT COUNT(*) total_bloques, status, 'Después de vaciar db buffer'
    FROM v$bh
    WHERE objd = v_objd
    GROUP BY status;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Registro insertado en t04_db_buffer_status (después de vaciar buffer)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en inserción después de vaciar buffer: '||SQLERRM);
        ROLLBACK;
END;
/

prompt Reiniciando instancia
shutdown immediate;
startup;
DBMS_OUTPUT.PUT_LINE('Instancia reiniciada');

prompt Insertando registro en t04_db_buffer_status después del reinicio
DECLARE
    v_objd NUMBER;
BEGIN
    SELECT data_object_id INTO v_objd 
    FROM dba_objects 
    WHERE object_name='T03_RANDOM_DATA' AND owner = 'SANTIAGO08';
    
    INSERT INTO santiago08.t04_db_buffer_status (total_bloques, status, evento)
    SELECT COUNT(*) total_bloques, status, 'Después del reinicio'
    FROM v$bh
    WHERE objd = v_objd
    GROUP BY status;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Registro insertado en t04_db_buffer_status (después de reinicio)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en inserción después de reinicio: '||SQLERRM);
        ROLLBACK;
END;
/

prompt Modificando un registro aleatorio de la tabla t03_random_data
DECLARE
    v_id NUMBER;
BEGIN
    SELECT 1 INTO v_id FROM dual;
    
    UPDATE santiago08.t03_random_data
    SET random_string = UPPER(random_string)
    WHERE id = v_id;
    
    DBMS_OUTPUT.PUT_LINE('Registro modificado: ID='||v_id);
    
    -- Insertar estado después de modificación
    DECLARE
        v_objd NUMBER;
    BEGIN
        SELECT data_object_id INTO v_objd 
        FROM dba_objects 
        WHERE object_name='T03_RANDOM_DATA' AND owner = 'SANTIAGO08';
        
        INSERT INTO santiago08.t04_db_buffer_status (total_bloques, status, evento)
        SELECT COUNT(*) total_bloques, status, 'Después del cambio 1'
        FROM v$bh
        WHERE objd = v_objd
        GROUP BY status;
        
        DBMS_OUTPUT.PUT_LINE('Registro insertado en t04_db_buffer_status (después de cambio)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al insertar después de cambio: '||SQLERRM);
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al modificar registro: '||SQLERRM);
END;
/

prompt - En otra terminal crear una sesión con el usuario <nombre>08
prompt - Consultar el registro modificado 3 veces
prompt - Al terminar de realizar las 3 consultas salir de sesión.
pause "select * from t03_random_data where id =<id>", [enter] para continuar
prompt Modificando un registro aleatorio de la tabla t03_random_data

BEGIN
    DECLARE
        v_objd NUMBER;
    BEGIN
        SELECT data_object_id INTO v_objd 
        FROM dba_objects 
        WHERE object_name='T03_RANDOM_DATA' AND owner = 'SANTIAGO08';
        
        INSERT INTO santiago08.t04_db_buffer_status (total_bloques, status, evento)
        SELECT COUNT(*) total_bloques, status, 'Después de 3 consultas'
        FROM v$bh
        WHERE objd = v_objd
        GROUP BY status;
        
        DBMS_OUTPUT.PUT_LINE('Registro insertado en t04_db_buffer_status (después de 3 consultas)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al insertar después de 3 consultas: '||SQLERRM);
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al modificar registro: '||SQLERRM);
END;
/
prompt Mostrando los datos finales
SELECT * FROM santiago08.t04_db_buffer_status;