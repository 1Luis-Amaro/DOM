select rowid, gi.* /*entered_dr, entered_cr*/ from apps.gl_interface gi where USER_JE_SOURCE_NAME = 'PPV CONSIGNADO';

select * from apps.xxppg_inv_controle_consig_v;