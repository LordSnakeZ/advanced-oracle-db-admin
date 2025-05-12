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
define sys_pwd = 302405

--Iniciales del estudiante
define p_iniciales = sss

--asignatura ( bd | bda | bdd )
define p_asignatura = bda


------------------------------------------------------------------------
--  Las variables siguientes ya no requieren cambios, no modificar
------------------------------------------------------------------------

define p_pdb1='&p_iniciales&p_asignatura._s1'

Prompt ===> 1. Conectando a CDB$ROOT
connect sys/&&sys_pwd as sysdba

Prompt ===> 2. Creando procedimientos para validar.
@sv-00-funciones-validacion.plb
@sv-02p-valida-pdb.plb

Prompt ===> 3. Conectando a &p_pdb1
connect sys/&sys_pwd@&p_pdb1 as sysdba

Prompt ===> 4. Creando procedimientos para validar.
@sv-00-funciones-validacion.plb
@sv-02p-valida-pdb.plb

---
--- Iniciando validación.
---

prompt Validando en CDB$ROOT
connect sys/&&sys_pwd as sysdba
set serveroutput on
set verify off
set feedback off

exec spv_print_header

declare
  v_nombre_1 varchar2(128);
  v_nombre_2 varchar2(128);
begin
  v_nombre_1 := trim('&p_iniciales')||trim('&p_asignatura')||'_s1';
  v_nombre_2 := trim('&p_iniciales')||trim('&p_asignatura')||'_s2';
  if '&p_asignatura' = 'bdd' then 
      spv_print_ok('Validando '||v_nombre_1);
      spv_verifica_pdb(v_nombre_1);
      spv_print_ok('Validando '||v_nombre_2);
      spv_verifica_pdb(v_nombre_2);
  else
      --para bd, bda solo se valida una PDB
      spv_print_ok('Validando '||v_nombre_1);
      spv_verifica_pdb(v_nombre_1);
  end if;
  spv_print_ok('Validación concluida');
end;
/

prompt Realizando limpieza de objetos de validación
exec spv_remove_procedures

prompt Validando desde &&p_pdb1 
connect sys/&&sys_pwd@&&p_pdb1 as sysdba
set serveroutput on
set verify off
set feedback off

exec  spv_verifica_pdb('&p_pdb1')

prompt Realizando limpieza de objetos de validación
exec spv_remove_procedures

--para la pdb2 no se invoca ya que solo aplica para bdd
--la validación de hace desde la cdb

Prompt 8. ===>  Validación concluida.
exit

