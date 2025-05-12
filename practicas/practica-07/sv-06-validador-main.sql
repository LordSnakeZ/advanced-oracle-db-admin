--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción:  Validador  Práctica 07


--Modificar las siguientes variables en caso de ser necesario.
--En scripts reales no deben incluirse passwords. Solo se hace para
--propósitos de pruebas y evitar escribirlos cada vez que se quiera ejecutar 
--el proceso de validación de la práctica (propósitos académicos).

--
-- Nombre del alumno empleado como prefijo para crear usuarios en la BD
-- Su valor se emplea para formar la cadena c##<nombre>07
--
define p_nombre='santiago'

--
-- Password del usuario sys
--
define p_sys_password='system2'

--
-- Nombre de la PDB creada en el tema 2
--
define p_pdb='sssbda_s2'


--- ============= Las siguientes configuraciones ya no requieren cambiarse====

whenever sqlerror exit rollback
set verify off
set feedback off


Prompt =========================================================
Prompt Iniciando validador - Práctica 07
Prompt =========================================================

define p_script_validador='sv-06p-validador-ejercicios.plb'

Prompt Creando procedimientos para validar.

connect sys/&&p_sys_password as sysdba
set serveroutput on
Prompt creando funciones en cdb$root 
@sv-00-funciones-validacion.plb

Prompt creando funciones en &p_pdb
alter session set container=&p_pdb;
@sv-00-funciones-validacion.plb

Prompt regresando a cdb$root
alter session set container=cdb$root;

@&&p_script_validador

Prompt removiendo procedimientos en cdb$root 
exec spv_remove_procedures

Prompt removiendo procedimientos en &p_pdb
alter session set container=&p_pdb;
exec spv_remove_procedures

Prompt regresando a cdb$root
alter session set container=cdb$root;

exit
