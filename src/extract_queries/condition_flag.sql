
SELECT REFS.*
      ,IDENT.AutismStatus
      ,IDENT.LDStatus

FROM #temp_new_refs AS [REFS]

LEFT JOIN [Reporting_MESH_MHSDS].[MHS005PatInd_Published] AS IDENT
        ON REFS.[Der_Person_ID] = IDENT.[Der_Person_ID]
        AND REFS.[RecordNumber] = IDENT.[RecordNumber]
