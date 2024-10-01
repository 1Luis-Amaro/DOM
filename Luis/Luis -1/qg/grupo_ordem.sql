select gbh.batch_no
from   gme_batch_groups_association gba,
       gme_batch_groups_b gbg,
       gme_batch_header gbh
where gbg.group_id = gba.group_id
and     gba.batch_id = gbh.batch_id
and     gbg.group_name = '3'


select * from
       gme_batch_groups_association gba,
       gme_batch_groups_b gbg,
       gme_batch_header gbh,
       gme_batch_groups_association gba2,
       gme_batch_header gbh2
       
where  gbh.batch_no = 3
and    gbg.group_id = gba.group_id
and    gba.batch_id = gbh.batch_id
and    gba2.group_id = gba.group_id
and    gbh2.batch_id = gba2.batch_id

