create or replace PROCEDURE SP_ERLR_EMPLOYEE_CASE_ADD
(
	I_HHSID IN VARCHAR2,
	I_CASEID IN NUMBER,
	I_FROM_CASEID IN NUMBER,
	I_MEMBER_ID IN VARCHAR2 -- MANUALLY ENTERED CASE IF THIS VALUE IS NOT NULL
)
IS
    V_CNT NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO V_CNT
      FROM ERLR_EMPLOYEE_CASE
     WHERE HHSID = I_HHSID
       AND CASEID = I_CASEID;

    IF 0=V_CNT THEN
        IF I_MEMBER_ID IS NULL THEN
            INSERT INTO ERLR_EMPLOYEE_CASE(HHSID, CASEID, FROM_CASEID) VALUES(I_HHSID, I_CASEID, I_FROM_CASEID);
        ELSE
            INSERT INTO ERLR_EMPLOYEE_CASE(HHSID, CASEID, FROM_CASEID, M_DT, M_MEMBER_ID, M_MEMBER_NAME)
            SELECT I_HHSID, I_CASEID, I_FROM_CASEID, CAST(SYS_EXTRACT_UTC(SYSTIMESTAMP) AS DATE), I_MEMBER_ID, NAME
              FROM BIZFLOW.MEMBER
             WHERE MEMBERID = I_MEMBER_ID;
        END IF;
    END IF;

EXCEPTION
	WHEN OTHERS THEN
		SP_ERROR_LOG();
END;
/

GRANT EXECUTE ON HHS_CMS_HR.SP_ERLR_EMPLOYEE_CASE_ADD TO HHS_CMS_HR_RW_ROLE;
/