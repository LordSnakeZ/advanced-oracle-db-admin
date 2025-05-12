--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción:  Validador  Práctica 10


--Modificar las siguientes 2 variables en caso de ser necesario.
--En scripts reales no deben incluirse passwords. Solo se hace para
--propósitos de pruebas y evitar escribirlos cada vez que se quiera ejecutar 
--el proceso de validación de la práctica (propósitos académicos).

--
-- Nombre del alumno empleado como prefijo para crear usuarios en la BD
--
define p_nombre='santiago'

--
-- Password del usuario creado en est práctica
--
define p_usr_password='1234'

--
-- Password del usuario sys
--
define p_sys_password='system2'

--
-- Nombre de la PDB
--
define p_pdb=sssbda_s2


--- ============= Las siguientes configuraciones ya no requieren cambiarse====

whenever sqlerror exit rollback
set verify off
set feedback off


Prompt =========================================================
Prompt Iniciando validador -Práctica 10
Prompt =========================================================

define p_num=10
define p_script_validador='sv-07p-validador-ejercicios.plb'

define p_username=&&p_nombre&&p_num

Prompt Creando procedimientos para validar en &&p_pdb

connect sys/&&p_sys_password@&&p_pdb as sysdba
set serveroutput on
@sv-00-funciones-validacion.plb
Prompt invocando script para validar
@&&p_script_validador

exit