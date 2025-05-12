-- @Autor       Santiago Sánchez Sánchez
-- @Fecha       29/08/2024
-- @Descripcion Crea una BD con la instrucción CREATE DATABASE en modo nomount
--              y homologa las contraseñas.

-- Inicia sesión con el usuario sys.
CONNECT sys/Hola1234* AS sysdba

-- Inicia la instancia en modo nomount.
startup nomount

-- Indica que se debe detener la ejecución en caso de error al crear la BD.
whenever sqlerror exit rollback

-- Crea la Base de Datos.
CREATE DATABASE free
    USER sys IDENTIFIED BY system2
    USER system IDENTIFIED BY system2
    LOGFILE GROUP 1(
        '/unam/bda/disks/d01/app/oracle/oradata/FREE/redo01a.log',
        '/unam/bda/disks/d02/app/oracle/oradata/FREE/redo01b.log',
        '/unam/bda/disks/d03/app/oracle/oradata/FREE/redo01c.log'
    ) SIZE 50m BLOCKSIZE 512,
    GROUP 2(
        '/unam/bda/disks/d01/app/oracle/oradata/FREE/redo02a.log',
        '/unam/bda/disks/d02/app/oracle/oradata/FREE/redo02b.log',
        '/unam/bda/disks/d03/app/oracle/oradata/FREE/redo02c.log'
    ) SIZE 50m BLOCKSIZE 512,
    GROUP 3(
        '/unam/bda/disks/d01/app/oracle/oradata/FREE/redo03a.log',
        '/unam/bda/disks/d02/app/oracle/oradata/FREE/redo03b.log',
        '/unam/bda/disks/d03/app/oracle/oradata/FREE/redo03c.log'
    ) SIZE 50m BLOCKSIZE 512
    MAXLOGHISTORY 1
    MAXLOGFILES 16
    MAXLOGMEMBERS 3
    MAXDATAFILES 1024
    CHARACTER SET AL32UTF8
    NATIONAL CHARACTER SET AL16UTF16
    EXTENT MANAGEMENT LOCAL
        DATAFILE '/opt/oracle/oradata/FREE/system01.dbf'
            SIZE 700m AUTOEXTEND ON NEXT 10240k MAXSIZE unlimited
        sysaux DATAFILE '/opt/oracle/oradata/FREE/sysaux01.dbf'
            SIZE 550m AUTOEXTEND ON NEXT 10240k MAXSIZE unlimited
        default TABLESPACE users
            DATAFILE '/opt/oracle/oradata/FREE/users01.dbf'
            SIZE 100m AUTOEXTEND ON NEXT 10240k MAXSIZE unlimited
        default temporary TABLESPACE tempts1
            tempfile '/opt/oracle/oradata/FREE/temp01.dbf'
            SIZE 20m AUTOEXTEND ON NEXT 640k MAXSIZE unlimited
        undo TABLESPACE undotbs1
            DATAFILE '/opt/oracle/oradata/FREE/undotbs01.dbf'
            SIZE 200m AUTOEXTEND ON NEXT 5120k MAXSIZE unlimited
        ENABLE PLUGGABLE DATABASE
        SEED
            file_name_convert = (
                '/opt/oracle/oradata/FREE',
                '/opt/oracle/oradata/FREE/pdbseed'
            )
            system DATAFILES SIZE 125m AUTOEXTEND ON NEXT 10m MAXSIZE unlimited
            sysaux DATAFILES SIZE 100m AUTOEXTEND ON NEXT 10240k MAXSIZE unlimited
            LOCAL undo ON
;

-- Homolagando constraseñas.
ALTER USER sys IDENTIFIED BY system2;
ALTER USER system IDENTIFIED BY system2;

-- Inicia sesión con el usuario sys y la nueva contraseña homologada.
CONNECT sys/system2 AS sysdba
