select ph.po_status, ph.po_no AS po,
       im.item_no             AS rm_code,
       pd.order_qty1 AS qty,
	   pd.order_um1 AS uom,
       pd.requested_dlvdate AS del_date, pd.date_added
from po_ordr_hdr ph, po_ordr_dtl pd, ic_item_mst im
where ph.po_id = pd.po_id and
      pd.item_id = im.item_id and
      pd.po_status = 0 and
      NOT ph.po_no like 'XX%' and
      NOT ph.po_no like 'W%'  AND
      NOT ph.po_no like 'D%' and
      NOT ph.po_no like 'L%' and
      NOT ph.po_no like 'N%' and
      im.item_no = 'kab-6394' and 
     (pd.requested_dlvdate > (getdate() - 30))
			order by ph.po_no, im.item_no