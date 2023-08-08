use alquimia;

create event clear_expired_tokens_event on schedule every 10 minute enable do call clear_expired_tokens();