select * from
       (select distinct BUG_NUMBER PATCH_NAME, 'BUGS' PATCH_TYPE, CREATION_DATE from apps.ad_bugs where baseline_name = 'R12'
        UNION
        select distinct PATCH_NAME, PATCH_TYPE, CREATION_DATE from apps.AD_APPLIED_PATCHES)
        where patch_name like '%25633408%';


 Patch.25633408:R12.GMD.B

