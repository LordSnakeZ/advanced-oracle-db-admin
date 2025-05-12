#!/bin/bash

mkdir /tmp/dd-logs
cd $ORACLE_HOME/rdbms/admin
perl -I $ORACLE_HOME/rdbms/admin \
$ORACLE_HOME/rdbms/admin/catcdb.pl \
--logDirectory /tmp/dd-logs \
--logFilename dd.log \
--logErrorsFilename dderror.log

sqlplus -s sys/system2 as sysdba << EOF
set serveroutput on
exec dbms_dictionary_check.full
EOF
