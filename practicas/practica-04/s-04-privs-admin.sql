--@Autor: Santiago Sanchez Sanchez
--@Fecha creación: 24/02/2025
--@Descripción: <Descripción corta del script>

connect sys/system1_p4@sssbda_s1 as sysdba;

create user santiago0402 identified by santiago;

create user santiago0403 identified by santiago;

create user santiago0404 identified by santiago;

grant create session to santiago0402;

grant create session to santiago0403;

grant create session to santiago0404;

grant sysdba to santiago0402;

grant sysoper to santiago0403;

grant sysbackup to santiago0404;

create user santiago04_admin identified by santiago;

grant create session, create table to santiago04_admin;

alter user santiago04_admin quota unlimited on users;

create table santiago04_admin.t01_bitacora(
  id number not null,
  usuario varchar2(30) not null,
  esquema varchar2(30) not null,
  rol varchar2(20) not null,
  fecha_registro date not null
);

connect santiago04_admin/santiago@sssbda_s1;

grant insert on t01_bitacora to santiago0402;

grant insert on t01_bitacora to santiago0403;

grant insert on t01_bitacora to santiago0404;

grant insert on t01_bitacora to public;

grant insert on t01_bitacora to sysbackup;

connect santiago0402/santiago@sssbda_s1
insert into santiago04_admin.t01_bitacora(
  id, usuario, esquema, rol, fecha_registro)
values(1,
  sys_context('USERENV','CURRENT_USER'),
  sys_context('USERENV','CURRENT_SCHEMA'),
  'ordinario',
  sysdate
);

connect santiago0402/santiago@sssbda_s1 as sysdba
insert into santiago04_admin.t01_bitacora(
id, usuario,esquema,rol,fecha_registro)
values( 2,
sys_context('USERENV','CURRENT_USER'),
sys_context('USERENV','CURRENT_SCHEMA'),
'sysdba',
sysdate
);

connect santiago0403/santiago@sssbda_s1 
insert into santiago04_admin.t01_bitacora(
  id, usuario, esquema, rol, fecha_registro)
values(3,
  sys_context('USERENV','CURRENT_USER'),
  sys_context('USERENV','CURRENT_SCHEMA'),
  'ordinario',
  sysdate
);

connect santiago0403/santiago@sssbda_s1 as sysoper
insert into santiago04_admin.t01_bitacora(
id, usuario,esquema,rol,fecha_registro)
values( 4,
sys_context('USERENV','CURRENT_USER'),
sys_context('USERENV','CURRENT_SCHEMA'),
'sysoper',
sysdate
);

connect santiago0404/santiago@sssbda_s1 
insert into santiago04_admin.t01_bitacora(
  id, usuario, esquema, rol, fecha_registro)
values(5,
  sys_context('USERENV','CURRENT_USER'),
  sys_context('USERENV','CURRENT_SCHEMA'),
  'ordinario',
  sysdate
);

connect santiago0404/santiago@sssbda_s1 as sysbackup
insert into santiago04_admin.t01_bitacora(
id, usuario,esquema,rol,fecha_registro)
values( 6,
sys_context('USERENV','CURRENT_USER'),
sys_context('USERENV','CURRENT_SCHEMA'),
'sysbackup',
sysdate
);


