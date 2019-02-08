-- CMS_23_HR_VW_ERLR_GEN.sql
-- CMS_24_HR_VW_ERLR_CNDT_ISSUE.sql
-- CMS_25_HR_VW_ERLR_APPEAL.sql
-- CMS_26_HR_VW_ERLR_WGI_DNL.sql
-- CMS_27_HR_VW_ERLR_MEDDOC.sql
-- CMS_28_HR_VW_ERLR_PERF_ISSUE.sql
-- CMS_29_HR_VW_ERLR_INVESTIGATION.sql
-- CMS_30_HR_VW_ERLR_INFO_REQUEST.sql
-- CMS_31_HR_VW_ERLR_3RDPARTY_HEAR.sql
-- CMS_32_HR_VW_ERLR_PROB_ACTION.sql
-- CMS_33_HR_VW_ERLR_GRIEVANCE.sql
-- CMS_34_HR_VW_ERLR_ULP.sql
-- CMS_35_HR_VW_ERLR_LABOR_NEGO.sql
-- CMS_40_HR_VW_ERLR_EMPLOYEE_CASE.sql

--------------------------------------------------------
--  DDL for VW_ERLR_GEN
--------------------------------------------------------

CREATE OR REPLACE VIEW VW_ERLR_GEN
AS
SELECT
    EG.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
	, (SELECT M.NAME FROM BIZFLOW.MEMBER M WHERE M.MEMBERID = EG.GEN_PRIMARY_SPECIALIST AND ROWNUM = 1)  AS GEN_PRIMARY_SPECIALIST_NAME	
	, (SELECT M.NAME FROM BIZFLOW.MEMBER M WHERE M.MEMBERID = EG.GEN_SECONDARY_SPECIALIST AND ROWNUM = 1)  AS GEN_SECONDARY_SPECIALIST_NAME
	, EG.GEN_CUSTOMER_NAME
	, EG.GEN_CUSTOMER_PHONE
	, EG.GEN_CUSTOMER_ADMIN_CD
	, EG.GEN_CUSTOMER_ADMIN_CD_DESC
	, EG.GEN_EMPLOYEE_NAME
	, EG.GEN_EMPLOYEE_PHONE
	, EG.GEN_EMPLOYEE_ADMIN_CD
	, EG.GEN_EMPLOYEE_ADMIN_CD_DESC
	, FN_GET_2ND_SUB_ORG(EG.GEN_EMPLOYEE_ADMIN_CD) AS GEN_EMPLOYEE_2ND_SUB_ORG
	, EG.GEN_CASE_DESC
	, EG.GEN_CASE_STATUS
	, EG.GEN_CUST_INIT_CONTACT_DT
	, EG.GEN_PRIMARY_REP_AFFILIATION
	, EG.GEN_CMS_PRIMARY_REP_ID AS GEN_CMS_PRIMARY_REP_NAME
	, EG.GEN_CMS_PRIMARY_REP_PHONE
	, EG.GEN_NON_CMS_PRIMARY_FNAME
	, EG.GEN_NON_CMS_PRIMARY_MNAME
	, EG.GEN_NON_CMS_PRIMARY_LNAME
	, EG.GEN_NON_CMS_PRIMARY_EMAIL
	, EG.GEN_NON_CMS_PRIMARY_PHONE
	, EG.GEN_NON_CMS_PRIMARY_ORG
	, EG.GEN_NON_CMS_PRIMARY_ADDR
	, (SELECT L.TBL_LABEL FROM TBL_LOOKUP L WHERE L.TBL_ID = EG.GEN_CASE_TYPE AND ROWNUM = 1) AS GEN_CASE_TYPE
	, FN_GET_CASE_CATEGORY(EG.GEN_CASE_CATEGORY) AS GEN_CASE_CATEGORY
	, EG.GEN_INVESTIGATION
	, EG.GEN_INVESTIGATE_START_DT
	, EG.GEN_INVESTIGATE_END_DT
	, EG.GEN_STD_CONDUCT
	, GEN_STD_CONDUCT_TYPE
	, CC_FINAL_ACTION
	, EG.CC_CASE_COMPLETE_DT
	, (SELECT STATE FROM BIZFLOW.PROCS P WHERE P.PROCID = EC.PROCID) AS BF_PROCS_STATE
	, (SELECT MOD_DT FROM TBL_FORM_DTL FD WHERE FD.PROCID = EC.PROCID) AS LAST_MOD_DT
	, ETPH.THRD_PRTY_APPEAL_TYPE
FROM
	ERLR_GEN EG
    LEFT OUTER JOIN ERLR_CASE EC ON EG.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
	LEFT OUTER JOIN ERLR_3RDPARTY_HEAR ETPH ON EG.ERLR_CASE_NUMBER = ETPH.ERLR_CASE_NUMBER
;
/
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_GEN TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_GEN TO HHS_CMS_HR_DEV_ROLE;
/


