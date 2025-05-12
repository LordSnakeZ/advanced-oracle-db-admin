# @Autor: Santiago Sánchez Sánchez
# @Fecha creación: 26/02/2025
# @Descripción: Configura directorios para Oracle (data files, control files, redo logs) en /opt/oracle y /unam/bda/disks, asigna permisos (750) y propiedad (oracle:oinstall), y verifica la creación.

cd /opt/oracle
mkdir -p oradata/${ORACLE_SID^^}
chown -R oracle:oinstall oradata
chmod -R 750 oradata

cd /opt/oracle/oradata/${ORACLE_SID^^}
mkdir pdbseed
chown oracle:oinstall pdbseed
chmod 750 pdbseed

cd /unam/bda/disks/d01
mkdir -p app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall app
chmod -R 750 app

cd /unam/bda/disks/d02
mkdir -p app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall app
chmod -R 750 app

cd /unam/bda/disks/d03
mkdir -p app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall app
chmod -R 750 app

echo "Mostrando directorio de data files"
ls -l /opt/oracle/oradata
echo "Mostrando directorios para control files y Redo Logs"
ls -l /unam/bda/disks/d0*/app/oracle/oradata
