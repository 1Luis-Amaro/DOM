select count(*) from apps.mtl_system_items_b where attribute2 is not null; and organization_id = 87;

select * from apps.mtl_parameters; 

select table_name, last_analyzed, num_rows from dba_tables where table_name in 
 ('MTL_TXN_REQUEST_LINES') 
 order by table_name ;
 
 select table_name,index_name, last_analyzed, num_rows, distinct_keys from dba_indexes where table_name in 
 ('MTL_TXN_REQUEST_LINES') 
 order by table_name,index_name ;
 
 select table_name,index_name, column_name, column_position from dba_ind_columns where table_name in 
 ('MTL_TXN_REQUEST_LINES') 
 order by table_name,index_name,column_position 
 
 
 
 3-15915304291 
 
 
 
 1 Please provide the raw trace with Binds and Waits. On the form, 
 select Help > Diagnostics > Trace with Binds and Waits.Turn on 
 just before issue begins, turn off once completed. 

 2. Provide tkprof for the above raw trace. A trace file is a raw set 
 of data produced by the Oracle Database. TKPROF reformats the raw 
 data so that it is easier to review. a. Retrieve the trace file. 
 b. Issue a command like the following to create a TKPROF version of the 
 trace file.This command sorts the results with the longest running 
 queries first: tkprof <filename.trc> <output_filename> 
 sys=no explain=apps/<password> sort='(prsela,exeela,fchela)' 

 c. Additionally, please provide the following TKPROF that limits the 
 results to the top ten queries: 
 tkprof <filename.trc> <output_filename> sys=no 
 explain=apps/<password> 
 sort='(prsela,exeela,fchela)' print=10 


 3. How often is gather statistics done for the schemas: INV and GME? 

 4. Did this performance issue suddenly occurred or gradually over a period 
 of time. 