--------------------------------------------------------
--  DDL for VW_ERLR_CNDT_ISSUE
--------------------------------------------------------
CREATE OR REPLACE VIEW VW_ERLR_CNDT_ISSUE
AS
SELECT
    CI.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
    , CI_ACTION_TYPE
	, CASE WHEN CI.CI_ADMIN_INVESTIGATORY_LEAVE = '1'  THEN 'Yes' ELSE 'No' END AS CI_ADMIN_INVESTIGATORY_LEAVE	
	, CASE WHEN CI.CI_ADMIN_NOTICE_LEAVE = '1'  THEN 'Yes' ELSE 'No' END AS CI_ADMIN_NOTICE_LEAVE
	, CI.CI_LEAVE_START_DT
	, CI.CI_LEAVE_END_DT
	, CI.CI_APPROVAL_NAME
	, CI.CI_LEAVE_START_DT_2
	, CI.CI_LEAVE_END_DT_2
	, CI.CI_APPROVAL_NAME_2
	, CI.CI_PROP_ACTION_ISSUED_DT
	, CI.CI_ORAL_PREZ_REQUESTED
	, CI.CI_ORAL_PREZ_DT
	, CI.CI_ORAL_RESPONSE_SUBMITTED
	, CI.CI_RESPONSE_DUE_DT
	, CI.CI_WRITTEN_RESPONSE_SBMT_DT
	, CI.CI_POS_TITLE
	, CI.CI_PPLAN
	, CI.CI_SERIES
	, CI.CI_CURRENT_INFO_GRADE
	, CI.CI_CURRENT_INFO_STEP
	, CI.CI_PROPOSED_POS_TITLE
	, CI.CI_PROPOSED_PPLAN
	, CI.CI_PROPOSED_SERIES
	, CI.CI_PROPOSED_INFO_GRADE
	, CI.CI_PROPOSED_INFO_STEP
	, CI.CI_FINAL_POS_TITLE
	, CI.CI_FINAL_PPLAN
	, CI.CI_FINAL_SERIES
	, CI.CI_FINAL_INFO_GRADE
	, CI.CI_FINAL_INFO_STEP
	, CI.CI_DEMO_FINAL_AGNCY_DCSN
	, CI.CI_DECIDING_OFFCL
	, CI.CI_DECISION_ISSUED_DT
	, CI.CI_DEMO_FINAL_AGENCY_EFF_DT
	, CI.CI_NUMB_DAYS
	, CI_COUNSEL_TYPE
	, CI.CI_COUNSEL_ISSUED_DT
	, CI.CI_SICK_LEAVE_ISSUED_DT
	, CI.CI_RESTRICTION_ISSED_DT	
	, CI.CI_SL_WARN_ISSUE
	, CI.CI_NOTICE_ISSUED_DT
	, CI.CI_EFFECTIVE_DT
	, CI.CI_CURRENT_ADMIN_CODE
	, CI.CI_RE_ASSIGNMENT_CURR_ORG
	, CI.CI_FINAL_ADMIN_CODE
	, CI.CI_RE_ASSIGNMENT_FINAL_ORG
	, CI.CI_REMOVAL_PROP_ACTION_DT
	, CI.CI_EMP_NOTICE_LEAVE_PLACED
	, CI.CI_REMOVAL_NOTICE_START_DT
	, CI.CI_REMOVAL_NOTICE_END_DT
	, CI.CI_RMVL_ORAL_PREZ_RQSTED
	, CI.CI_REMOVAL_ORAL_PREZ_DT
	, CI.CI_RMVL_WRTN_RESPONSE
	, CI.CI_WRITTEN_RESPONSE_DUE_DT
	, CI.CI_WRITTEN_SUBMITTED_DT
	, CI_RMVL_FINAL_AGNCY_DCSN
	, CI.CI_DECIDING_OFFCL_NAME
	, CI.CI_RMVL_DATE_DCSN_ISSUED
	, CI.CI_REMOVAL_EFFECTIVE_DT
	, CI.CI_RMVL_NUMB_DAYS
	, CI_SUSPENTION_TYPE
	, CI.CI_SUSP_PROP_ACTION_DT
	, CI.CI_SUSP_ORAL_PREZ_REQUESTED
	, CI.CI_SUSP_ORAL_PREZ_DT
	, CI.CI_SUSP_WRITTEN_RESP
	, CI.CI_SUSP_WRITTEN_RESP_DUE_DT
	, CI.CI_SUSP_WRITTEN_RESP_DT
	, CI_SUSP_FINAL_AGNCY_DCSN
	, CI.CI_SUSP_DECIDING_OFFCL_NAME
	, CI.CI_SUSP_DECISION_ISSUED_DT
	, CI.CI_SUSP_EFFECTIVE_DECISION_DT
	, CI.CI_SUS_NUMB_DAYS
	, CI.CI_REPRIMAND_ISSUE_DT
	, CI.CI_EMP_APPEAL_DECISION
FROM
	ERLR_CNDT_ISSUE CI
    LEFT OUTER JOIN ERLR_CASE EC ON CI.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;
/

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_CNDT_ISSUE TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_CNDT_ISSUE TO HHS_CMS_HR_DEV_ROLE;
/

