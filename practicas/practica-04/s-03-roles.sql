--@Autor: Santiago Sanchez Sanchez
--@Fecha creación: 24/02/2025
--@Descripción: Este script en SQL crea dos usuarios (santiago04_dev_01 y santiago04_dev_02) y un rol (p04_dev_role). Se asignan permisos iniciales al rol, incluyendo la capacidad de crear sesiones, tablas, vistas y procedimientos almacenados. Luego, se otorga este rol a los usuarios creados. Posteriormente, se revoca el permiso para crear procedimientos y se agrega el permiso para crear secuencias. Finalmente, se consulta la vista dba_role_privs para verificar los privilegios asignados a los usuarios.

connect sys/system1_p4 as sysdba;

alter session set container = sssbda_s1;

create user santiago04_dev_01 identified by santiago;

create user santiago04_dev_02 identified by santiago;

create role p04_dev_role;

grant create session, create table, create view, create procedure to p04_dev_role;

grant p04_dev_role to santiago04_dev_01;

grant p04_dev_role to santiago04_dev_02;

revoke create procedure from p04_dev_role;

grant create sequence to p04_dev_role;

col grantee format a30;
col granted_role format a50;
set linesize window;

select grantee, granted_role
from dba_role_privs
where grantee in ('SANTIAGO04_DEV_01','SANTIAGO04_DEV_02')
order by 1,2;

