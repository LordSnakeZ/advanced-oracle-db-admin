connect sys/system2@sssbda_s2 as sysdba;

CREATE USER santiago08 identified by santiago08 QUOTA UNLIMITED ON users;

GRANT CREATE TABLE, CREATE SESSION, CREATE SEQUENCE TO santiago08;