--------------------------------------------------------
--  DDL for VW_ERLR_APPEAL
--------------------------------------------------------
CREATE OR REPLACE VIEW VW_ERLR_APPEAL
AS
SELECT
    A.ERLR_CASE_NUMBER
    , A.EC.ERLR_JOB_REQ_NUMBER
    , A.EC.PROCID    
    , A.EC.ERLR_CASE_CREATE_DT
    , AP_ERLR_APPEAL_TYPE
	, A.AP_ERLR_APPEAL_FILE_DT
	, A.AP_ERLR_APPEAL_TIMING
	, A.AP_APPEAL_HEARING_REQUESTED
	, A.AP_ARBITRATOR_LAST_NAME
	, A.AP_ARBITRATOR_FIRST_NAME
	, A.AP_ARBITRATOR_MIDDLE_NAME
	, A.AP_ARBITRATOR_EMAIL
	, A.AP_ARBITRATOR_PHONE_NUM
	, A.AP_ARBITRATOR_ORG_AFFIL
	, A.AP_ARBITRATOR_MAILING_ADDR
	, A.AP_ERLR_PREHEARING_DT
	, A.AP_ERLR_HEARING_DT
	, A.AP_POSTHEARING_BRIEF_DUE
	, A.AP_FINAL_ARBITRATOR_DCSN_DT
	, A.AP_ERLR_EXCEPTION_FILED
	, A.AP_ERLR_EXCEPTION_FILE_DT
	, A.AP_RESPON_TO_EXCEPT_DUE
	, A.AP_FINAL_FLRA_DECISION_DT
	, A.AP_ERLR_STEP_DECISION_DT
	, A.AP_ERLR_ARBITRATION_INVOKED
	, A.AP_ARBITRATOR_LAST_NAME_3
	, A.AP_ARBITRATOR_FIRST_NAME_3
	, A.AP_ARBITRATOR_MIDDLE_NAME_3
	, A.AP_ARBITRATOR_EMAIL_3
	, A.AP_ARBITRATOR_PHONE_NUM_3
	, A.AP_ARBITRATOR_ORG_AFFIL_3
	, A.AP_ARBITRATION_MAILING_ADDR_3
	, A.AP_ERLR_PREHEARING_DT_2
	, A.AP_ERLR_HEARING_DT_2
	, A.AP_POSTHEARING_BRIEF_DUE_2
	, A.AP_FINAL_ARBITRATOR_DCSN_DT_2
	, A.AP_ERLR_EXCEPTION_FILED_2
	, A.AP_ERLR_EXCEPTION_FILE_DT_2
	, A.AP_RESPON_TO_EXCEPT_DUE_2
	, A.AP_FINAL_FLRA_DECISION_DT_2
	, A.AP_ARBITRATOR_LAST_NAME_2
	, A.AP_ARBITRATOR_FIRST_NAME_2
	, A.AP_ARBITRATOR_MIDDLE_NAME_2
	, A.AP_ARBITRATOR_EMAIL_2
	, A.AP_ARBITRATOR_PHONE_NUM_2
	, A.AP_ARBITRATOR_ORG_AFFIL_2
	, A.AP_ARBITRATION_MAILING_ADDR_2
	, A.AP_ERLR_PREHEARING_DT_SC
	, A.AP_ERLR_HEARING_DT_SC
	, A.AP_ARBITRATOR_LAST_NAME_4
	, A.AP_ARBITRATOR_FIRST_NAME_4
	, A.AP_ARBITRATOR_MIDDLE_NAME_4
	, A.AP_ARBITRATOR_EMAIL_4
	, A.AP_ARBITRATOR_PHONE_NUM_4
	, A.AP_ARBITRATOR_ORG_AFFIL_4
	, A.AP_ARBITRATOR_MAILING_ADDR_4
	, A.AP_DT_SETTLEMENT_DISCUSSION
	, A.AP_DT_PREHEARING_DISCLOSURE
    , A.AP_DT_AGNCY_FILE_RESPON_DUE
    , A.AP_ERLR_PREHEARING_DT_MSPB
	, A.AP_WAS_DISCOVERY_INITIATED
	, A.AP_ERLR_DT_DISCOVERY_DUE
	, A.AP_ERLR_HEARING_DT_MSPB
	, A.AP_PETITION_FILE_DT_MSPB
	, A.AP_WAS_PETITION_FILED_MSPB
	, A.AP_INITIAL_DECISION_DT_MSPB
	, A.AP_FINAL_BOARD_DCSN_DT_MSPB
	, A.AP_DT_SETTLEMENT_DISCUSSION_2
	, A.AP_DT_PREHEARING_DISCLOSURE_2
	, A.AP_DT_AGNCY_FILE_RESPON_DUE_2
	, A.AP_ERLR_PREHEARING_DT_FLRA
	, A.AP_ERLR_HEARING_DT_FLRA
	, A.AP_INITIAL_DECISION_DT_FLRA
	, A.AP_WAS_PETITION_FILED_FLRA
	, A.AP_PETITION_FILE_DT_FLRA
	, A.AP_FINAL_BOARD_DCSN_DT_FLRA
FROM
	ERLR_APPEAL A
    LEFT OUTER JOIN ERLR_CASE EC ON A.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;
/

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_APPEAL TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_APPEAL TO HHS_CMS_HR_DEV_ROLE;
/


--------------------------------------------------------
--  DDL for VW_ERLR_WGI_DNL
--------------------------------------------------------
CREATE OR REPLACE VIEW VW_ERLR_WGI_DNL
AS
SELECT
    WD.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
    , WGI_DTR_DENIAL_ISSUED_DT
	, WGI_DTR_EMP_REQ_RECON
	, WGI_DTR_RECON_REQ_DT
	, WGI_DTR_RECON_ISSUE_DT
	, WGI_DTR_DENIED
	, WGI_DTR_DENIAL_ISSUE_TO_EMP_DT
	, WGI_RVW_REDTR_NOTI_ISSUED_DT
	, WGI_REVIEW_DTR_FAVORABLE
	, WGI_REVIEW_EMP_REQ_RECON
	, WGI_REVIEW_RECON_REQ_DT
	, WGI_REVIEW_RECON_ISSUE_DT
	, WGI_REVIEW_DENIED
	, WGI_EMP_APPEAL_DECISION    
