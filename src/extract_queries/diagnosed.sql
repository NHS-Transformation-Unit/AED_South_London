IF OBJECT_ID('TempDB..#temp_diags') IS NOT NULL DROP TABLE #temp_diags

DECLARE @EndRP INT;
DECLARE @StartRP INT;
 
SET @EndRP = (SELECT MAX(UniqMonthID)
              FROM [Reporting_MESH_MHSDS].[MHS101Referral_Published])
 
SET @StartRP = (@EndRP - 35)


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
      ,DIAG.[PrimDiag]
      ,ROW_NUMBER() OVER(PARTITION BY DIAG.[PrimDiag], REF.[ReferralRequestReceivedDate] ORDER BY DIAG.[CodedDiagTimestampDatetime]) AS [Diag_Order]
      ,CASE WHEN REF.[ReferralRequestReceivedDate] BETWEEN SF.[ReportingPeriodStartDate] AND SF.[ReportingPeriodEndDate] THEN 1
        ELSE 0 END AS [New_referral]

INTO #temp_diags
FROM [Reporting_MESH_MHSDS].[MHS101Referral_Published] AS REF

    INNER JOIN [Reporting_MESH_MHSDS].[MHSDS_SubmissionFlags_Published] AS SF
        ON REF.[NHSEUniqSubmissionID] = SF.[NHSEUniqSubmissionID]
        AND SF.[Der_IsLatest] = 'Y'

    LEFT JOIN [Reporting_MESH_MHSDS].[MHS001MPI_Published] AS MPI
		ON REF.[RecordNumber] = MPI.[RecordNumber]

    LEFT JOIN [Reporting_MESH_MHSDS].[MHS604PrimDiag_Published] AS DIAG
        ON REF.[UniqServReqID] = DIAG.[UniqServReqID]
        AND REF.[RecordNumber] = DIAG.[RecordNumber]
        AND DIAG.[CodedDiagTimestampDatetime] BETWEEN REF.[ReferralRequestReceivedDate] AND REF.[ServDischDate]

    LEFT JOIN [Reporting_MESH_MHSDS].[MHS102ServiceTypeReferredTo_Published] AS  SERV
        ON REF.[UniqServReqID] = SERV.[UniqServReqID] AND REF.[RecordNumber] = SERV.[RecordNumber]   

    LEFT JOIN [Reporting_MESH_MHSDS].[MHS902ServiceTeamDetails_Published] as SERVTD
        ON REF.[UniqCareProfTeamLocalID] = SERVTD.[UniqCareProfTeamLocalID]
        AND REF.[NHSEUniqSubmissionID] = SERVTD.[NHSEUniqSubmissionID]
        AND REF.[UniqMonthID] = SERVTD.[UniqMonthID]

WHERE REF.[UniqMonthID] BETWEEN @StartRP AND @EndRP
        AND REF.[OrgIDProv] = 'RV5'
        AND (SERV.[ServTeamTypeRefToMH] <> 'C10' OR SERVTD.[ServTeamTypeMH] <> 'C10')
        AND REF.[AgeServReferRecDate] >= 12
        AND [PrimDiag] LIKE 'F50%'
        

SELECT ReportingPeriodEndDate
        ,SUM(New_referral) AS [New_Referrals]
FROM #temp_diags
WHERE [Diag_Order] = 1
GROUP BY ReportingPeriodEndDate
ORDER BY ReportingPeriodEndDate
