
CONNECT sys/system2 as sysdba;

CREATE USER c##santiago09 IDENTIFIED BY 1234 QUOTA UNLIMITED ON users;

GRANT CREATE TABLE, CREATE SESSION, CREATE SEQUENCE TO c##santiago09;

PROMPT Listo, usuario de la practica creado con exito!!!

EXIT