FROM
	ERLR_WGI_DNL WD
    LEFT OUTER JOIN ERLR_CASE EC ON WD.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;
/

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_WGI_DNL TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_WGI_DNL TO HHS_CMS_HR_DEV_ROLE;
/


--------------------------------------------------------
--  DDL for VW_ERLR_MEDDOC
--------------------------------------------------------
CREATE OR REPLACE VIEW VW_ERLR_MEDDOC
AS
SELECT
    M.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
    , (SELECT L.TBL_LABEL FROM TBL_LOOKUP L WHERE L.TBL_ID = M.MD_REQUEST_REASON AND ROWNUM = 1) AS MD_REQUEST_REASON
	, MD_MED_DOC_SBMT_DEADLINE_DT
	, MD_FMLA_DOC_SBMT_DT
	, MD_FMLA_BEGIN_DT
	, MD_FMLA_APROVED
	, (SELECT L.TBL_LABEL FROM TBL_LOOKUP L WHERE L.TBL_ID = M.MD_FMLA_DISAPRV_REASON AND ROWNUM = 1) AS MD_FMLA_DISAPRV_REASON
	, MD_FMLA_GRIEVANCE
	, MD_MEDEXAM_EXTENDED
	, MD_MEDEXAM_ACCEPTED
	, MD_MEDEXAM_RECEIVED_DT
	, MD_DOC_SUBMITTED
	, MD_DOC_SBMT_DT
	, MD_DOC_SBMT_FOH
	, MD_DOC_REVIEW_OUTCOME
	, MD_DOC_ADMTV_ACCEPTABLE
	, (SELECT L.TBL_LABEL FROM TBL_LOOKUP L WHERE L.TBL_ID = M.MD_DOC_ADMTV_REJECT_REASON AND ROWNUM = 1) AS MD_DOC_ADMTV_REJECT_REASON

FROM
	ERLR_MEDDOC M
    LEFT OUTER JOIN ERLR_CASE EC ON M.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;
/

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_MEDDOC TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_MEDDOC TO HHS_CMS_HR_DEV_ROLE;
/

--------------------------------------------------------
--  DDL for VW_ERLR_PERF_ISSUE
--------------------------------------------------------
CREATE OR REPLACE VIEW VW_ERLR_PERF_ISSUE
AS
SELECT
    PI.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
    , (SELECT L.TBL_LABEL FROM TBL_LOOKUP L WHERE L.TBL_ID = PI_ACTION_TYPE AND ROWNUM = 1) AS PI_ACTION_TYPE
	, PI_NEXT_WGI_DUE_DT
	, PI_PERF_COUNSEL_ISSUE_DT
	, PI_CNSL_GRV_DECISION
	, PI_DMTN_PRPS_ACTN_ISSUE_DT
	, PI_DMTN_ORAL_PRSNT_REQ
	, PI_DMTN_ORAL_PRSNT_DT
	, PI_DMTN_WRTN_RESP_SBMT
	, PI_DMTN_WRTN_RESP_DUE_DT
	, PI_DMTN_WRTN_RESP_SBMT_DT
	, PI_DMTN_CUR_POS_TITLE
	, PI_DMTN_CUR_PAY_PLAN
	, PI_DMTN_CUR_JOB_SERIES
	, PI_DMTN_CUR_GRADE
	, PI_DMTN_CUR_STEP
	, PI_DMTN_PRPS_POS_TITLE
	, PI_DMTN_PRPS_PAY_PLAN
	, PI_DMTN_PRPS_JOB_SERIES
	, PI_DMTN_PRPS_GRADE
	, PI_DMTN_PRP_STEP
	, PI_DMTN_FIN_POS_TITLE
	, PI_DMTN_FIN_PAY_PLAN
	, PI_DMTN_FIN_JOB_SERIES
	, PI_DMTN_FIN_GRADE
	, PI_DMTN_FIN_STEP
	, (SELECT L.TBL_LABEL FROM TBL_LOOKUP L WHERE L.TBL_ID = PI_ACTION_TYPE AND ROWNUM = 1) AS PI_DMTN_FIN_AGCY_DECISION
	, PI_DMTN_FIN_DECIDING_OFC
	, PI_DMTN_FIN_DECISION_ISSUE_DT
	, PI_DMTN_DECISION_EFF_DT
	, PI_DMTN_APPEAL_DECISION
	, PI_PIP_RSNBL_ACMDTN
	, PI_PIP_EMPL_SBMT_MEDDOC
	, PI_PIP_DOC_SBMT_FOH_RVW
	, PI_PIP_WGI_WTHLD
	, PI_PIP_WGI_RVW_DT
	, PI_PIP_MEDDOC_RVW_OUTCOME
	, PI_PIP_START_DT
	, PI_PIP_END_DT
	, PI_PIP_EXT_END_DT
	, PI_PIP_EXT_END_REASON
	, PI_PIP_EXT_END_NOTIFY_DT	
	, PI_PIP_ACTUAL_DT
	, PI_PIP_END_PRIOR_TO_PLAN
	, (SELECT L.TBL_LABEL FROM TBL_LOOKUP L WHERE L.TBL_ID = PI_PIP_END_PRIOR_TO_PLAN_RSN AND ROWNUM = 1) AS PI_PIP_END_PRIOR_TO_PLAN_RSN
	, PI_PIP_SUCCESS_CMPLT
	, PI_PIP_PMAP_RTNG_SIGN_DT
	, PI_PIP_PMAP_RVW_SIGN_DT
	, (SELECT L.TBL_LABEL FROM TBL_LOOKUP L WHERE L.TBL_ID = PI_PIP_PRPS_ACTN AND ROWNUM = 1) AS PI_PIP_PRPS_ACTN
	, PI_PIP_PRPS_ISSUE_DT
	, PI_PIP_ORAL_PRSNT_REQ
	, PI_PIP_ORAL_PRSNT_DT
	, PI_PIP_WRTN_RESP_SBMT
	, PI_PIP_WRTN_RESP_DUE_DT
	, PI_PIP_WRTN_SBMT_DT
	, (SELECT L.TBL_LABEL FROM TBL_LOOKUP L WHERE L.TBL_ID = PI_PIP_FIN_AGCY_DECISION AND ROWNUM = 1) AS PI_PIP_FIN_AGCY_DECISION
	, PI_PIP_DECIDING_OFFICAL
	, PI_PIP_FIN_AGCY_DECISION_DT
	, PI_PIP_DECISION_ISSUE_DT
	, PI_PIP_EFF_ACTN_DT
	, PI_PIP_EMPL_GRIEVANCE
	, PI_PIP_APPEAL_DECISION
	, PI_REASGN_NOTICE_DT
	, PI_REASGN_EFF_DT
	, PI_REASGN_CUR_ADMIN_CD
	, PI_REASGN_CUR_ORG_NM
	, PI_REASGN_FIN_ADMIN_CD
	, PI_REASGN_FIN_ORG_NM
	, PI_RMV_PRPS_ACTN_ISSUE_DT
	, PI_RMV_EMPL_NOTC_LEV
	, PI_RMV_NOTC_LEV_START_DT
	, PI_RMV_NOTC_LEV_END_DT
	, PI_RMV_ORAL_PRSNT_REQ
	, PI_RMV_ORAL_PRSNT_DT
	, PI_RMV_WRTN_RESP_DUE_DT
	, PI_RMV_WRTN_RESP_SBMT_DT
	, (SELECT L.TBL_LABEL FROM TBL_LOOKUP L WHERE L.TBL_ID = PI_RMV_FIN_AGCY_DECISION AND ROWNUM = 1) AS PI_RMV_FIN_AGCY_DECISION
	, PI_RMV_FIN_DECIDING_OFC
	, PI_RMV_DECISION_ISSUE_DT
	, PI_RMV_EFF_DT
	, PI_RMV_NUM_DAYS
	, PI_RMV_APPEAL_DECISION
	, (SELECT L.TBL_LABEL FROM TBL_LOOKUP L WHERE L.TBL_ID = PI_WRTN_NRTV_RVW_TYPE AND ROWNUM = 1) AS PI_WRTN_NRTV_RVW_TYPE
	, PI_WNR_SPCLST_RVW_CMPLT_DT
	, PI_WNR_MGR_RVW_RTNG_DT
	, PI_WNR_CRITICAL_ELM
	, PI_WNR_FIN_RATING
	, PI_WNR_RVW_OFC_CONCUR_DT
	, PI_WNR_WGI_WTHLD
	, PI_WNR_WGI_RVW_DT

