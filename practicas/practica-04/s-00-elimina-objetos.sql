--@Autor: Santiago Sanchez Sanchez
--@Fecha creación: 24/02/2025
--@Descripción: Este script realiza la limpieza de objetos en la base de datos antes de realizar una nueva configuración.
-- La tarea principal es eliminar (DROP) varios usuarios y roles de la base de datos si ya existen, 
-- utilizando la cláusula CASCADE para eliminar también los objetos dependientes de estos usuarios y roles.



--Observar que se requiere conectarse a <iniciales>bda_s1
connect sys/302405@sssbda_s1 as sysdba
prompt realizando limpieza de objetos

drop user if exists santiago0401 cascade;
drop user if exists santiago0402 cascade;
drop user if exists santiago0403 cascade;
drop user if exists santiago0404 cascade;
drop user if exists santiago04_dev_01 cascade;
drop user if exists santiago04_dev_02 cascade;
drop user if exists santiago04_admin cascade;

--roles
drop role if exists p04_dev_role;


