IF OBJECT_ID('TempDB..#temp_referrals') IS NOT NULL DROP TABLE #temp_referrals

DECLARE @EndRP INT;
DECLARE @StartRP INT;
 
SET @EndRP = (SELECT MAX(UniqMonthID)
              FROM [Reporting_MESH_MHSDS].[MHS101Referral_Published])
 
SET @StartRP = (@EndRP - 11)

SELECT Distinct(REF.[RecordNumber])
      ,REF.[UniqMonthID]
      ,SF.[ReportingPeriodStartDate]
      ,SF.[ReportingPeriodEndDate]
      ,REF.[AgeServReferDischDate]
      ,REF.[AgeServReferRecDate]
      ,REF.[ClinRespPriorityType]
      ,REF.[DecisionToTreatDate]
      ,REF.[DecisionToTreatTime]
      ,REF.[EFFECTIVE_FROM]
      ,REF.[FirstAttendedContactInRPDate]
      ,REF.[InactTimeRef]
      ,REF.[MHS101UniqID]
      ,REF.[NHSServAgreeLineID]
      ,REF.[OrgIDComm]
      ,REF.[OrgIDProv]
      ,REF.[Person_ID]
      ,MPI.[EthnicCategory]
      ,MPI.[EthnicCategory2021]
      ,CASE WHEN MPI.GenderIDCode IN ('1','2','3','4','X','Z') THEN MPI.GenderIDCode ELSE MPI.[Gender] END AS Gender
      ,MPI.[ElectoralWard]
      ,MPI.[LADistrictAuth]
      ,MPI.[LSOA2011]
      ,REF.[PrimReasonReferralMH]
      ,REF.[RecordEndDate]
      ,REF.[RecordStartDate]
      ,REF.[ReferralRequestReceivedDate]
      ,REF.[ServDischDate]
      ,REF.[ServiceRequestId]
      ,REF.[SourceOfReferralMH]
      ,REF.[SpecialisedMHServiceCode]
      ,COALESCE(SERV.[ServTeamTypeRefToMH],SERVTD.[ServTeamTypeMH]) AS ServTeamTypeRefToMH
      ,REF.[UniqServReqID]
      ,REF.[UniqSubmissionID]
      ,REF.[Der_Financial_Year]
      ,REF.[Der_Financial_Month]
      ,REF.[NHSEUniqSubmissionID]
      ,REF.[Der_Person_ID]
      ,REF.[CareProfTeamLocalID]
      ,REF.[ReferClosReason]
      ,REF.[ReferRejectionDate]
      ,REF.[ReferRejectReason]
      ,REF.[UniqCareProfTeamLocalID]
      ,SERVTD.[ServTeamTypeMH]
      ,ROW_NUMBER() OVER(PARTITION BY REF.[UniqServReqID], REF.[ReferralRequestReceivedDate] ORDER BY REF.[UniqMonthID]) AS [New_Order]
      ,CASE WHEN REF.[ReferralRequestReceivedDate] BETWEEN SF.[ReportingPeriodStartDate] AND SF.[ReportingPeriodEndDate] THEN 1
            ELSE 0 END AS [New_referral]
      ,ROW_NUMBER() OVER(PARTITION BY REF.[UniqServReqID], REF.[ServDischDate] ORDER BY REF.[UniqMonthID]) AS [Closed_Order]
      ,CASE WHEN REF.[ServDischDate] BETWEEN SF.[ReportingPeriodStartDate] AND SF.[ReportingPeriodEndDate] THEN 1
            ELSE 0 END AS [Closed_referral]
  INTO #temp_referrals
  FROM [Reporting_MESH_MHSDS].[MHS101Referral_Published] AS REF

    INNER JOIN [Reporting_MESH_MHSDS].[MHSDS_SubmissionFlags_Published] AS SF
        ON REF.[NHSEUniqSubmissionID] = SF.[NHSEUniqSubmissionID]
        AND SF.[Der_IsLatest] = 'Y'
   
    LEFT JOIN [Reporting_MESH_MHSDS].[MHS102ServiceTypeReferredTo_Published] AS  SERV
        ON REF.[UniqServReqID] = SERV.[UniqServReqID] AND REF.[RecordNumber] = SERV.[RecordNumber]   
        
    LEFT JOIN [Reporting_MESH_MHSDS].[MHS001MPI_Published] AS MPI
		ON REF.[RecordNumber] = MPI.[RecordNumber]

    LEFT JOIN [Reporting_MESH_MHSDS].[MHS902ServiceTeamDetails_Published] as SERVTD
        ON REF.[UniqCareProfTeamLocalID] = SERVTD.[UniqCareProfTeamLocalID]
        AND REF.[NHSEUniqSubmissionID] = SERVTD.[NHSEUniqSubmissionID]
        AND REF.[UniqMonthID] = SERVTD.[UniqMonthID]

  WHERE REF.[UniqMonthID] BETWEEN @StartRP AND @EndRP
        AND REF.[OrgIDProv] = 'RV5'
        AND REF.[PrimReasonReferralMH] = 12
        AND (SERV.[ServTeamTypeRefToMH] = 'C10' OR SERVTD.[ServTeamTypeMH] = 'C10')
        AND REF.[AgeServReferRecDate] >= 12


SELECT ReportingPeriodEndDate
        ,SUM(New_referral) AS [New_Referrals]
FROM #temp_referrals
WHERE [New_Order] = 1
GROUP BY ReportingPeriodEndDate
ORDER BY ReportingPeriodEndDate


SELECT ReportingPeriodEndDate
        ,SUM(Closed_referral) AS [Closed_Referrals]
FROM #temp_referrals
WHERE [Closed_Order] = 1
GROUP BY ReportingPeriodEndDate
ORDER BY ReportingPeriodEndDate
