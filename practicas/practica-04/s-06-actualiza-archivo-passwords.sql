--@Autor: Santiago Sanchez Sanchez
--@Fecha creación: 24/02/2025
--@Descripción: Este script realiza las siguientes acciones:
--    A. Actualiza el password del usuario SYS a su valor original.
--    B. Reasigna los privilegios de autenticación a los usuarios previamente creados 
--       (SANTIAGO0402, SANTIAGO0403, SANTIAGO0404) para que puedan autenticarse correctamente.
--    C. Verifica que el archivo de contraseñas contiene 4 usuarios mediante una consulta 
--       a la vista v$pwfile_users: SYS y los tres usuarios mencionados.

connect sys/Hola1234* as sysdba;

alter user sys identified by 302405 container=all;

alter session set container = sssbda_s1;

grant sysdba to santiago0402;

grant sysoper to santiago0403;

grant sysbackup to santiago0404;

col username format a20
select username,sysdba,sysoper,sysbackup,syskm,sysdg,con_id
from v$pwfile_users;

