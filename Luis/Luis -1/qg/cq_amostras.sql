select mp.organization_code org,
       sample_no            "Amostra",  
       msi.segment1         "Item",
       gbh.batch_no         "Ordem",
       frh.routing_no       "Roteiro",
       pha.segment1         "Ordem Compra",
       gs.lot_number        "Lote",
       gs.sample_qty        "Qtd Amostra",
       gs.remaining_qty     "Qtd Remanescente",
       gs.creation_date     "Data Criacao",
       gs.*
  from apps.gmd_samples        gs,
       apps.mtl_parameters     mp,
       apps.mtl_system_items_b msi,
       apps.gme_batch_header   gbh,
       apps.fm_rout_hdr        frh,
       apps.po_headers_all     pha
 where mp.organization_id(+)    = gs.organization_id   and
       msi.organization_id(+)   = mp.organization_id   and
       msi.inventory_item_id(+) = gs.inventory_item_id and
       gbh.batch_id(+)          = gs.batch_id          and
       frh.routing_id(+)        = gs.routing_id        and
       pha.po_header_id(+)      = gs.po_header_id and sample_no = '100' -- and gs.sample_disposition <> '1P'
       order by gs.CREATION_DATE desc;

select * from apps.fm_rout_hdr;

select * from apps.GMD_SAMPLING_EVENTS where sampling_event_id = 228253; --= 228240;
select * from apps.GMD_SAMPLES where sample_id = 243383;
select * from apps.GMD_SAMPLES_LAB where sample_id = 243383;
select * from apps.GMD_SAMPLE_SPEC_DISP where sample_id =  243383;