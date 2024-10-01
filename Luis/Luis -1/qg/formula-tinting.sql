select fms.formula_no, fms.formula_vers
   from apps.fm_form_mst_b      fms,
        apps.fm_matl_dtl        fmd,
        apps.mtl_system_items_b msi
  where fmd.formula_id             = fms.formula_id            and
        fmd.line_type              = 1                         and
        fms.owner_organization_id <> 88                        and
        msi.inventory_item_id      = fmd.inventory_item_id     and
        msi.organization_id        = 92
        and msi.segment1 in ('00204608L',
'00204617Z',
'00204618Z',
'00204619L',
'00238841Z',
'00238843L',
'00238847Z',
'00238849L',
'00319091L',
'00331879L',
'00331880L',
'00331881Z',
'00331882Z',
'00345237Z',
'00346493L',
'00149922L',
'00149924Z',
'00318205Z',
'00318204L',
'00154011Z',
'00159337L');