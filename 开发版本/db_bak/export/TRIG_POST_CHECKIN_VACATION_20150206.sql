--------------------------------------------------------
--  文件已创建 - 星期五-二月-06-2015   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger TRIG_POST_CHECKIN_VACATION
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "BHGMS"."TRIG_POST_CHECKIN_VACATION" 
   AFTER INSERT
   ON BHGMS_F_CHECKIN
   FOR EACH ROW
DECLARE
   FA_ID_SQL      BHGMS_F_APPROVE.FA_ID%TYPE;
   DAN_CURRNODE   BHGMS_D_APPROVE_PROCESS.DAN_CURRNODE%TYPE;
   JOB_ID BHGMS_U_OFFICER.JOB_ID%TYPE;
BEGIN
   SELECT B.JOB_ID INTO JOB_ID FROM BHGMS_U_OFFICER B WHERE B.BTOF_ID = :NEW.FC_CHECKER;
   IF JOB_ID NOT IN ('1', '2', '7', '8')
   THEN
      SELECT D.DAN_CURRNODE
        INTO DAN_CURRNODE
        FROM BHGMS_U_OFFICER B, BHGMS_R_NODE_JOB R, BHGMS_D_APPROVE_PROCESS D
       WHERE     ((B.JOB_ID = R.RNJ_JOBID AND B.BTOF_ISUNI = '0') OR (B.BTOF_ID = R.RNJ_BTOFID AND B.BTOF_ISUNI = '1'))
             AND R.RNJ_NODEID = D.DAN_CURRNODE
             AND R.RNJ_STATUS = '1'
             AND D.DAT_ID = '1'
             AND D.DAP_STATUS = '1'
             AND D.DAN_PREVNODE IS NULL
             AND B.BTOF_ID = :NEW.FC_CHECKER;

      IF :NEW.FC_TYPE = '0' AND :NEW.FC_STATUS = '2'
      THEN
         BEGIN
            SELECT FA_ID.NEXTVAL INTO FA_ID_SQL FROM DUAL;

            INSERT INTO BHGMS_F_APPROVE (FA_ID,
                                         FA_NAME,
                                         FA_TYPE,
                                         FA_ISSUER,
                                         FA_CURRENTUSER,
                                         FA_CURRENTNODE,
                                         FA_LASTUSER,
                                         FA_ISSUEDATE,
                                         FA_STATUS,
                                         INSERT_TIME,
                                         ALTER_TIME)
               SELECT FA_ID_SQL,
                         B.BTOF_NAME
                      || SUBSTR (:NEW.FC_DATE, 1, 4)
                      || '年'
                      || SUBSTR (:NEW.FC_DATE, 5, 2)
                      || '月'
                      || SUBSTR (:NEW.FC_DATE, 7, 2)
                      || '日迟到请假申请'
                         AS FA_NAME,
                      '1' AS FA_TYPE,
                      :NEW.FC_CHECKER AS FA_ISSUER,
                      :NEW.FC_CHECKER AS FA_CURRENTUSER,
                      DAN_CURRNODE AS FA_CURRENTNODE,
                      :NEW.FC_CHECKER AS FA_LASTUSER,
                      TO_DATE (:NEW.FC_DATE, 'YYYYMMDD') AS FA_ISSUEDATE,
                      '1' AS FA_STATUS,
                      SYSDATE,
                      SYSDATE
                 FROM BHGMS_U_OFFICER B
                WHERE :NEW.FC_CHECKER = B.BTOF_ID;

            INSERT INTO BHGMS_F_APPROVE_VACATION_SUB (FA_ID,
                                                      FAVS_TIME_TYPE,
                                                      FAVS_ISSUEDATE,
                                                      FAVS_BEGINTIME,
                                                      FAVS_ENDTIME,
                                                      FAVS_VACATION_HOUR,
                                                      FAVS_VACATION_MIN,
                                                      FAVS_TYPE,
                                                      FAVS_ORIGIN,
                                                      FAVS_ORIGIN_ID,
                                                      INSERT_TIME,
                                                      ALTER_TIME)
               SELECT FA_ID_SQL,
                      '1',
                      TO_DATE (:NEW.FC_DATE, 'YYYYMMDD') AS FA_ISSUEDATE,
                      D.DIT_TIMESTAMP AS FAVS_BEGINTIME,
                      :NEW.FC_CHECKTIME AS FAVS_ENDTIME,
                      PACKAGE_BHGMS_TRANSACTION.
                       GENERATE_HOUR_GAP (D.DIT_TIMESTAMP, :NEW.FC_CHECKTIME),
                      PACKAGE_BHGMS_TRANSACTION.
                       GENERATE_MIN_GAP (D.DIT_TIMESTAMP, :NEW.FC_CHECKTIME),
                      '1' AS FAVS_TYPE,
                      '1' AS FAVS_ORIGIN,
                      :NEW.FC_ID AS FAVS_ORIGIN_ID,
                      SYSDATE,
                      SYSDATE
                 FROM BHGMS_U_OFFICER B2, BHGMS_U_ORGAN B1, BHGMS_D_INTIME D
                WHERE     B2.BTO_ID = B1.BTO_ID
                      AND B1.BTO_CATEGORY = D.BTO_CATEGORY
                      AND :NEW.FC_CHECKER = B2.BTOF_ID
                      AND TO_CHAR (TO_DATE (:NEW.FC_DATE, 'YYYYMMDD') - 1,
                                   'D') = D.DIT_DAYOFWEEK
                      AND D.DIT_TYPE = '1'
                      AND D.DIT_STATUS = '1';
         END;
      ELSIF :NEW.FC_TYPE = '1' AND :NEW.FC_STATUS = '2'
      THEN
         BEGIN
            SELECT FA_ID.NEXTVAL INTO FA_ID_SQL FROM DUAL;

            INSERT INTO BHGMS_F_APPROVE (FA_ID,
                                         FA_NAME,
                                         FA_TYPE,
                                         FA_ISSUER,
                                         FA_CURRENTUSER,
                                         FA_CURRENTNODE,
                                         FA_LASTUSER,
                                         FA_ISSUEDATE,
                                         FA_STATUS,
                                         INSERT_TIME,
                                         ALTER_TIME)
               SELECT FA_ID_SQL,
                         B.BTOF_NAME
                      || SUBSTR (:NEW.FC_DATE, 1, 4)
                      || '年'
                      || SUBSTR (:NEW.FC_DATE, 5, 2)
                      || '月'
                      || SUBSTR (:NEW.FC_DATE, 7, 2)
                      || '日加班申请'
                         AS FA_NAME,
                      '2' AS FA_TYPE,
                      :NEW.FC_CHECKER AS FA_ISSUER,
                      :NEW.FC_CHECKER AS FA_CURRENTUSER,
                      DAN_CURRNODE AS FA_CURRENTNODE,
                      :NEW.FC_CHECKER AS FA_LASTUSER,
                      TO_DATE (:NEW.FC_DATE, 'YYYYMMDD') AS FA_ISSUEDATE,
                      '1' AS FA_STATUS,
                      SYSDATE,
                      SYSDATE
                 FROM BHGMS_U_OFFICER B
                WHERE :NEW.FC_CHECKER = B.BTOF_ID;

            INSERT INTO BHGMS_F_APPROVE_OVERTIME_SUB (FA_ID,
                                                      FAOS_ISSUEDATE,
                                                      FAOS_BEGINTIME,
                                                      FAOS_ENDTIME,
                                                      FAOS_OVERTIME_HOUR,
                                                      FAOS_OVERTIME_MIN,
                                                      FAOS_ORIGIN,
                                                      FAOS_ORIGIN_ID,
                                                      INSERT_TIME,
                                                      ALTER_TIME)
               SELECT FA_ID_SQL,
                      TO_DATE (:NEW.FC_DATE, 'YYYYMMDD') AS FAOS_ISSUEDATE,
                      D.DIT_TIMESTAMP AS FAOS_BEGINTIME,
                      :NEW.FC_CHECKTIME AS FAOS_ENDTIME,
                      PACKAGE_BHGMS_TRANSACTION.
                       GENERATE_HOUR_GAP (D.DIT_TIMESTAMP, :NEW.FC_CHECKTIME),
                      PACKAGE_BHGMS_TRANSACTION.
                       GENERATE_MIN_GAP (D.DIT_TIMESTAMP, :NEW.FC_CHECKTIME),
                      '1' AS FAOS_ORIGIN,
                      :NEW.FC_ID AS FAOS_ORIGIN_ID,
                      SYSDATE,
                      SYSDATE
                 FROM BHGMS_U_OFFICER B2, BHGMS_U_ORGAN B1, BHGMS_D_INTIME D
                WHERE     B2.BTO_ID = B1.BTO_ID
                      AND B1.BTO_CATEGORY = D.BTO_CATEGORY
                      AND :NEW.FC_CHECKER = B2.BTOF_ID
                      AND TO_CHAR (TO_DATE (:NEW.FC_DATE, 'YYYYMMDD') - 1,
                                   'D') = D.DIT_DAYOFWEEK
                      AND D.DIT_TYPE = '2'
                      AND D.DIT_STATUS = '1';
         END;
      END IF;
   END IF;
END;
/
ALTER TRIGGER "BHGMS"."TRIG_POST_CHECKIN_VACATION" ENABLE;
