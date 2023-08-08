use alquimia;

\d #
create procedure clear_expired_tokens() modifies sql data
begin
    delete from ClientToken where expiration < now();
    delete from AdminToken where expiration < now();
end#
\d ;