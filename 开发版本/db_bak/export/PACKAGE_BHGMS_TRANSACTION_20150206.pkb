--------------------------------------------------------
--  文件已创建 - 星期五-二月-06-2015   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body PACKAGE_BHGMS_TRANSACTION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "BHGMS"."PACKAGE_BHGMS_TRANSACTION" 
AS
   FUNCTION GENERATE_PWD_CHAR (USERNAME IN VARCHAR2, PASSWORD IN VARCHAR2)
      RETURN VARCHAR2
   AS
   BEGIN
      RETURN UPPER (
                DBMS_OBFUSCATION_TOOLKIT.
                 MD5 (
                   INPUT => UTL_RAW.
                            CAST_TO_RAW (
                              (CASE
                                  WHEN USERNAME = 'admin' THEN 'admin0'
                                  ELSE USERNAME
                               END)
                              || PASSWORD)));
   END;


   FUNCTION MATCH_PWD (E_USERNAME IN VARCHAR2, E_PASSWORD IN VARCHAR2)
      RETURN NUMBER
   AS
      L_PASSWORD   VARCHAR2 (2000);
      COUNT0       NUMBER;
   BEGIN
      SELECT COUNT (1)
        INTO COUNT0
        FROM BHGMS_U_OFFICER U
       WHERE UPPER (U.BTOF_ID) = UPPER (E_USERNAME) AND U.BTOF_STATUS = '1';

      SELECT UTL_RAW.CAST_TO_RAW (U.PASSWORD)
        INTO L_PASSWORD
        FROM BHGMS_U_LOGIN U
       WHERE UPPER (U.BTOF_ID) = UPPER (E_USERNAME);

      IF COUNT0 = 0
      THEN
         RETURN 0;
      ELSIF UTL_RAW.CAST_TO_RAW (GENERATE_PWD_CHAR (E_USERNAME, E_PASSWORD)) =
               L_PASSWORD
      THEN
         RETURN 2;
      ELSE
         RETURN 1;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

   FUNCTION GENERATE_HOUR_GAP (O_TIME IN VARCHAR2, N_TIME IN VARCHAR2)
      RETURN NUMBER
   AS
   BEGIN
      IF TO_NUMBER (SUBSTR (O_TIME, 1, 2)) >=
            TO_NUMBER (SUBSTR (N_TIME, 1, 2))
      THEN
         RETURN 0;
      ELSIF ( (TO_NUMBER (SUBSTR (O_TIME, 1, 2)) <
                  TO_NUMBER (SUBSTR (N_TIME, 1, 2)))
             AND (TO_NUMBER (SUBSTR (O_TIME, 3, 2)) >
                     TO_NUMBER (SUBSTR (N_TIME, 3, 2))))
      THEN
         BEGIN
            RETURN   TO_NUMBER (SUBSTR (N_TIME, 1, 2))
                   - TO_NUMBER (SUBSTR (O_TIME, 1, 2))
                   - 1;
         END;
      ELSE
         BEGIN
            RETURN TO_NUMBER (SUBSTR (N_TIME, 1, 2))
                   - TO_NUMBER (SUBSTR (O_TIME, 1, 2));
         END;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

   FUNCTION GENERATE_MIN_GAP (O_TIME IN VARCHAR2, N_TIME IN VARCHAR2)
      RETURN NUMBER
   AS
   BEGIN
      IF ( (TO_NUMBER (SUBSTR (O_TIME, 1, 2)) >
               TO_NUMBER (SUBSTR (N_TIME, 1, 2)))
          OR (TO_NUMBER (SUBSTR (O_TIME, 1, 2)) =
                 TO_NUMBER (SUBSTR (N_TIME, 1, 2))
              AND TO_NUMBER (SUBSTR (O_TIME, 3, 2)) >=
                     TO_NUMBER (SUBSTR (N_TIME, 3, 2))))
      THEN
         RETURN 0;
      ELSIF ( (TO_NUMBER (SUBSTR (O_TIME, 1, 2)) <
                  TO_NUMBER (SUBSTR (N_TIME, 1, 2)))
             AND (TO_NUMBER (SUBSTR (O_TIME, 3, 2)) >
                     TO_NUMBER (SUBSTR (N_TIME, 3, 2))))
      THEN
         RETURN   TO_NUMBER (SUBSTR (N_TIME, 3, 2))
                - TO_NUMBER (SUBSTR (O_TIME, 3, 2))
                + 60;
      ELSE
         RETURN TO_NUMBER (SUBSTR (N_TIME, 3, 2))
                - TO_NUMBER (SUBSTR (O_TIME, 3, 2));
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

   FUNCTION GENERATE_HOUR_GAP_IN_DATE (O_DATE IN DATE, N_DATE IN DATE)
      RETURN NUMBER
   IS
      W   INTEGER;
      N   INTEGER := 0;
      D   DATE;
   BEGIN
      IF O_DATE <= N_DATE
      THEN
         D := O_DATE;

         WHILE D >= O_DATE AND D <= N_DATE
         LOOP
            SELECT TO_NUMBER (NVL (ISWORKDATE, '0'))
              INTO W
              FROM C_HOLIDAY
             WHERE CH_DATE = D;

            IF W = 1
            THEN
               N := N + 1;
            END IF;

            D := D + 1;
         END LOOP;

         RETURN N * 8;
      ELSE
         RETURN 0;
      END IF;
   END;

   PROCEDURE UPDATE_PWD (USERNAME     IN VARCHAR2,
                         O_PASSWORD   IN VARCHAR2,
                         N_PASSWORD   IN VARCHAR2)
   IS
      MATCH_RESULT   NUMBER;
   BEGIN
      SELECT MATCH_PWD (USERNAME, O_PASSWORD) INTO MATCH_RESULT FROM DUAL;

      IF MATCH_RESULT = 2
      THEN
         UPDATE BHGMS_U_LOGIN U
            SET U.PASSWORD = GENERATE_PWD_CHAR (USERNAME, N_PASSWORD),
                U.ALTER_TIME = SYSDATE
          WHERE U.BTOF_ID = USERNAME;

         COMMIT;
      END IF;
   END;
   
   PROCEDURE UPDATE_BTOF_YEARS IS
   BEGIN
      UPDATE BHGMS_U_OFFICER U SET U.BTOF_YEARS = U.BTOF_YEARS + 1 WHERE U.BTO_ID LIKE '120%' AND U.BTOF_STATUS <> '2';
      
      COMMIT;
   END;
END;

/
