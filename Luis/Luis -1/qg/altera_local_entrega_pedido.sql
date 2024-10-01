select po_header_id, pha.* from apps.po_headers_all pha where segment1 = '56573';

957379
-----
select destination_organization_id,
       deliver_to_location_id 
  from  apps.po_distributions_all
 WHERE po_header_id = 989343;
-- Lines updated: 1

select ship_to_organization_id,
       ship_to_location_id    from apps.po_line_locations_all
 WHERE po_header_id = 989343;
-- Lines updated: 1


select count(*) from apps.po_distributions_all
 WHERE po_header_id = 989343;
-- Lines updated: 1

select count(*) from apps.PO_DISTRIBUTIONS_ARCHIVE_ALL
 WHERE po_header_id = 989343;
-- Lines updated: 2

select * from apps.po_line_locations_all
 WHERE po_header_id = 989343;
-- Lines updated: 1

select * from apps.PO_LINE_LOCATIONS_ARCHIVE_ALL
 WHERE po_header_id = 989343;
-- Lines updated: 2








select * from apps.mtl_parameters where organization_id = 92;

select * from HR_LOCATIONS_V;

UPDATE apps.PO_DISTRIBUTIONS_ARCHIVE_ALL
   SET destination_organization_id = 92,
       deliver_to_location_id      = 142 
 WHERE po_header_id = 989343;
-- Lines updated: 1

UPDATE apps.po_line_locations_all
   SET ship_to_organization_id = 92,
       ship_to_location_id     = 142 
 WHERE po_header_id = 989343;
-- Lines updated: 1

UPDATE apps.PO_LINE_LOCATIONS_ARCHIVE_ALL
   SET ship_to_organization_id = 92,
       ship_to_location_id     = 142
 WHERE po_header_id = 989343;
-- Lines updated: 2

-----


UPDATE apps.po_distributions_all
   SET destination_organization_id = 92,
       deliver_to_location_id      = 142
 WHERE po_header_id = 989343;
-- Lines updated: 1

UPDATE apps.PO_DISTRIBUTIONS_ARCHIVE_ALL
   SET destination_organization_id = 92,
       deliver_to_location_id      = 142 
 WHERE po_header_id = 989343;
-- Lines updated: 1

UPDATE apps.po_line_locations_all
   SET ship_to_organization_id = 92,
       ship_to_location_id     = 142 
 WHERE po_header_id = 989343;
-- Lines updated: 1

UPDATE apps.PO_LINE_LOCATIONS_ARCHIVE_ALL
   SET ship_to_organization_id = 92,
       ship_to_location_id     = 142
 WHERE po_header_id = 989343;
-- Lines updated: 2

