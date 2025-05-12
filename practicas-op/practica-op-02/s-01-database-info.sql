--@Autor: Santiago Sánchez Sánchez
--@Fecha creación: 25/02/2025
--@Descripción: El código crea una tabla para almacenar información sobre la configuración de la base de datos, como el nombre de la instancia, tamaños de bloques y uso de espacio. Inserta datos usando vistas del sistema Oracle y luego muestra esta información con consultas SELECT.

connect sys/302405@sssbda_s1 as sysdba

create user santiago02op identified by santiago;

alter user santiago02op quota unlimited on users;

create table santiago02op.database_info(
  instance_name varchar2(16),
  db_domain varchar2(20),
  db_charset varchar2(15),
  sys_timestamp varchar2(40),
  timezone_offset varchar2(10),
  db_block_size_bytes number(5,0),
  os_block_size_bytes number(5,0),
  redo_block_size_bytes number(5,0),
  total_components number(5,0),
  total_components_mb number(10,2),
  max_component_name varchar2(30),
  max_component_desc varchar2(64),
  max_component_mb number(10,2)
);

insert into santiago02op.database_info(instance_name, db_domain, db_charset, sys_timestamp,
timezone_offset, db_block_size_bytes, os_block_size_bytes, redo_block_size_bytes, total_components, 
total_components_mb, max_component_name, max_component_desc, max_component_mb)
values ( 
  (select instance_name from v$instance),
  (select value from v$parameter where name = 'db_domain'),
  (select value from nls_database_parameters where parameter = 'NLS_CHARACTERSET'),
  (select to_char(systimestamp, 'YYYY-MM-DD HH24:MI:SS TZH:TZM') from dual),
  (select tz_offset((select sessiontimezone from dual)) from dual),
  (select value from v$parameter where name = 'db_block_size'),
  '4096',
  (select bytes / 1000000 from v$log where status = 'CURRENT' and rownum = 1),
  (select count(*) from v$sysaux_occupants),
  (select round(sum(space_usage_kbytes)/ 1024, 2) from v$sysaux_occupants),
  (select occupant_name from v$sysaux_occupants where space_usage_kbytes = (select max(space_usage_kbytes) from v$sysaux_occupants)),
  (select occupant_desc from v$sysaux_occupants where space_usage_kbytes = (select MAX(space_usage_kbytes) from v$sysaux_occupants)),
  (select round(max(space_usage_kbytes) / 1024, 2) from v$sysaux_occupants)
);

Prompt mostrando datos parte 1
set linesize window;
select instance_name,db_domain,db_charset,sys_timestamp,timezone_offset
from santiago02op.database_info;
Prompt mostrando datos parte 2
select db_block_size_bytes,os_block_size_bytes,redo_block_size_bytes,
total_components,total_components_mb
from santiago02op.database_info;
Prompt mostrando datos parte 3;
select max_component_name,max_component_desc,max_component_mb
from santiago02op.database_info;


