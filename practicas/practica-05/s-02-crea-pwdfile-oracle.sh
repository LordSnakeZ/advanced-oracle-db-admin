#!/bin/bash


# Autor: Santiago Sánchez Sánchez
# Fecha: 25/02/2025
# Descripción: Este script crea un archivo de passwords únicamente con el usuario sys
#              empleando como password Hola1234* y valida que el archivo fue creado correctamente.

# Variables
ORACLE_SID=${ORACLE_SID}
ORACLE_HOME=${ORACLE_HOME}
PASSWORD_FILE="$ORACLE_HOME/dbs/orapw${ORACLE_SID}"
SYS_PASSWORD="Hola1234*"

# A. Crear un archivo de passwords únicamente con el usuario sys
echo "Creando archivo de passwords para el usuario sys..."
orapwd file=$PASSWORD_FILE password=$SYS_PASSWORD entries=1 force=y

# Verificar si el archivo fue creado correctamente
if [ $? -eq 0 ]; then
    echo "El archivo de passwords fue creado correctamente."
else
    echo "Error: No se pudo crear el archivo de passwords."
    exit 1
fi

# B. Validar que el archivo de passwords fue creado correctamente
echo "Validando la creación del archivo de passwords..."
ls -l $PASSWORD_FILE

# Verificar si el archivo existe
if [ -f "$PASSWORD_FILE" ]; then
    echo "El archivo de passwords existe y fue creado correctamente."
else
    echo "Error: El archivo de passwords no existe."
    exit 1
fi

exit 0
