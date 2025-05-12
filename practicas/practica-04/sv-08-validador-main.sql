--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción:  Validador  ejercicio práctico 04

whenever sqlerror exit rollback

--Modificar las siguientes variables en caso de ser necesario.
--En scripts reales no deben incluirse passwords. Solo se hace para
--propósitos de pruebas y evitar escribirlos cada vez que se quiera ejecutar 
--el proceso de validación de la práctica (propósitos académicos).

--
-- Nombre del alumno empleado como prefijo para crear usuarios en la BD
--
define p_nombre='santiago'

---
---Nombre de la PDB
---
define p_pdb='sssbda_s1'

--
-- Password del usuario sys. Este es el password original asignado al crear la
-- BD con dbca, no emplear el valor asignado en el archivo de passwords.
--
define p_sys_password='302405'


--- ============= Las siguientes configuraciones ya no requieren cambiarse====

whenever sqlerror exit rollback
set verify off
set feedback off


Prompt =========================================================
Prompt Iniciando validador - Práctica 04
Prompt =========================================================

define p_script_validador='sv-08p-validador-ejercicios.plb'

Prompt Creando procedimientos para validar.

connect sys/&&p_sys_password@&p_pdb as sysdba
set serveroutput on
@sv-00-funciones-validacion.plb
@&p_script_validador

exit
