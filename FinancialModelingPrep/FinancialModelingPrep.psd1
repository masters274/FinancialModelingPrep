@{
	ModuleVersion      = '1.0.0.0'
	GUID               = '75b6ae1d-a766-49d7-a644-3af5a46db7da'
	Author             = 'Chris Masters'
	CompanyName        = 'Chris Masters'
	Copyright          = '(c) 2025 Chris Masters. All rights reserved.'
	Description        = 'Module for interacting with the Financial Modeling Prep API.'
	RootModule         = 'FinancialModelingPrep.psm1'
	PowerShellVersion  = '5.1'
	RequiredModules    = @(
		@{ModuleName = 'core'; Guid = '7ffd438f-134c-49be-8000-9a9f3af1cbe3'; ModuleVersion = '1.9.4.2' }
	)

	FunctionsToExport  = @(
		"Find-FMPInsiderTrades",
		"Find-FMPMerger",
		"Get-FMPAcquisitionOwnership",
		"Get-FMPActivelyTradingList",
		"Get-FMPAfterMarketQuote",
		"Get-FMPAfterMarketTrade",
		"Get-FMPAllCommoditiesQuotes",
		"Get-FMPAllForexQuotes",
		"Get-FMPAllIndexQuotes",
		"Get-FMPAllInsiderTransactionTypes",
		"Get-FMPAllShareFloat",
		"Get-FMPArticles",
		"Get-FMPAsReportedStatement",
		"Get-FMPAverageDirectionalIndex",
		"Get-FMPBalanceSheet",
		"Get-FMPBalanceSheetGrowth",
		"Get-FMPBalanceSheetTTM",
		"Get-FMPBatchAfterMarketQuote",
		"Get-FMPBatchAfterMarketTrade",
		"Get-FMPBatchQuote",
		"Get-FMPBatchQuoteShort",
		"Get-FMPBiggestMovers",
		"Get-FMPCashFlowStatement",
		"Get-FMPCashFlowStatementGrowth",
		"Get-FMPCashFlowStatementTTM",
		"Get-FMPCikCompanyProfile",
		"Get-FMPCIKList",
		"Get-FMPCommoditiesList",
		"Get-FMPCommodityHistoricalPrice",
		"Get-FMPCommodityIntradayPrice",
		"Get-FMPCommodityQuote",
		"Get-FMPCompanyEmployeeCount",
		"Get-FMPCompanyEmployeeCountHistorical",
		"Get-FMPCompanyExecutive",
		"Get-FMPCompanyMarketCap",
		"Get-FMPCompanyMarketCapBatch",
		"Get-FMPCompanyMarketCapHistorical",
		"Get-FMPCompanyNote",
		"Get-FMPCompanyProfile",
		"Get-FMPCompanyShareFloat",
		"Get-FMPCompanySymbolList",
		"Get-FMPCOTAnalysis",
		"Get-FMPCOTReport",
		"Get-FMPCOTReportList",
		"Get-FMPCountryList",
		"Get-FMPCredential",
		"Get-FMPCrowdfundingByCIK",
		"Get-FMPCryptoDailyKlineData",
		"Get-FMPCryptoIntradayKlineData",
		"Get-FMPCryptoList",
		"Get-FMPCryptoNews",
		"Get-FMPCryptoQuote",
		"Get-FMPDCFCustomAdvanced",
		"Get-FMPDCFCustomLevered",
		"Get-FMPDCFLevered",
		"Get-FMPDCFValuation",
		"Get-FMPDelistedCompany",
		"Get-FMPDividendAdjustedPrice",
		"Get-FMPDividendCalendar",
		"Get-FMPDividends",
		"Get-FMPDoubleExponentialMovingAverage",
		"Get-FMPEarningsCalendar",
		"Get-FMPEarningsReport",
		"Get-FMPEarningsTranscript",
		"Get-FMPEarningsTranscriptList",
		"Get-FMPEconomicIndicators",
		"Get-FMPEconomicReleaseCalendar",
		"Get-FMPEquityOfferingByCIK",
		"Get-FMPESGBenchmarkComparison",
		"Get-FMPESGInvestmentSearch",
		"Get-FMPESGRatings",
		"Get-FMPETFAssetExposure",
		"Get-FMPETFCountryWeighting",
		"Get-FMPETFHoldings",
		"Get-FMPETFInformation",
		"Get-FMPETFList",
		"Get-FMPETFSectorWeighting",
		"Get-FMPExchangeAllMarketHours",
		"Get-FMPExchangeGlobalMarketHours",
		"Get-FMPExchangeList",
		"Get-FMPExecutiveCompensation",
		"Get-FMPExecutiveCompensationBenchmark",
		"Get-FMPExponentialMovingAverage",
		"Get-FMPFilingsExtract",
		"Get-FMPFilingsExtractAnalyticsByHolder",
		"Get-FMPFinancialEstimates",
		"Get-FMPFinancialReportsDates",
		"Get-FMPFinancialScores",
		"Get-FMPFinancialStatementGrowth",
		"Get-FMPFinancialStatementSymbolList",
		"Get-FMPForexHistoricalPrice",
		"Get-FMPForexIntradayPrice",
		"Get-FMPForexList",
		"Get-FMPForexNews",
		"Get-FMPForexQuote",
		"Get-FMPForm10KJSON",
		"Get-FMPForm10KXLSX",
		"Get-FMPForm13FFilingsDates",
		"Get-FMPFullCommoditiesQuotes",
		"Get-FMPFullCryptocurrencyQuotes",
		"Get-FMPFullETFQuotes",
		"Get-FMPFullExchangeQuotes",
		"Get-FMPFullForexQuotes",
		"Get-FMPFullIndexQuotes",
		"Get-FMPFullMutualFundQuotes",
		"Get-FMPFundDisclosureDates",
		"Get-FMPGeneralNews",
		"Get-FMPHistoricalIndexData",
		"Get-FMPHistoricalIndustryPE",
		"Get-FMPHistoricalIndustryPerformance",
		"Get-FMPHistoricalSectorPE",
		"Get-FMPHistoricalSectorPerformance",
		"Get-FMPHolderPerformanceSummary",
		"Get-FMPHoldersIndustryBreakdown",
		"Get-FMPHouseTradingActivity",
		"Get-FMPIncomeStatement",
		"Get-FMPIncomeStatementGrowth",
		"Get-FMPIncomeStatementTTM",
		"Get-FMPIndexConstituents",
		"Get-FMPIndexesList",
		"Get-FMPIndexHistoricalEOD",
		"Get-FMPIndexIntradayData",
		"Get-FMPIndexQuote",
		"Get-FMPIndustryList",
		"Get-FMPIndustryPerformanceSnapshot",
		"Get-FMPIndustryPESnapshot",
		"Get-FMPIndustrySummary",
		"Get-FMPInsiderTradeStatistics",
		"Get-FMPIntradayStockChart",
		"Get-FMPIPOCalendar",
		"Get-FMPIPODisclosure",
		"Get-FMPKeyMetrics",
		"Get-FMPKeyMetricsTTM",
		"Get-FMPLatest8KFilings",
		"Get-FMPLatestCrowdfunding",
		"Get-FMPLatestEquityOffering",
		"Get-FMPLatestFilings",
		"Get-FMPLatestFinancialStatements",
		"Get-FMPLatestFundDisclosures",
		"Get-FMPLatestHouseFinancialDisclosures",
		"Get-FMPLatestMerger",
		"Get-FMPLatestSenateFinancialDisclosures",
		"Get-FMPMarketRiskPremium",
		"Get-FMPMetricsRatios",
		"Get-FMPMetricsRatiosTTM",
		"Get-FMPMutualFundDisclosures",
		"Get-FMPOwnerEarnings",
		"Get-FMPPositionsSummary",
		"Get-FMPPressReleases",
		"Get-FMPPriceTargetConsensus",
		"Get-FMPPriceTargetLatestNews",
		"Get-FMPPriceTargetNews",
		"Get-FMPPriceTargetSummary",
		"Get-FMPQuote",
		"Get-FMPQuoteChange",
		"Get-FMPQuoteShort",
		"Get-FMPRatingHistorical",
		"Get-FMPRatingSnapshot",
		"Get-FMPRelativeStrengthIndex",
		"Get-FMPRevenueGeographicSegments",
		"Get-FMPRevenueProductSegmentation",
		"Get-FMPSectorList",
		"Get-FMPSectorPerformanceSnapshot",
		"Get-FMPSectorPESnapshot",
		"Get-FMPSenateTradingActivity",
		"Get-FMPSimpleMovingAverage",
		"Get-FMPStandardDeviation",
		"Get-FMPStockChartLight",
		"Get-FMPStockGradeLatestNews",
		"Get-FMPStockGrades",
		"Get-FMPStockGradesHistorical",
		"Get-FMPStockGradesNews",
		"Get-FMPStockNews",
		"Get-FMPStockPeerComparison",
		"Get-FMPStockPriceAndVolume",
		"Get-FMPStockSplitCalendar",
		"Get-FMPStockSplitDetails",
		"Get-FMPSymbolChanges",
		"Get-FMPTopTradedStocks",
		"Get-FMPTreasuryRates",
		"Get-FMPTripleExponentialMovingAverage",
		"Get-FMPUnadjustedStockPrice",
		"Get-FMPWeightedMovingAverage",
		"Get-FMPWilliamsR",
		"Remove-FMPCredential",
		"Save-FMPCredential",
		"Search-FMPByCUSIP",
		"Search-FMPByISIN",
		"Search-FMPCentralIndexKey",
		"Search-FMPCompanyName",
		"Search-FMPCrowdfunding",
		"Search-FMPCryptoNews",
		"Search-FMPEquityOffering",
		"Search-FMPExchangeVariants",
		"Search-FMPForexNews",
		"Search-FMPFundDisclosures",
		"Search-FMPHouseTradingByName",
		"Search-FMPPressReleases",
		"Search-FMPSenateTradingByName",
		"Search-FMPStockNews",
		"Search-FMPStockScreener",
		"Search-FMPStockSymbol"
	)

	CmdletsToExport    = @()
	VariablesToExport  = @()
	AliasesToExport    = @()
	RequiredAssemblies = @()
	NestedModules      = @()
	PrivateData        = @{

		PSData = @{

			Tags                     = @('FMP', 'FinancialModeling', 'FinancialModelingprep', 'Crypto', 'Cryptocurrency', 'Trading', 'API', 'Finance', 'Investing', 'Investment', 'Stock', 'Stocks', 'Market', 'StockMarket', 'FinancialStatements', 'FinancialStatement', 'Financials', 'Financial', 'Charts', 'Kline', 'Candlestick', 'TechnicalAnalysis', 'Indicators', 'Indicator', 'StockScreener', 'Screener', 'StockScreenerAPI', 'StockMarketAPI', 'FinancialStatementsAPI', 'FinancialModelingPrepAPI')
			LicenseUri               = 'https://github.com/masters274/FinancialModelingPrep/blob/main/LICENSE'
			ProjectUri               = 'https://github.com/masters274/FinancialModelingPrep'
			RepositorySourceLocation = 'https://github.com/masters274/FinancialModelingPrep/tree/main/FinancialModelingPrep'
			IconUri                  = 'https://github.com/masters274/FinancialModelingPrep/blob/main/images/fmp_icon.png'
			HelpUri                  = 'https://github.com/masters274/FinancialModelingPrep/blob/main/README.md'
			RequireLicenseAcceptance = $true
			ReleaseNotes             = '
Version 0.1
- Day 1 release of Financial Modeling Prep Stock Market and Financial Statements API module.

Version 1.0.0.0
- Manifest updated additional URLs
- Repo updated: README, icon, tags
'
		}
	}
}
