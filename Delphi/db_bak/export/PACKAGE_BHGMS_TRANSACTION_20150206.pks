--------------------------------------------------------
--  文件已创建 - 星期五-二月-06-2015   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACKAGE_BHGMS_TRANSACTION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BHGMS"."PACKAGE_BHGMS_TRANSACTION" 
AS
   FUNCTION GENERATE_PWD_CHAR (USERNAME IN VARCHAR2, PASSWORD IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION MATCH_PWD (E_USERNAME IN VARCHAR2, E_PASSWORD IN VARCHAR2)
      RETURN NUMBER;

   FUNCTION GENERATE_HOUR_GAP (O_TIME IN VARCHAR2, N_TIME IN VARCHAR2)
      RETURN NUMBER;

   FUNCTION GENERATE_MIN_GAP (O_TIME IN VARCHAR2, N_TIME IN VARCHAR2)
      RETURN NUMBER;

   FUNCTION GENERATE_HOUR_GAP_in_date (O_date IN DATE, N_date IN DATE)
      RETURN NUMBER;

   PROCEDURE UPDATE_PWD (USERNAME     IN VARCHAR2,
                         O_PASSWORD   IN VARCHAR2,
                         N_PASSWORD   IN VARCHAR2);
                         
   PROCEDURE UPDATE_BTOF_YEARS;
END;

/
