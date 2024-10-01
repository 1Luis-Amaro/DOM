SELECT segment1, a.attribute16 person_id
  FROM mtl_system_items_b a;
  
  
  
  
select * from PER_ALL_PEOPLE_F a, po_agents b  
 WHERE a.person_id = b.agent_id and TRUNC(SYSDATE) BETWEEN EFFECTIVE_START_DATE AND EFFECTIVE_END_DATE  