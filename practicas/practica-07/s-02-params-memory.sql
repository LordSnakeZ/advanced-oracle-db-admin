--@Autor: Santiago Sánchez Sánchez
--@Fecha creación: 10/03/2025
--@Descripción: Recuperación de los parametros de la CDB a partir de la memoria
--              de las áreas de memoria de la instancia.

connect sys/system2 as sysdba;
prompt Creando pfile a partir de los parámetros configurados en memoria.
create pfile='/unam/bda/practicas/practica-07/e-03-param-memory.txt'
from memory;

