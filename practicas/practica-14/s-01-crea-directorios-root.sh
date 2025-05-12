mkdir -p /unam/bda/archivelogs/FREE/disk_a
mkdir -p /unam/bda/archivelogs/FREE/disk_b

echo "Directorios creados correctamente"

# Cambiar el propietario y grupo a oracle (ajusta el grupo si es necesario)
chown -R oracle:oinstall /unam/bda/archivelogs

# Asignar permisos: usuario rwx, grupo r-x, otros ---
chmod -R 750 /unam/bda/archivelogs 

echo "Permisos ajustados correctamente"
