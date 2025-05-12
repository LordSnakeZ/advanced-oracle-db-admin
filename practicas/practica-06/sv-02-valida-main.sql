--@Autor(es):       Jorge Rodríguez
--@Fecha creación:  dd/mm/yyyy
--@Descripción:     Validación de resultados. Primero se conecta a CDB y a la(s)
--                  PDB(s) para crear los objetos de validación.  Posteriormente
--                  se vuelve a conectar para ejecutar los objetos.

whenever sqlerror exit rollback

----------------------------------------------------------------------
-- Modificar los valores de las siguientes variables según corresponda
----------------------------------------------------------------------

--Password del usuario sys
define sys_pwd = system2

--Iniciales del estudiante
define p_iniciales = sss

--Asignatura
define p_asignatura = bda


------------------------------------------------------------------------
--  Las variables siguientes ya no requieren cambios, no modificar
------------------------------------------------------------------------

define p_pdb='&p_iniciales&p_asignatura._s2'

Prompt ===> 1. Conectando a CDB$ROOT
connect sys/&&sys_pwd as sysdba

Prompt ===> 2. Creando procedimientos para validar.
@sv-00-funciones-validacion.plb
@sv-02p-valida-pdb.plb
@sv-01p-validador-dd.plb

Prompt ===> 3. Conectando a &p_pdb
connect sys/&sys_pwd@&p_pdb as sysdba

Prompt ===> 4. Creando procedimientos para validar.
@sv-00-funciones-validacion.plb
@sv-02p-valida-pdb.plb
@sv-01p-validador-dd.plb

---
--- Iniciando validación.
---

--validando en CDB$ROOT
connect sys/&&sys_pwd as sysdba
set serveroutput on
set verify off
set feedback off

exec spv_print_header

Prompt ========== Validando PDB2 desde CDB$ROOT  ============
declare
  v_nombre_2 varchar2(128);
begin
  v_nombre_2 := trim('&p_iniciales')||trim('&p_asignatura')||'_s2';
  spv_print_ok('Validando '||v_nombre_2);
  spv_verifica_pdb(v_nombre_2);
  spv_print_ok('Validación concluida');
end;
/

Prompt ========== Validando Diccionario  desde CDB$ROOT  ============
exec spv_valida_datos_instancia

--hace limpieza de objetos de validación
exec spv_remove_procedures

Prompt ========== Validando PDB2 desde la propia PDB2  ============
connect sys/&&sys_pwd@&&p_pdb as sysdba
set serveroutput on
set verify off
set feedback off
exec  spv_verifica_pdb('&p_pdb')

Prompt ========== Validando Diccionario  desde CDB$ROOT  ============
exec spv_valida_datos_instancia

Prompt ============ Validando DD con dbms_dictionary_check.full ======

begin 
  dbms_dictionary_check.full; 
end; 
/
Prompt 
Prompt ================================================================
Prompt 
exec spv_print_ok('Ejecución exitosa del procedimiento dbms_dictionary_check.full ');
exec spv_print_ok('Validación concluida.')

--hace limpieza de objetos de validación
exec spv_remove_procedures

exit

