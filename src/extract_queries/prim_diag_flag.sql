
SELECT DISTINCT REFS.[Der_Person_ID]
      ,REFS.[ReferralRequestReceivedDate]
      ,REPLACE(PDIAG.[PrimDiag],'.','') AS [PrimaryDiag]
      ,PDIAG.[CodedDiagTimeStamp]
      ,CASE WHEN PDIAG.[CodedDiagTimeStamp] IS NULL THEN NULL
            WHEN PDIAG.[CodedDiagTimeStamp] < REFS.[ReferralRequestReceivedDate]
            THEN 'Diag_Pre_Ref' ELSE 'Diag_Post_Ref'
            END AS [Diag_Time]
      ,CASE WHEN REPLACE(PDIAG.[PrimDiag],'.','') IN ('F840', 'F845', 'F841') THEN 1 ELSE 0 END AS [Autism_Prim_Diag]
      ,CASE WHEN LEFT(REPLACE(PDIAG.[PrimDiag],'.',''), 2) = 'F7' THEN 1 ELSE 0 END AS [LD_Prim_Diag]
      ,CASE WHEN LEFT(REPLACE(PDIAG.[PrimDiag],'.',''), 3) = 'F90' THEN 1 ELSE 0 END AS [ADHD_Prim_Diag]
      ,CASE WHEN LEFT(REPLACE(PDIAG.[PrimDiag],'.',''), 2) = 'F6' THEN 1 ELSE 0 END AS [Pers_Dis_Prim_Diag]
      ,CASE WHEN REPLACE(PDIAG.[PrimDiag],'.','') = 'F431' THEN 1 ELSE 0 END AS [PTSD_Prim_Diag]
      ,CASE WHEN LEFT(REPLACE(PDIAG.[PrimDiag],'.',''), 3) IN ('F32', 'F33')  THEN 1 ELSE 0 END AS [Major_Dep_Dis_Prim_Diag]
      ,CASE WHEN LEFT(REPLACE(PDIAG.[PrimDiag],'.',''), 3) IN ('F40', 'F41')  THEN 1 ELSE 0 END AS [Anx_Dis_Prim_Diag]
      ,CASE WHEN LEFT(REPLACE(PDIAG.[PrimDiag],'.',''), 1) = 'F1' THEN 1 ELSE 0 END AS [Subs_Use_Dis_Prim_Diag]

FROM #temp_new_refs AS [REFS]

LEFT JOIN [Reporting_MESH_MHSDS].[MHS604PrimDiag_Published] AS PDIAG
        ON REFS.[Der_Person_ID] = PDIAG.[Der_Person_ID]
        