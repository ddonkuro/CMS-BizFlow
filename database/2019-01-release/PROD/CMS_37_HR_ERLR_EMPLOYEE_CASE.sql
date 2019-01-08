CREATE TABLE ERLR_EMPLOYEE_CASE
(
	HHSID VARCHAR2(64) NOT NULL,
	CASEID NUMBER(10) NOT NULL,    
	FROM_CASEID NUMBER(10),
	M_DT DATE,
	M_MEMBER_ID VARCHAR2(10),
	M_MEMBER_NAME NVARCHAR2(100)
);

ALTER TABLE ERLR_EMPLOYEE_CASE ADD CONSTRAINT ERLR_EMPLOYEE_CASE_PK PRIMARY KEY (HHSID, CASEID);
/
