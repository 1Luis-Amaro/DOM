select * from dba_directories;

select * from FND_DESCRIPTIVE_FLEXS;

select * from FND_DESCR_FLEX_CONTEXTS_VL;

select batch_id from gme_batch_header where batch_no = 33310 and organization_id = 92;

select attribute1 from gme_batch_steps where batch_id = 447451;

select attribute1 from gme_batch_steps where attribute1 is not null