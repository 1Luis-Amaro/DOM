SELECT PO_HEADER_ID, ship_to_location_id, bill_to_location_id FROM APPS.po_headers_all
where 1 = 1
and SEGMENT1 = '140682';


SELECT ship_to_location_id
     , ship_to_organization_id
     , attribute2
     , attribute3
 FROM APPS.po_line_locations_all
where 1 = 1
and po_header_id = 2246887;
--One line updated

--SQL3
SELECT deliver_to_location_id --      = 211
     , destination_organization_id --= 89
  FROM apps.po_distributions_all
where 1 = 1
and po_header_id = 2246887;
--One line updated


--SQL4
select location_id --= 211
     , to_organization_id --= 89
  from apps.mtl_supply
where 1=1
and po_header_id = 2246887;

and supply_source_id = 1442450;
--One line updated






--------------------------------------
--SQL1
update po_headers_all
set ship_to_location_id = 142
  , bill_to_location_id = 142
where 1 = 1
and po_header_id = 2253007;
--One line updated

--SQL2
update po_line_locations_all
set ship_to_location_id     = 142
  , ship_to_organization_id = 92
  , attribute2 = null
  , attribute3 = null
where 1 = 1
and po_header_id = 2253007;
--One line updated

--SQL3
update po_distributions_all
set deliver_to_location_id      = 142
  , destination_organization_id = 92
where 1 = 1
and po_header_id = 2253007;
--One line updated


--SQL4
update mtl_supply
set location_id = 142
  , to_organization_id = 92
where 1=1
and po_header_id = 2253007;
--One line updated

