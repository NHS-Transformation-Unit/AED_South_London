SELECT Distinct(REF.[RecordNumber])
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
      ,REF.[PrimReasonReferralMH]
      ,REF.[RecordEndDate]
      ,REF.[RecordStartDate]
      ,REF.[ReferralRequestReceivedDate]
      ,REF.[ServDischDate]
      ,REF.[ServiceRequestId]
      ,REF.[SourceOfReferralMH]
      ,REF.[SpecialisedMHServiceCode]
      ,REF.[UniqMonthID]
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
      ,MPI.[LADistrictAuth]
      ,SERVTD.[ServTeamTypeMH]
  FROM [Reporting_MESH_MHSDS].[MHS101Referral_Published] AS REF
        
    LEFT JOIN [Reporting_MESH_MHSDS].[MHS001MPI_Published] AS MPI
		ON REF.[RecordNumber] = MPI.[RecordNumber]

    LEFT JOIN [Reporting_MESH_MHSDS].[MHS902ServiceTeamDetails_Published] as SERVTD
        ON REF.[UniqCareProfTeamLocalID] = SERVTD.[UniqCareProfTeamLocalID]

  WHERE REF.[UniqMonthID] = (SELECT max([UniqMonthID])
                                FROM [Reporting_MESH_MHSDS].[MHS101Referral_Published])
        AND REF.[OrgIDProv] = 'RV5'
        AND REF.[PrimReasonReferralMH] = 12
        AND SERVTD.[ServTeamTypeMH] = 'C10'
        AND REF.[ReferralRequestReceivedDate] BETWEEN '01 February 2026' AND '28 February 2026'
        AND REF.[AgeServReferRecDate] >= 12
        AND MPI.[LADistrictAuth] LIKE ('E%')
