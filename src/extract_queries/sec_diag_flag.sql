
SELECT DISTINCT REFS.[Der_Person_ID]
      ,REFS.[ReferralRequestReceivedDate]
      ,REPLACE(SDIAG.[SecDiag],'.','') AS [SecondaryDiag]
      ,SDIAG.[CodedDiagTimeStamp]
      ,CASE WHEN SDIAG.[CodedDiagTimeStamp] IS NULL THEN NULL
            WHEN SDIAG.[CodedDiagTimeStamp] < REFS.[ReferralRequestReceivedDate]
            THEN 'Diag_Pre_Ref' ELSE 'Diag_Post_Ref'
            END AS [Diag_Time]
      ,CASE WHEN REPLACE(SDIAG.[SecDiag],'.','') IN ('F840', 'F845', 'F841') THEN 1 ELSE 0 END AS [Autism_Sec_Diag]
      ,CASE WHEN LEFT(REPLACE(SDIAG.[SecDiag],'.',''), 2) = 'F7' THEN 1 ELSE 0 END AS [LD_Sec_Diag]
      ,CASE WHEN LEFT(REPLACE(SDIAG.[SecDiag],'.',''), 3) = 'F90' THEN 1 ELSE 0 END AS [ADHD_Sec_Diag]
      ,CASE WHEN LEFT(REPLACE(SDIAG.[SecDiag],'.',''), 2) = 'F6' THEN 1 ELSE 0 END AS [Pers_Dis_Sec_Diag]
      ,CASE WHEN REPLACE(SDIAG.[SecDiag],'.','') = 'F431' THEN 1 ELSE 0 END AS [PTSD_Sec_Diag]
      ,CASE WHEN LEFT(REPLACE(SDIAG.[SecDiag],'.',''), 3) IN ('F32', 'F33')  THEN 1 ELSE 0 END AS [Major_Dep_Dis_Sec_Diag]
      ,CASE WHEN LEFT(REPLACE(SDIAG.[SecDiag],'.',''), 3) IN ('F40', 'F41')  THEN 1 ELSE 0 END AS [Anx_Dis_Sec_Diag]
      ,CASE WHEN LEFT(REPLACE(SDIAG.[SecDiag],'.',''), 1) = 'F1' THEN 1 ELSE 0 END AS [Subs_Use_Dis_Sec_Diag]

FROM #temp_new_refs AS [REFS]

LEFT JOIN [Reporting_MESH_MHSDS].[MHS605SecDiag_Published] AS SDIAG
        ON REFS.[Der_Person_ID] = SDIAG.[Der_Person_ID]
        