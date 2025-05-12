-- @Autor: Santiago Sánchez Sánchez
-- @Fecha creación: 26/02/2025
-- @Descripción: Crear una PDB (sssbda_s2) en Oracle, con usuario administrador y ubicación de archivos específica. Abre y guarda el estado de la PDB.

connect sys/system2 as sysdba;

create pluggable database sssbda_s2
  admin user sss_admin identified by sss_admin
  path_prefix = '/opt/oracle/oradata/FREE'
  file_name_convert = ('/pdbseed/', '/sssbda_s2/');

prompt abrir la PDB
alter pluggable database sssbda_s2 open;
Prompt guardar el estado de la PDB
alter pluggable database sssbda_s2 save state;
