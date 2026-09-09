SELECT [OrgIDProv]
      ,[ReportingPeriodEndDate]
      ,SUM(Closed_referral) AS [Closed_Referrals]
FROM #temp_referrals
WHERE [Closed_Order] = 1
GROUP BY [OrgIDProv], [ReportingPeriodEndDate]
ORDER BY [OrgIDProv], [ReportingPeriodEndDate]