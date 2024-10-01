SELECT GS.SAMPLE_APPROVER_ID, GMD.TESTER_ID, GS.SAMPLER_ID
  FROM apps.GMD_SAMPLES GS ,apps.GMD_RESULTS GMD
 WHERE GS.SAMPLE_ID = GMD.SAMPLE_ID (+) AND
       --GS.SAMPLE_ID = v_SAMPLE_ID and
       gs.sample_no = 4566;
       
       
SELECT * from apps.gmd_samples ;     

select * from apps.fnd_user where user_id in(1834,1825);  