FROM
	ERLR_PERF_ISSUE PI
    LEFT OUTER JOIN ERLR_CASE EC ON PI.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;
/

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_PERF_ISSUE TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_PERF_ISSUE TO HHS_CMS_HR_DEV_ROLE;
/

--------------------------------------------------------
--  DDL for VW_ERLR_INVESTIGATION
--------------------------------------------------------
CREATE OR REPLACE VIEW VW_ERLR_INVESTIGATION
AS
SELECT
    I.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
    , INVESTIGATION_TYPE
	, I_MISCONDUCT_FOUND
FROM
	ERLR_INVESTIGATION I
    LEFT OUTER JOIN ERLR_CASE EC ON I.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;
/

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_INVESTIGATION TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_INVESTIGATION TO HHS_CMS_HR_DEV_ROLE;
/


--------------------------------------------------------
--  DDL for VW_ERLR_INFO_REQUEST
--------------------------------------------------------
CREATE OR REPLACE VIEW VW_ERLR_INFO_REQUEST
AS
SELECT
    IR.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
    , IR_REQUESTER
	, IR_CMS_REQUESTER_NAME
	, IR_CMS_REQUESTER_PHONE
	, IR_NCMS_REQUESTER_LAST_NAME
	, IR_NCMS_REQUESTER_FIRST_NAME
	, IR_NON_CMS_REQUESTER_PHONE
	, IR_NON_CMS_REQUESTER_EMAIL
	, IR_NCMS_REQUESTER_ORG_AFFIL
	, IR_SUBMIT_DT
	, IR_MEET_PTCLRIZED_NEED_STND
	, IR_RSNABLY_AVAIL_N_NECESSARY
	, IR_PRTCT_DISCLOSURE_BY_LAW
	, IR_MAINTAINED_BY_AGENCY
	, IR_COLLECTIVE_BARGAINING_UNIT
	, IR_APPROVE
	, IR_APPEAL_DENIAL

FROM
	ERLR_INFO_REQUEST IR
    LEFT OUTER JOIN ERLR_CASE EC ON IR.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;
/

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_INFO_REQUEST TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_INFO_REQUEST TO HHS_CMS_HR_DEV_ROLE;
/


