#!/bin/bash

# @Autor Santiago Sánchez Sánchez
# @Fecha 25/02/2025
# @Descripcion Creación de un PFILE

echo "Paso #1: Creando un PFILE básico."

export ORACLE_SID=free

pfile=$ORACLE_HOME/dbs/init${ORACLE_SID}.ora

if [ -f "${pfile}" ]; then
  read -p "El archivo ${pfile} ya existe, [enter] para sobrescribir"
fi;

echo \
"db_name=${ORACLE_SID}
memory_target=768M
control_files=(
  /unam/bda/disks/d01/app/oracle/oradata/${ORACLE_SID^^}/control01.ctl,
  /unam/bda/disks/d02/app/oracle/oradata/${ORACLE_SID^^}/control02.ctl,
  /unam/bda/disks/d03/app/oracle/oradata/${ORACLE_SID^^}/control03.ctl
)
db_domain=fi.unam
enable_pluggable_database=true
">$pfile

echo "Ready"
echo "Comprobando la existencia y contenido del PFILE"
echo ""
cat ${pfile}

