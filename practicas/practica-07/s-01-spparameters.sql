--@Autor: Santiago Sánchez Sánchez
--@Fecha creación: 10/03/2025
--@Descripción: Script que almacena el historial de comandos que se
--              genera en spool para recuperar los valores perdidos 
--              de SPFILE a partir de una consulta SQL a v$spparameter.

connect sys/system2 as sysdba;

spool /unam/bda/practicas/practica-07/e-02-spparameter-view.txt

col name format a40
col value format a60
set linesize 150

select name,value
from v$spparameter
where value is not null;
spool off;