--------------------------------------------------------
--  DDL for VW_ERLR_3RDPARTY_HEAR
--------------------------------------------------------
CREATE OR REPLACE VIEW VW_ERLR_3RDPARTY_HEAR
AS
SELECT
    TPH.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
    , THRD_PRTY_APPEAL_TYPE
	, THRD_PRTY_APPEAL_FILE_DT
	, THRD_PRTY_ASSISTANCE_REQ_DT
	, THRD_PRTY_HEARING_TIMING
	, THRD_PRTY_HEARING_REQUESTED
	, THRD_PRTY_STEP_DECISION_DT
	, THRD_PRTY_ARBITRATION_INVOKED
	, THRD_PRTY_ARBIT_LNM_3
	, THRD_PRTY_ARBIT_FNM_3
	, THRD_PRTY_ARBIT_MNM_3
	, THRD_PRTY_ARBIT_EMAIL_3
	, THRD_ERLR_ARBIT_PHONE_NUM_3
	, THRD_PRTY_ARBIT_ORG_AFFIL_3
	, THRD_PRTY_ARBIT_MAILING_ADDR_3
	, THRD_PRTY_PREHEARING_DT_2
	, THRD_PRTY_HEARING_DT_2
	, THRD_PRTY_POSTHEAR_BRIEF_DUE_2
	, THRD_PRTY_FNL_ARBIT_DCSN_DT_2
	, THRD_PRTY_EXCEPTION_FILED_2
	, THRD_PRTY_EXCEPTION_FILE_DT_2
	, THRD_PRTY_RSPS_TO_EXCPT_DUE_2
	, THRD_PRTY_FNL_FLRA_DCSN_DT_2
	, THRD_PRTY_ARBIT_LNM
	, THRD_PRTY_ARBIT_FNM
	, THRD_PRTY_ARBIT_MNM
	, THRD_PRTY_ARBIT_EMAIL
	, THRD_ERLR_ARBIT_PHONE_NUM
	, THRD_PRTY_ARBIT_ORG_AFFIL
	, THRD_PRTY_ARBIT_MAILING_ADDR
	, THRD_PRTY_PREHEARING_DT
	, THRD_PRTY_HEARING_DT
	, THRD_PRTY_POSTHEAR_BRIEF_DUE
	, THRD_PRTY_FNL_ARBIT_DCSN_DT
	, THRD_PRTY_EXCEPTION_FILED
	, THRD_PRTY_EXCEPTION_FILE_DT
	, THRD_PRTY_RSPS_TO_EXCPT_DUE
	, THRD_PRTY_FNL_FLRA_DCSN_DT
	, THRD_PRTY_ARBIT_LNM_4
	, THRD_PRTY_ARBIT_FNM_4
	, THRD_PRTY_ARBIT_MNM_4
	, THRD_PRTY_ARBIT_EMAIL_4
	, THRD_ERLR_ARBIT_PHONE_NUM_4
	, THRD_PRTY_ARBIT_ORG_AFFIL_4
	, THRD_PRTY_ARBIT_MAILING_ADDR_4
	, THRD_PRTY_DT_STLMNT_DSCUSN
	, THRD_PRTY_DT_PREHEAR_DSCLS
	, THRD_PRTY_DT_AGNCY_RSP_DUE
	, THRD_PRTY_PREHEARING_DT_MSPB
	, THRD_PRTY_WAS_DSCVRY_INIT
	, THRD_PRTY_DT_DISCOVERY_DUE
	, THRD_PRTY_HEARING_DT_MSPB
	, THRD_PRTY_INIT_DCSN_DT_MSPB
	, THRD_PRTY_WAS_PETI_FILED_MSPB
	, THRD_PRTY_PETITION_RV_DT
	, THRD_PRTY_FNL_BRD_DCSN_DT_MSPB
	, THRD_PRTY_DT_STLMNT_DSCUSN_2
	, THRD_PRTY_DT_PREHEAR_DSCLS_2
	, THRD_PRTY_PREHEARING_CONF
	, THRD_PRTY_HEARING_DT_FLRA
	, THRD_PRTY_DECISION_DT_FLRA
	, THRD_PRTY_TIMELY_REQ
    , THRD_PRTY_PROC_ORDER
	, THRD_PRTY_PANEL_MEMBER_LNAME
	, THRD_PRTY_PANEL_MEMBER_FNAME
	, THRD_PRTY_PANEL_MEMBER_MNAME
	, THRD_PRTY_PANEL_MEMBER_EMAIL
	, THRD_PRTY_PANEL_MEMBER_PHONE
	, THRD_PRTY_PANEL_MEMBER_ORG
	, THRD_PRTY_PANEL_MEMBER_MAILING
	, THRD_PRTY_PANEL_DESCR
FROM
	ERLR_3RDPARTY_HEAR TPH
    LEFT OUTER JOIN ERLR_CASE EC ON TPH.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;
/

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_3RDPARTY_HEAR TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_3RDPARTY_HEAR TO HHS_CMS_HR_DEV_ROLE;
/

