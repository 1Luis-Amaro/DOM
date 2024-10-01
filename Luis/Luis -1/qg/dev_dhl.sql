
update rcv_transactions set attribute15 = NULL where attribute15 IS not NULL;

select * FROM apps.rcv_transactions where attribute15 IS not NULL;