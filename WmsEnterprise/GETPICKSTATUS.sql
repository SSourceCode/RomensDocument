create or replace
FUNCTION "GETPICKSTATUS"
(
  v_BillNo IN VARCHAR2,
  v_BoxNo IN VARCHAR2
)
-- 返回值说明： 0 未拣货 1 正在拣货 2 拣货完成
RETURN varchar2
AS
    pick_count number(18,2);
    vessel_status varchar2(2);
    row_count number(18,2);
BEGIN
 -- SELECT count(1)  FROM FAHUO A INNER JOIN  WMS_VESSEL B ON WMSRECORDSTATUS = B.CODE WHERE ISSTATUS = 2 AND A.LSH = 'M200908466';
  SELECT count(1) into pick_count FROM FAHUO A INNER JOIN  WMS_VESSEL B ON WMSRECORDSTATUS = B.CODE WHERE ISSTATUS = 2 AND A.LSH = v_BillNo; --M200908466  20200902001
  IF pick_count <= 0 THEN
           return 0;
  END IF;
  
  SELECT COUNT(1) into row_count FROM FAHUO WHERE WMSRECORDSTATUS = v_BoxNo AND LSH = v_BillNo;
  
 -- SELECT count(1)  FROM FAHUO WHERE WMSRECORDSTATUS = '20200902001' AND LSH = 'M200908466' and WMSEXECSTATUS = 1;
 SELECT count(1) into pick_count FROM FAHUO WHERE WMSRECORDSTATUS = v_BoxNo AND LSH = v_BillNo and WMSEXECSTATUS = 1;
  IF pick_count >0 THEN
           return 1;
  END IF;
  
  SELECT count(1) into pick_count FROM FAHUO WHERE WMSRECORDSTATUS = v_BoxNo AND LSH = v_BillNo and WMSEXECSTATUS = 2;
  IF  pick_count >0 and pick_count = row_count THEN
           return 2;
  END IF;

  return 0;
END;
 