--------------------------------------------------------
--  DDL for VW_ERLR_PROB_ACTION
--------------------------------------------------------
CREATE OR REPLACE VIEW VW_ERLR_PROB_ACTION
AS
SELECT
    PA.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
    , PPA_ACTION_TYPE
	, PPA_TERMINATION_TYPE
	, PPA_TERM_PROP_ACTION_DT
	, PPA_TERM_ORAL_PREZ_REQUESTED
	, PPA_TERM_ORAL_PREZ_DT
	, PPA_TERM_WRITTEN_RESP
	, PPA_TERM_WRITTEN_RESP_DUE_DT
	, PPA_TERM_WRITTEN_RESP_DT
	, PPA_TERM_AGENCY_DECISION	
    , PPA_TERM_DECIDING_OFFCL_NAME
	, PPA_TERM_DECISION_ISSUED_DT
	, PPA_TERM_EFFECTIVE_DECISION_DT
	, PPA_PROB_TERM_DCSN_ISSUED_DT
	, PPA_PROBATION_CONDUCT
	, PPA_PROBATION_PERFORMANCE
	, PPA_APPEAL_GRIEVANCE_DEADLINE
	, PPA_EMP_APPEAL_DECISION
	, PPA_PROP_ACTION_ISSUED_DT
	, PPA_ORAL_PREZ_REQUESTED
	, PPA_ORAL_PREZ_DT
	, PPA_ORAL_RESPONSE_SUBMITTED
	, PPA_RESPONSE_DUE_DT
	, PPA_WRITTEN_RESPONSE_SBMT_DT
	, PPA_POS_TITLE
	, PPA_PPLAN
	, PPA_SERIES
	, PPA_CURRENT_INFO_GRADE
	, PPA_CURRENT_INFO_STEP
	, PPA_PROPOSED_POS_TITLE
	, PPA_PROPOSED_PPLAN
	, PPA_PROPOSED_SERIES
	, PPA_PROPOSED_INFO_GRADE
	, PPA_PROPOSED_INFO_STEP
	, PPA_FINAL_POS_TITLE
	, PPA_FINAL_PPLAN
	, PPA_FINAL_SERIES
	, PPA_FINAL_INFO_GRADE
	, PPA_FINAL_INFO_STEP
	, PPA_NOTICE_ISSUED_DT
	, PPA_DEMO_FINAL_AGENCY_DECISION
	, PPA_DECIDING_OFFCL
	, PPA_DECISION_ISSUED_DT
	, PPA_DEMO_FINAL_AGENCY_EFF_DT
	, PPA_NUMB_DAYS
	, PPA_EFFECTIVE_DT
	, PPA_CURRENT_ADMIN_CODE
	, PPA_RE_ASSIGNMENT_CURR_ORG
	, PPA_FINAL_ADMIN_CODE
	, PPA_FINAL_ADMIN_CODE_FINAL_ORG
FROM
	ERLR_PROB_ACTION PA
    LEFT OUTER JOIN ERLR_CASE EC ON PA.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;
/

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_PROB_ACTION TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_PROB_ACTION TO HHS_CMS_HR_DEV_ROLE;
/

CREATE OR REPLACE VIEW VW_ERLR_GRIEVANCE
AS
SELECT
    G.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
    , GI_TYPE
	, GI_NEGOTIATED_GRIEVANCE_TYPE
    , CASE WHEN GI_TYPE = 'Negotiated' and GI_NEGOTIATED_GRIEVANCE_TYPE = 'Individual' THEN GI_FILING_DT_2 ELSE GI_FILING_DT END AS GI_GRIEVANCE_FILED_DT
    , CASE WHEN GI_TYPE = 'Negotiated' and GI_NEGOTIATED_GRIEVANCE_TYPE = 'Individual' THEN GI_TIMELY_FILING_2 ELSE GI_TIMELY_FILING END AS GI_TIMELY_FILING
	, GI_IND_MANAGER
	, GI_IND_MEETING_DT
    , CASE WHEN GI_TYPE = 'Negotiated' and GI_NEGOTIATED_GRIEVANCE_TYPE = 'Individual' THEN GI_IND_DECISION_ISSUE_DT WHEN GI_TYPE = 'Administrative' THEN GI_ADMIN_STG_1_DECISION_DT ELSE null END AS GI_STEP_STAGE_1_DT
    , CASE WHEN GI_TYPE = 'Negotiated' and GI_NEGOTIATED_GRIEVANCE_TYPE = 'Individual' THEN GI_IND_STEP_2_DCSN_ISSUE_DT WHEN GI_TYPE = 'Administrative' THEN GI_ADMIN_STG_2_ISSUE_DT ELSE null END AS GI_STEP_STAGE_2_DT
	, GI_IND_STEP_1_DECISION_DT
    , GI_IND_STEP_1_DEADLINE
    , GI_IND_STEP_1_EXT_DUE_DT
    , GI_IND_STEP_1_EXT_DUE_REASON	
	, GI_STEP_2_REQUEST
	, GI_IND_STEP_2_MTG_DT
	, GI_IND_STEP_2_DECISION_DUE_DT	
	, GI_IND_STEP_2_DEADLINE
	, GI_IND_EXT_2_EXT_DUE_DT
	, GI_IND_STEP_2_EXT_DUE_REASON	
    , CASE WHEN GI_TYPE = 'Negotiated' and GI_NEGOTIATED_GRIEVANCE_TYPE = 'Individual' THEN G.GI_IND_THIRD_APPEAL_REQUEST 
    WHEN GI_TYPE = 'Negotiated' and GI_NEGOTIATED_GRIEVANCE_TYPE = 'Union' THEN G.GI_ARBITRATION_REQUEST 
    WHEN GI_TYPE = 'Negotiated' and GI_NEGOTIATED_GRIEVANCE_TYPE = 'Management' THEN G.GI_ARBITRATION_REQUEST 	
    ELSE null END AS GI_ARBITRATION_REQUEST
	, CASE WHEN GI_TYPE = 'Negotiated' and GI_NEGOTIATED_GRIEVANCE_TYPE = 'Individual' THEN G.GI_IND_THIRD_PARTY_APPEAL_DT 
    WHEN GI_TYPE = 'Negotiated' and GI_NEGOTIATED_GRIEVANCE_TYPE = 'Union' THEN G.GI_ARBITRATION_DEADLINE_DT 
    WHEN GI_TYPE = 'Negotiated' and GI_NEGOTIATED_GRIEVANCE_TYPE = 'Management' THEN G.GI_ARBITRATION_DEADLINE_DT 	
    ELSE null END AS GI_ARBITRATION_DEADLINE_DT	
    , GI_UM_GRIEVABILITY
	, GI_MEETING_DT
	, GI_GRIEVANCE_STATUS
	, GI_ADMIN_OFFCL_1	
	, GI_ADMIN_STG_1_ISSUE_DT
	, GI_ADMIN_STG_2_RESP
	, GI_ADMIN_OFFCL_2
	, GI_ADMIN_STG_2_DECISION_DT	
