--------------------------------------------------------
--  文件已创建 - 星期五-二月-06-2015   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger TRIG_POST_APPROVE_CHECKIN
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "BHGMS"."TRIG_POST_APPROVE_CHECKIN" 
    AFTER UPDATE ON BHGMS.BHGMS_F_APPROVE 
    FOR EACH ROW 
DECLARE
   FAVS_TYPE_SQL     BHGMS_F_APPROVE_VACATION_SUB.FAVS_TYPE%TYPE;
   FAVS_ORIGIN_SQL   BHGMS_F_APPROVE_VACATION_SUB.FAVS_ORIGIN%TYPE;
BEGIN
   SELECT F.FAVS_TYPE, F.FAVS_ORIGIN
     INTO FAVS_TYPE_SQL, FAVS_ORIGIN_SQL
     FROM BHGMS_F_APPROVE_VACATION_SUB F
    WHERE F.FA_ID = :OLD.FA_ID;

   IF :OLD.FA_TYPE = '1' AND :NEW.FA_STATUS = '2'
   THEN
      IF FAVS_TYPE_SQL = '1' AND FAVS_ORIGIN_SQL = '1'
      THEN
         UPDATE BHGMS_F_CHECKIN B
            SET B.FC_STATUS = '0', B.ALTER_TIME = SYSDATE
          WHERE B.FC_ID = (SELECT B.FAVS_ORIGIN_ID
                             FROM BHGMS_F_APPROVE_VACATION_SUB B
                            WHERE B.FA_ID = :OLD.FA_ID);
      ELSE
         IF FAVS_TYPE_SQL <> '1' AND FAVS_ORIGIN_SQL = '1'
         THEN
            UPDATE BHGMS_F_CHECKIN B
               SET B.FC_STATUS = '1', B.ALTER_TIME = SYSDATE
             WHERE B.FC_ID = (SELECT B.FAVS_ORIGIN_ID
                                FROM BHGMS_F_APPROVE_VACATION_SUB B
                               WHERE B.FA_ID = :OLD.FA_ID);
         END IF;
      END IF;
   END IF;
END;
/
ALTER TRIGGER "BHGMS"."TRIG_POST_APPROVE_CHECKIN" ENABLE;
