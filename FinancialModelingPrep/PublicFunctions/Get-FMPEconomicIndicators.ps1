function Get-FMPEconomicIndicators { 
 

    <#
        .SYNOPSIS
            Retrieves real-time and historical economic indicators using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPEconomicIndicators function fetches economic data for key indicators such as GDP, inflation, unemployment rate,
            and others, based on the provided indicator name(s). Users can filter the data by specifying a date range using the FromDate
            and ToDate parameters. This data can be used to measure economic performance and track growth trends.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER Name
            Specifies the economic indicator(s) to retrieve. Valid values include any of the available indicators such as:
            "GDP", "realGDP", "nominalPotentialGDP", "realGDPPerCapita", "federalFunds", "CPI", "inflationRate", "inflation",
            "retailSales", "consumerSentiment", "durableGoods", "unemploymentRate", "totalNonfarmPayroll", "initialClaims",
            "industrialProductionTotalIndex", "newPrivatelyOwnedHousingUnitsStartedTotalUnits", "totalVehicleSales", "retailMoneyFunds",
            "smoothedUSRecessionProbabilities", "3MonthOr90DayRatesAndYieldsCertificatesOfDeposit", "commercialBankInterestRateOnCreditCardPlansAllAccounts",
            "30YearFixedRateMortgageAverage", "15YearFixedRateMortgageAverage". This parameter is mandatory.

        .PARAMETER FromDate
            (Optional) Specifies the start date (inclusive) for retrieving economic indicators.
            The date must be provided as a [datetime] object and is formatted as "yyyy-MM-dd".

        .PARAMETER ToDate
            (Optional) Specifies the end date (inclusive) for retrieving economic indicators.
            The date must be provided as a [datetime] object and is formatted as "yyyy-MM-dd".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPEconomicIndicators -Name "GDP" -FromDate (Get-Date "2024-01-01") -ToDate (Get-Date "2024-03-01")

            This example retrieves GDP data between January 1, 2024 and March 1, 2024 using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep Economic Indicators API endpoint.
            For more details, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [datetime] $FromDate,

        [Parameter(Mandatory = $false)]
        [datetime] $ToDate,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/economic-indicators"
    }

    Process {
        $url = "{0}?name={1}&apikey={2}" -f $baseUrl, $Name, $ApiKey

        if ($FromDate) {
            $url += "&from=" + $FromDate.ToString("yyyy-MM-dd")
        }
        if ($ToDate) {
            $url += "&to=" + $ToDate.ToString("yyyy-MM-dd")
        }

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving economic indicators data: $_"
        }
    }
 
 };