FROM
	ERLR_GRIEVANCE G
    LEFT OUTER JOIN ERLR_CASE EC ON G.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_GRIEVANCE TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_GRIEVANCE TO HHS_CMS_HR_DEV_ROLE;

--------------------------------------------------------
--  DDL for VW_ERLR_ULP
--------------------------------------------------------
CREATE OR REPLACE VIEW VW_ERLR_ULP
AS
SELECT
    U.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
    , ULP_RECEIPT_CHARGE_DT
	, ULP_CHARGE_FILED_TIMELY
	, ULP_AGENCY_RESPONSE_DT
	, ULP_FLRA_DOCUMENT_REUQESTED
	, ULP_DOC_SUBMISSION_FLRA_DT
	, ULP_DOCUMENT_DESCRIPTION
	, ULP_DISPOSITION_DT
	, ULP_DISPOSITION_TYPE
	, ULP_COMPLAINT_DT
	, ULP_AGENCY_ANSWER_DT
	, ULP_AGENCY_ANSWER_FILED_DT
	, ULP_SETTLEMENT_DISCUSSION_DT
	, ULP_PREHEARING_DISCLOSURE_DUE
	, ULP_PREHEARING_DISCLOSUE_DT
	, ULP_PREHEARING_CONFERENCE_DT
	, ULP_HEARING_DT
	, ULP_DECISION_DT
	, ULP_EXCEPTION_FILED
	, ULP_EXCEPTION_FILED_DT
FROM
	ERLR_ULP U
    LEFT OUTER JOIN ERLR_CASE EC ON U.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;
/

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_ULP TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_ULP TO HHS_CMS_HR_DEV_ROLE;
/

--------------------------------------------------------
--  DDL for VW_ERLR_LABOR_NEGO
--------------------------------------------------------
CREATE OR REPLACE VIEW VW_ERLR_LABOR_NEGO
AS
SELECT
    LN.ERLR_CASE_NUMBER
    , EC.ERLR_JOB_REQ_NUMBER
    , EC.PROCID    
    , EC.ERLR_CASE_CREATE_DT
    , LN_NEGOTIATION_TYPE	
    , LN_INITIATOR
	, LN_DEMAND2BARGAIN_DT
	, LN_BRIEFING_REQUEST
	, LN_PROPOSAL_SUBMISSION_DT
	, LN_PROPOSAL_SUBMISSION
	, LN_PROPOSAL_NEGOTIABLE
	, LN_NON_NEGOTIABLE_LETTER
	, LN_FILE_ULP
	, LN_PROPOSAL_INFO_GROUND_RULES
	, LN_PRPSAL_INFO_NEG_COMMENCE_DT
	, LN_LETTER_PROVIDED
	, LN_LETTER_PROVIDED_DT
	, LN_NEGOTIABLE_PROPOSAL
	, LN_BARGAINING_BEGAN_DT
	, LN_IMPASSE_DT
	, LN_FSIP_DECISION_DT
	, LN_BARGAINING_END_DT
	, LN_AGREEMENT_DT
	, LN_SUMMARY_OF_ISSUE
	, LN_SECON_LETTER_REQUEST
	, LN_2ND_LETTER_PROVIDED
	, LN_NEGOTIABL_ISSUE_SUMMARY
	, LN_MNGMNT_ARTICLE4_NTC_DT
	, LN_MNGMNT_NOTICE_RESPONSE
	, LN_MNGMNT_BRIEFING_REQUEST
	, LN_MNGMNT_BARGAIN_SBMSSION_DT
	, LN_MNGMNT_PROPOSAL_SBMSSION
    , LN_BRIEFING_DT
    , LN_2ND_PROVIDED_DT
    , LN_BRIEFING_REQUESTED2_DT
FROM
	ERLR_LABOR_NEGO LN
    LEFT OUTER JOIN ERLR_CASE EC ON LN.ERLR_CASE_NUMBER = EC.ERLR_CASE_NUMBER
;
/

GRANT SELECT ON HHS_CMS_HR.VW_ERLR_LABOR_NEGO TO HHS_CMS_HR_RW_ROLE;
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_LABOR_NEGO TO HHS_CMS_HR_DEV_ROLE;
/

CREATE OR REPLACE FORCE VIEW VW_ERLR_EMPLOYEE_CASE AS 
  SELECT * 
    FROM ERLR_EMPLOYEE_CASE     
  ORDER BY CASEID;
/
GRANT SELECT ON HHS_CMS_HR.VW_ERLR_EMPLOYEE_CASE TO BIZFLOW;
/

