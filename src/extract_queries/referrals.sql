IF OBJECT_ID('TempDB..#temp_referrals') IS NOT NULL DROP TABLE #temp_referrals
IF OBJECT_ID('TempDB..#temp_new_refs') IS NOT NULL DROP TABLE #temp_new_refs
IF OBJECT_ID('TempDB..#temp_new_refs') IS NOT NULL DROP TABLE #temp_new_refs_diags

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
      ,CASE WHEN REF.[OrgIDProv] IN ('RV5', 'RPG', 'RQY') THEN 'SL Provider' ELSE 'Non-SL Provider' END AS [SL_Provider_Flag]
      ,REF.[Person_ID]
      ,ETH.[Main_Description_60_Chars] AS [Ethnic_Category_Main_Desc]
      ,CASE WHEN MPI.GenderIDCode IN ('1','2','3','4','X','Z') THEN MPI.GenderIDCode ELSE MPI.[Gender] END AS Gender
      ,MPI.[ElectoralWard]
      ,MPI.[LADistrictAuth]
      ,MPI.[LSOA2011]
      ,LA.[LAD16CD]
      ,LA.[LAD16NM]
      ,CASE WHEN LA.[LAD16CD] IN ('E09000004', -- Bexley
                             'E09000006', -- Bromley
                             'E09000008', -- Croydon
                             'E09000011', -- Greenwich
                             'E09000021', -- Kingston upon Thames
                             'E09000022', -- Lambeth
                             'E09000023', -- Lewisham
                             'E09000024', -- Merton
                             'E09000027', -- Richmond
                             'E09000028', -- Southwark
                             'E09000029', -- Sutton
                             'E09000032') -- Wandsworth
                             THEN 'SL Resident' ELSE 'Non-SL Resident' END AS [SL_Resident_Flag]
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

    LEFT JOIN [UKHD_Data_Dictionary].[Ethnic_Category_Code_SCD] AS ETH
        ON MPI.[EthnicCategory] = ETH.[Main_Code_Text]
        AND ETH.[Is_Latest] = 1

    LEFT JOIN [Internal_Reference].[LSOAs_to_Higher_Geographies] AS LA
        ON MPI.[LADistrictAuth] = LA.[LAD16CD]

    LEFT JOIN [Reporting_MESH_MHSDS].[MHS902ServiceTeamDetails_Published] as SERVTD
        ON REF.[UniqCareProfTeamLocalID] = SERVTD.[UniqCareProfTeamLocalID]
        AND REF.[NHSEUniqSubmissionID] = SERVTD.[NHSEUniqSubmissionID]
        AND REF.[UniqMonthID] = SERVTD.[UniqMonthID]

  WHERE REF.[UniqMonthID] BETWEEN @StartRP AND @EndRP
        AND (REF.[PrimReasonReferralMH] = '12' OR (SERV.[ServTeamTypeRefToMH] = 'C10' OR SERVTD.[ServTeamTypeMH] = 'C10'))
        AND REF.[AgeServReferRecDate] >= 12
        AND (LA.[LAD16CD] IN ('E09000004', -- Bexley
                             'E09000006', -- Bromley
                             'E09000008', -- Croydon
                             'E09000011', -- Greenwich
                             'E09000021', -- Kingston upon Thames
                             'E09000022', -- Lambeth
                             'E09000023', -- Lewisham
                             'E09000024', -- Merton
                             'E09000027', -- Richmond
                             'E09000028', -- Southwark
                             'E09000029', -- Sutton
                             'E09000032') -- Wandsworth

                OR REF.[OrgIDProv] IN ('RV5', 'RPG', 'RQY')
                )
                             
SELECT *
INTO #temp_new_refs
FROM #temp_referrals
WHERE [New_Order] = 1

DROP TABLE #temp_referrals

SELECT nref.*
      ,DIAG.[PrimDiag]
      ,DIAG.[CodedDiagTimeStamp]
      ,ROW_NUMBER () OVER(PARTITION BY nref.[UniqServReqID], nref.[ReferralRequestReceivedDate] ORDER BY ABS(DATEDIFF(D,nref.[ReferralRequestReceivedDate],DIAG.[CodedDiagTimeStamp])) ASC) AS [EarliestDiag]
      ,ROW_NUMBER () OVER(PARTITION BY nref.[UniqServReqID], nref.[ReferralRequestReceivedDate] ORDER BY ABS(DATEDIFF(D,nref.[ReferralRequestReceivedDate],DIAG.[CodedDiagTimeStamp])) DESC) AS [LatestDiag]
INTO #temp_new_refs_diags
FROM #temp_new_refs as nref

LEFT JOIN [Reporting_MESH_MHSDS].[MHS604PrimDiag_Published] AS DIAG
ON nref.[Der_Person_ID] = DIAG.[Der_Person_ID]
AND DIAG.[CodedDiagTimeStamp] >= nref.[ReferralRequestReceivedDate]

DROP TABLE #temp_new_refs

SELECT * FROM #temp_new_refs_diags
WHERE [EarliestDiag] = 1
