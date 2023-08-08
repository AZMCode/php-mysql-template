/* Disable remote root login */
delete from mysql.user where User = 'root' and Host not in ('localhost','127.0.0.1','::1');

/* Create Server Role */
create role if not exists 'serverRole';

/* Assign Permissions to Role */
grant execute on alquimia.* to 'serverRole';
grant select, insert, delete, update on bd.* to 'serverRole';

/* Create Server User. Password will get replaced by database_crypto/server_password using 05-*.sql */
create user if not exists 'server' identified with 'caching_sha2_password' by "dummy" default role 'serverRole';

/* Flush Privileges */
flush privileges;