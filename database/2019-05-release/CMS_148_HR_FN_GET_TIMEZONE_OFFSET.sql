CREATE OR REPLACE FUNCTION FN_GET_TIMEZONE_OFFSET(
    I_TIMEZONE  IN VARCHAR2 DEFAULT 'America/New_York'
)
RETURN FLOAT
IS
   V_TZ_OFFSET     VARCHAR2(10); 
BEGIN   
    V_TZ_OFFSET := TZ_OFFSET(I_TIMEZONE);
    RETURN SIGN(TO_NUMBER(SUBSTR(V_TZ_OFFSET, 1, 3))) * (TO_NUMBER(SUBSTR(V_TZ_OFFSET, 2, 2)) + TO_NUMBER(SUBSTR(V_TZ_OFFSET, 5, 2)) / 60);
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
END;
/
GRANT EXECUTE ON HHS_CMS_HR.FN_GET_TIMEZONE_OFFSET TO BIZFLOW WITH GRANT OPTION;
/
