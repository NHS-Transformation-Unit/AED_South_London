IF OBJECT_ID('TempDB..#temp_referrals') IS NOT NULL DROP TABLE #temp_referrals
IF OBJECT_ID('TempDB..#temp_new_refs') IS NOT NULL DROP TABLE #temp_new_refs
IF OBJECT_ID('TempDB..#temp_new_refs_diags') IS NOT NULL DROP TABLE #temp_new_refs_diags
IF OBJECT_ID('TempDB..#temp_newref_diag_flag') IS NOT NULL DROP TABLE #temp_newref_diag_flag
IF OBJECT_ID('TempDB..#temp_newref_diag2') IS NOT NULL DROP TABLE #temp_newref_diag2

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
      ,IMD.[IMD19dec]
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
      ,CASE WHEN REF.[ReferRejectionDate] IS NULL THEN 0
            ELSE 1 END AS [Rejected_Flag]
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
            
        LEFT JOIN [Internal_Hierarchies].[lsoa11_mapperMarch2026] AS IMD
            ON MPI.[LSOA2011] = IMD.[LSOA11]

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
      ,REPLACE(DIAG.[PrimDiag],'.','') AS [PrimaryDiag]
      ,DIAG.[CodedDiagTimeStamp]
      ,ROW_NUMBER () OVER(PARTITION BY nref.[UniqServReqID], nref.[ReferralRequestReceivedDate] ORDER BY ABS(DATEDIFF(D,nref.[ReferralRequestReceivedDate],DIAG.[CodedDiagTimeStamp])) ASC) AS [EarliestDiag]
      ,ROW_NUMBER () OVER(PARTITION BY nref.[UniqServReqID], nref.[ReferralRequestReceivedDate] ORDER BY ABS(DATEDIFF(D,nref.[ReferralRequestReceivedDate],DIAG.[CodedDiagTimeStamp])) DESC) AS [LatestDiag]
INTO #temp_new_refs_diags
FROM #temp_new_refs as nref

LEFT JOIN [Reporting_MESH_MHSDS].[MHS604PrimDiag_Published] AS DIAG
ON nref.[Der_Person_ID] = DIAG.[Der_Person_ID]
AND DIAG.[CodedDiagTimeStamp] >= nref.[ReferralRequestReceivedDate]

DROP TABLE #temp_new_refs


SELECT tnrd.*
      ,DIAGDESC.Description
      ,CASE WHEN IDENT.AutismStatus IN ('1','2','3','4') THEN 1 
            ELSE 0 END AS [AutismFlag]
      ,CASE WHEN IDENT.LDStatus IN ('1','2','3','4') THEN 1 
            ELSE 0 END AS [LDFlag]
      ,ROW_NUMBER () OVER(PARTITION BY tnrd.[UniqServReqID], tnrd.[ReferralRequestReceivedDate] ORDER BY tnrd.[UniqMonthID] ASC) AS [EarliestFlag]
      ,ROW_NUMBER () OVER(PARTITION BY tnrd.[UniqServReqID], tnrd.[ReferralRequestReceivedDate] ORDER BY tnrd.[UniqMonthID] DESC) AS [LatestFlag]


INTO #temp_newref_diag_flag    
FROM #temp_new_refs_diags AS tnrd

LEFT JOIN [UKHD_ICD10].[Codes_And_Titles_And_MetaData] AS DIAGDESC
        ON tnrd.[PrimaryDiag] = DIAGDESC.[Alt_Code]
        AND DIAGDESC.[ICD_Version] = 'ICD10 5th Edition'

LEFT JOIN [Reporting_MESH_MHSDS].[MHS005PatInd_Published] AS IDENT
        ON tnrd.[Der_Person_ID] = IDENT.[Der_Person_ID]
        
WHERE [LatestDiag] = 1

DROP TABLE #temp_new_refs_diags

SELECT *
FROM #temp_newref_diag_flag
WHERE [LatestFlag] = 1


-------------------------------------------------------------------------------
--Use of SecDiag table for identify Autism, LD, ARFID and Binge
-- #temp_newref_diag2 has 2.7mill rows
-------------------------------------------------------------------------------


--IF OBJECT_ID('TempDB..#temp_newref_diag2') IS NOT NULL DROP TABLE #temp_newref_diag2

--SELECT tnrd.[Der_Person_ID]
--      ,tnrd.[ReferralRequestReceivedDate]
--      ,CASE WHEN LEFT(diag2.[SecDiag],3) = 'F84' THEN 1 
--            ELSE 0 END AS [AutismFlag]
--      ,CASE WHEN LEFT(diag2.[SecDiag],3) = 'F81' THEN 1 
--            ELSE 0 END AS [LDFlag]
--      ,CASE WHEN diag2.[SecDiag] = 'F5082' THEN 1 
--            ELSE 0 END AS [ARFIDFlag]
--      ,CASE WHEN diag2.[SecDiag] = 'F5081' THEN 1 
--            ELSE 0 END AS [BingeFlag]
--      ,ROW_NUMBER () OVER(PARTITION BY tnrd.[Der_Person_ID] ORDER BY tnrd.[ReferralRequestReceivedDate] DESC) AS [LatestRef]


--INTO #temp_newref_diag2    
--FROM #temp_new_refs_diags AS tnrd

--LEFT JOIN [Reporting_MESH_MHSDS].[MHS605SecDiag_Published] AS diag2
--        ON tnrd.[Der_Person_ID] = diag2.[Der_Person_ID]
--        AND tnrd.[ReferralRequestReceivedDate] >= diag2.[CodedDiagTimestamp]

--SELECT *
--FROM #temp_newref_diag2
--WHERE [LatestRef] = 1
----------------------------------------------
