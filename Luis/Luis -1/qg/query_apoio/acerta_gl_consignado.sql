-- Caso o valor de DB e CR não bater, colocar a diferença em uma das contas --

select rowid, gi.* /*entered_dr, entered_cr*/ from apps.gl_interface gi where USER_JE_SOURCE_NAME = 'PPV CONSIGNADO';

select * from apps.xxppg_inv_controle_consig_v;

select  gi.* /*entered_dr, entered_cr*/ from apps.gl_interface gi where USER_JE_SOURCE_NAME = 'PPV CONSIGNADO';

-- Se alguma conta estiver incorreta, pegar o id da conta e alterar no registro com erro --

select * from apps.gl_code_combinations_kfv   gc1  where ENABLED_FLAG = 'Y';    

select CODE_COMBINATION_ID
  FROM apps.gl_code_combinations_kfv gc1
 WHERE ENABLED_FLAG = 'Y'
   AND CONCATENATED_SEGMENTS = 'conta passada pela Gisielle'