
SELECT tnrd.*,
    DIAGDESC.Description
    
FROM #temp_new_refs_diags AS tnrd

LEFT JOIN [UKHD_ICD10].[Codes_And_Titles_And_MetaData] AS DIAGDESC
        ON tnrd.[PrimaryDiag] = DIAGDESC.[Alt_Code]
        AND DIAGDESC.[ICD_Version] = 'ICD10 5th Edition'
        
WHERE [EarliestDiag] = 1
