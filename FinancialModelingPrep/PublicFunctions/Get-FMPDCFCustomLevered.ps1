function Get-FMPDCFCustomLevered { 
 

    <#
        .SYNOPSIS
            Runs a tailored levered Discounted Cash Flow (DCF) analysis using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPDCFCustomLevered function allows you to perform a personalized levered DCF valuation by fine-tuning key assumptions
            and variables. You can specify detailed inputs such as revenue growth, EBITDA margin, depreciation percentage,
            and several other financial ratios. Only the stock symbol is required; all other parameters are optional.
            This function builds the query string by including only the parameters that are provided. If no API key is provided,
            it attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to run the custom levered DCF analysis (e.g., AAPL). This parameter is mandatory.

        .PARAMETER revenueGrowthPct
            The expected revenue growth percentage (expressed as a decimal, e.g., 0.1094119804597946 for ~10.94%).

        .PARAMETER ebitdaPct
            The EBITDA margin as a decimal (e.g., 0.31273548388 for ~31.27%).

        .PARAMETER depreciationAndAmortizationPct
            The percentage of depreciation and amortization relative to revenue (e.g., 0.0345531631720999).

        .PARAMETER cashAndShortTermInvestmentsPct
            The percentage of cash and short-term investments relative to revenue (e.g., 0.2344222126801843).

        .PARAMETER receivablesPct
            The percentage of receivables relative to revenue (e.g., 0.1533770531229388).

        .PARAMETER inventoriesPct
            The percentage of inventories relative to revenue (e.g., 0.0155245674227653).

        .PARAMETER payablePct
            The percentage of payables relative to revenue (e.g., 0.1614868903169657).

        .PARAMETER ebitPct
            The EBIT margin as a decimal (e.g., 0.2781823207138459).

        .PARAMETER capitalExpenditurePct
            The percentage of capital expenditures relative to revenue (e.g., 0.0306025847141713).

        .PARAMETER operatingCashFlowPct
            The percentage of operating cash flow relative to revenue (e.g., 0.2886333485760204).

        .PARAMETER sellingGeneralAndAdministrativeExpensesPct
            The percentage of SG&A expenses relative to revenue (e.g., 0.0662854095187211).

        .PARAMETER taxRate
            The effective tax rate as a decimal (e.g., 0.14919579658453103).

        .PARAMETER longTermGrowthRate
            The long-term growth rate (in percent, e.g., 4).

        .PARAMETER costOfDebt
            The cost of debt as a percentage (e.g., 3.64).

        .PARAMETER costOfEquity
            The cost of equity as a percentage (e.g., 9.51168).

        .PARAMETER marketRiskPremium
            The market risk premium as a percentage (e.g., 4.72).

        .PARAMETER beta
            The stock's beta (e.g., 1.244).

        .PARAMETER riskFreeRate
            The risk-free rate as a percentage (e.g., 3.64).

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPDCFCustomLevered -Symbol "AAPL" `
                -revenueGrowthPct 0.1094119804597946 `
                -ebitdaPct 0.31273548388 `
                -depreciationAndAmortizationPct 0.0345531631720999 `
                -capitalExpenditurePct 0.0306025847141713 `
                -taxRate 0.14919579658453103 `
                -longTermGrowthRate 4 `
                -costOfDebt 3.64 `
                -beta 1.244 `
                -riskFreeRate 3.64

            This example runs a custom levered DCF analysis for Apple Inc. using the specified financial assumptions.

        .NOTES
            This function uses the Financial Modeling Prep Custom Levered DCF API endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [double] $revenueGrowthPct,

        [Parameter(Mandatory = $false)]
        [double] $ebitdaPct,

        [Parameter(Mandatory = $false)]
        [double] $depreciationAndAmortizationPct,

        [Parameter(Mandatory = $false)]
        [double] $cashAndShortTermInvestmentsPct,

        [Parameter(Mandatory = $false)]
        [double] $receivablesPct,

        [Parameter(Mandatory = $false)]
        [double] $inventoriesPct,

        [Parameter(Mandatory = $false)]
        [double] $payablePct,

        [Parameter(Mandatory = $false)]
        [double] $ebitPct,

        [Parameter(Mandatory = $false)]
        [double] $capitalExpenditurePct,

        [Parameter(Mandatory = $false)]
        [double] $operatingCashFlowPct,

        [Parameter(Mandatory = $false)]
        [double] $sellingGeneralAndAdministrativeExpensesPct,

        [Parameter(Mandatory = $false)]
        [double] $taxRate,

        [Parameter(Mandatory = $false)]
        [double] $longTermGrowthRate,

        [Parameter(Mandatory = $false)]
        [double] $costOfDebt,

        [Parameter(Mandatory = $false)]
        [double] $costOfEquity,

        [Parameter(Mandatory = $false)]
        [double] $marketRiskPremium,

        [Parameter(Mandatory = $false)]
        [double] $beta,

        [Parameter(Mandatory = $false)]
        [double] $riskFreeRate,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/custom-levered-discounted-cash-flow"
    }

    Process {
        $queryParams = @{}

        $queryParams["symbol"] = $Symbol

        if ($revenueGrowthPct -ne $null) { $queryParams["revenueGrowthPct"] = $revenueGrowthPct }
        if ($ebitdaPct -ne $null) { $queryParams["ebitdaPct"] = $ebitdaPct }
        if ($depreciationAndAmortizationPct -ne $null) { $queryParams["depreciationAndAmortizationPct"] = $depreciationAndAmortizationPct }
        if ($cashAndShortTermInvestmentsPct -ne $null) { $queryParams["cashAndShortTermInvestmentsPct"] = $cashAndShortTermInvestmentsPct }
        if ($receivablesPct -ne $null) { $queryParams["receivablesPct"] = $receivablesPct }
        if ($inventoriesPct -ne $null) { $queryParams["inventoriesPct"] = $inventoriesPct }
        if ($payablePct -ne $null) { $queryParams["payablePct"] = $payablePct }
        if ($ebitPct -ne $null) { $queryParams["ebitPct"] = $ebitPct }
        if ($capitalExpenditurePct -ne $null) { $queryParams["capitalExpenditurePct"] = $capitalExpenditurePct }
        if ($operatingCashFlowPct -ne $null) { $queryParams["operatingCashFlowPct"] = $operatingCashFlowPct }
        if ($sellingGeneralAndAdministrativeExpensesPct -ne $null) { $queryParams["sellingGeneralAndAdministrativeExpensesPct"] = $sellingGeneralAndAdministrativeExpensesPct }
        if ($taxRate -ne $null) { $queryParams["taxRate"] = $taxRate }
        if ($longTermGrowthRate -ne $null) { $queryParams["longTermGrowthRate"] = $longTermGrowthRate }
        if ($costOfDebt -ne $null) { $queryParams["costOfDebt"] = $costOfDebt }
        if ($costOfEquity -ne $null) { $queryParams["costOfEquity"] = $costOfEquity }
        if ($marketRiskPremium -ne $null) { $queryParams["marketRiskPremium"] = $marketRiskPremium }
        if ($beta -ne $null) { $queryParams["beta"] = $beta }
        if ($riskFreeRate -ne $null) { $queryParams["riskFreeRate"] = $riskFreeRate }

        $queryParams["apikey"] = $ApiKey

        $queryString = ($queryParams.GetEnumerator() | Where-Object { $_.Value -ne $null -and $_.Value -ne "" } | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"

        $url = "{0}?{1}" -f $baseUrl, $queryString

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving custom levered DCF valuation data: $_"
        }
    }
 
 };

