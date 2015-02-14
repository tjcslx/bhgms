--------------------------------------------------------
--  文件已创建 - 星期五-二月-06-2015   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger TRIG_POST_APPROVE_CHANGE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "BHGMS"."TRIG_POST_APPROVE_CHANGE" after update on bhgms_f_approve
for each row
declare
  ha_id_sql BHGMS_H_APPROVE.HA_ID%TYPE;
BEGIN
  if :new.fa_status = '2'
  then
    begin
      select ha_id.nextval into ha_id_sql from dual;
    
      insert into bhgms_h_approve values (HA_ID_SQL, :old.fa_id, '0', :old.fa_issuer, sysdate, sysdate);
    end;
end if;
END;
/
ALTER TRIGGER "BHGMS"."TRIG_POST_APPROVE_CHANGE" ENABLE;
