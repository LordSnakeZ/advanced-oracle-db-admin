--@Autor: Santiago Sánchez Sánchez
--@Fecha creación: 10/03/2025
--@Descripción: Crea un usuario a nivel de CDB, le otorga permisos de creación
--              de tablas y sesiones, finalmente crea una tabla para guardar para
--              guardar una virtualización de la vists v$spparameter.

connect sys/system2 as sysdba;

create user c##santiago07 identified by santiago quota unlimited on users;

grant create session, create table to c##santiago07;

create table c##santiago07.t01_spfile_parameters as
  select name,value,con_id
  from v$spparameter
  where value is not null;

col name format a30
col value format a15
set linesize window

prompt Mostrando contenido de la tabla
select * from c##santiago07.t01_spfile_parameters;

create table c##santiago07.t02_mem_parameters as
  select num,name,value,default_value,isses_modifiable as is_session_modifiable,
    issys_modifiable as is_system_modifiable,ispdb_modifiable,con_id
  from v$system_parameter
  where name in (
    'cursor_invalidation','optimizer_mode',
    'sql_trace','sort_area_size','hash_area_size','nls_date_format',
    'db_writer_processes','db_files','dml_locks','log_buffer','transactions'
  );

col name format a30
col value format a15
col default_value format a15
set linesize window

Prompt mostrando contenido de la tabla
select * from c##santiago07.t02_mem_parameters;
