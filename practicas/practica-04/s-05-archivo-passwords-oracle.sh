#!/bin/bash
# @Autor Santiago Sanchez Sanchez
# @Fecha dd/mm/yyyy
# @Descripcion Simulación de pérdida y recuperación de un archivo de passwords

archivoPwd="${ORACLE_HOME}/dbs/orapwfree"
practicaDir="/unam/bda/practicas/practica-04"
archivoRespaldo="${practicaDir}/orapwfree.backup"

if [ "${USER}" != "oracle" ]; then
  echo "ERROR: el script debe ser ejecutado por el usuario oracle"
  exit 1
fi

echo "Verificando si el archivo ya fue respaldado"
if [ -f "${archivoRespaldo}" ]; then
  echo "El archivo ${archivoRespaldo} ya existe, se omite su copia"
else
  echo "Realizando respaldo del archivo de passwords, indicar password de ${USER}"
  cp ${archivoPwd} ${archivoRespaldo}
fi

echo "Validando si el respaldo se realizó de forma correcta"
if [ -f "${archivoRespaldo}" ]; then
  echo "Respaldo realizado con éxito"
else
  echo "ERROR: No se pudo realizar el respaldo"
  exit 1
fi

echo "Borrando el archivo de passwords original"
rm -f ${archivoPwd}

echo "Verificando que el archivo haya sido realmente eliminado"
if [ ! -f "${archivoPwd}" ]; then
  echo "El archivo original de passwords ha sido eliminado"
else
  echo "ERROR: El archivo original no ha sido eliminado"
  exit 1
fi

# En esta instrucción, el programa entra en modo de espera hasta que se presione
# cualquier tecla para continuar con la ejecución. Solo se agrega para confirmar
# que el archivo se ha borrado y se procede ahora a regenerar el archivo.
read -p "OK, archivo de passwords fue eliminado [Enter] para realizar su recuperación"

echo "Generando un archivo de passwords nuevo, proporcionar el password de SYS a Hola1234*"

# Agregar la instrucción para generar el archivo de passwords
# Incluyendo el usuario SYS y el password proporcionado.
echo "Crea el archivo de contraseñas para SYS con el password Hola1234*"

# Asumimos que el comando para crear el archivo de passwords se ejecuta aquí
# Si Oracle tiene el comando `orapwd`, se usa el siguiente ejemplo:
orapwd file=${archivoPwd} password=Hola1234* entries=10 force=y

echo "validando la existencia del nuevo archivo"
if [ -f "${archivoPwd}" ]; then
  echo "OK. Archivo de password generado"
else
  echo "ERROR: El archivo de passwords no ha sido regenerado"
  exit 1
fi
