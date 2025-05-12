--@Autor: Santiago Sánchez Sánchez
--@Fecha creación: 10/03/2025
--@Descripción: <Descripción corta del script>

connect sys/system2 as sysdba;

alter session set nls_date_format="dd/mm/yyyy hh24:mi:ss";

alter system set db_writer_processes=2 scope=spfile;

alter system set log_buffer=10485760 scope=spfile;

alter system set db_files=250 container=current scope=spfile;

alter session set container=sssbda_s2;

alter system set db_files=300 container=current scope=spfile;

alter session set container=CDB$ROOT;

alter system set dml_locks=2500 scope=spfile;

alter system set transactions=600 scope=spfile;

alter session set hash_area_size=2097152;
alter system set hash_area_size=2097152 scope=spfile;

alter session set container=sssbda_s2;

ALTER SYSTEM SET sort_area_size = 1048576 SCOPE=SPFILE;

alter session set container=CDB$ROOT;

alter system set sql_trace=true scope=memory;

alter system set optimizer_mode=FIRST_ROWS_100 scope=both;

alter session set cursor_invalidation=DEFERRED;


--parámetros modificados en la sesión del usuario
drop table if exists c##santiago07.t03_update_param_session;
  create table c##santiago07.t03_update_param_session as
    select name,value
    from v$parameter
    where name in (
      'cursor_invalidation','optimizer_mode',
      'sql_trace','sort_area_size','hash_area_size','nls_date_format',
      'db_writer_processes','db_files','dml_locks','log_buffer','transactions'
    )
  and value is not null;

drop table if exists c##santiago07.t04_update_param_instance;
  create table c##santiago07.t04_update_param_instance as
    select name,value,con_id
    from v$system_parameter
    where name in (
      'cursor_invalidation','optimizer_mode',
      'sql_trace','sort_area_size','hash_area_size','nls_date_format',
      'db_writer_processes','db_files','dml_locks','log_buffer','transactions'
    )
  and value is not null;

drop table if exists c##santiago07.t05_update_param_spfile;
  create table c##santiago07.t05_update_param_spfile as
    select name,value
    from v$spparameter
    where name in (
      'cursor_invalidation','optimizer_mode',
      'sql_trace','sort_area_size','hash_area_size','nls_date_format',
      'db_writer_processes','db_files','dml_locks','log_buffer','transactions'
    )
  and value is not null;
