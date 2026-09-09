SELECT [OrgIDProv]
      ,[ReportingPeriodEndDate]
      ,SUM(New_referral) AS [New_Referrals]
FROM #temp_referrals
WHERE [New_Order] = 1
GROUP BY [OrgIDProv], [ReportingPeriodEndDate]
ORDER BY [OrgIDProv], [ReportingPeriodEndDate]