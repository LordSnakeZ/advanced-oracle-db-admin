--@Autor: Santiago Sanchez Sanchez
--@Fecha creación: 24/02/2025
--@Descripción: Script para crear un usuario, asignar privilegios y almacenar información sobre la versión de la base de datos.
connect sys/system1_p4@sssbda_s1 as sysdba;

-- a. conectar como sysdba (ya se hace automáticamente si se ejecuta con privilegios sysdba)
-- esto puede ser gestionado al momento de ejecutar el script desde la línea de comandos o el cliente sql.

-- b. crear un usuario llamado santiago0401
create user santiago0401 identified by santiago;

-- asignar privilegios para crear sesiones y tablas
grant create session, create table to santiago0401;

-- asignar cuota ilimitada en el tablespace users
alter user santiago0401 quota unlimited on users;

-- c. crear la tabla t01_db_version con los datos de la vista product_component_version
-- esta tabla debe pertenecer al esquema del usuario santiago0401
create table santiago0401.t01_db_version as
select product, version, version_full
from product_component_version;

-- d. consultar los datos de la tabla para verificar los resultados
select * from santiago0401.t01_db_version;
