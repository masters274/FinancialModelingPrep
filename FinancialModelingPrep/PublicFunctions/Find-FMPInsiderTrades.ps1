function Find-FMPInsiderTrades { 
 

    <#
        .SYNOPSIS
            Searches for insider trading activities across companies using the Financial Modeling Prep API.

        .DESCRIPTION
            The Find-FMPInsiderTrades function allows you to search for insider trading activities
            using various filter criteria or retrieve the latest insider trades.

            In Search mode, you can filter by company symbol, reporting person's name,
            transaction type, or filing date range.

            In Latest mode, you can simply retrieve the most recent insider trades with options
            to control pagination.

            This function helps track insider buying and selling patterns to gauge management sentiment.
            Results are paginated for easier handling of large datasets.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol to filter insider trading data (e.g., "AAPL").
            This parameter is optional and only valid in Search mode.

        .PARAMETER ReportingPersonName
            Specifies the name of the reporting person (insider) to filter results.
            This parameter is optional and only valid in Search mode.

        .PARAMETER TransactionType
            Specifies the type of insider transaction. Common values include "P" (Purchase), "S" (Sale).
            This parameter is optional and only valid in Search mode.

        .PARAMETER FromDate
            Specifies the start date for filtering insider trading activities.
            The date should be provided as a [datetime] object. This parameter is optional and only valid in Search mode.

        .PARAMETER ToDate
            Specifies the end date for filtering insider trading activities.
            The date should be provided as a [datetime] object. This parameter is optional and only valid in Search mode.

        .PARAMETER ReportingCik
            Specifies the Central Index Key (CIK) of the reporting person.
            This parameter is optional and only valid in Search mode.

        .PARAMETER CompanyCik
            Specifies the Central Index Key (CIK) of the company.
            This parameter is optional and only valid in Search mode.

        .PARAMETER Latest
            Switch parameter to retrieve the latest insider trades without specific filtering criteria.
            Cannot be used together with Search mode parameters.

        .PARAMETER Page
            Specifies the page number for paginated results. The default value is 0.
            This parameter is optional and valid in both Search and Latest modes.

        .PARAMETER Limit
            Specifies the maximum number of results to return per page. The default value is 100.
            This parameter is optional and valid in both Search and Latest modes.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential and will prompt the user if necessary.

        .EXAMPLE
            Find-FMPInsiderTrades -Symbol AAPL -Limit 50

            This example retrieves up to 50 insider trading activities for Apple Inc.

        .EXAMPLE
            Find-FMPInsiderTrades -TransactionType "P" -FromDate (Get-Date).AddMonths(-3) -ToDate (Get-Date)

            This example retrieves all insider purchase transactions from the past 3 months.

        .EXAMPLE
            Find-FMPInsiderTrades -Latest -Page 0 -Limit 50

            This example retrieves the first 50 latest insider trades across all companies.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep API's Search Insider Trades endpoint and Latest Insider Trade endpoint.
            For more information, visit:
            https://site.financialmodelingprep.com/developer/docs/stable/search-insider-trades
            https://site.financialmodelingprep.com/developer/docs/stable/latest-insider-trade
    #>

    [CmdletBinding(DefaultParameterSetName = 'Search')]

    [CmdletBinding(DefaultParameterSetName = 'Search')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Latest')]
        [switch] $Latest,

        [Parameter(Mandatory = $false, ParameterSetName = 'Search')]
        [string] $Symbol,

        [Parameter(Mandatory = $false, ParameterSetName = 'Search')]
        [string] $ReportingPersonName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Search')]
        [string] $TransactionType,

        [Parameter(Mandatory = $false, ParameterSetName = 'Search')]
        [string] $ReportingCik,

        [Parameter(Mandatory = $false, ParameterSetName = 'Search')]
        [string] $CompanyCik,

        [Parameter(Mandatory = $false, ParameterSetName = 'Search')]
        [datetime] $FromDate,

        [Parameter(Mandatory = $false, ParameterSetName = 'Search')]
        [datetime] $ToDate,

        [Parameter(Mandatory = $false)]
        [int] $Page = 0,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 100,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }

        # Set the base URL based on the parameter set
        if ($PSCmdlet.ParameterSetName -eq 'Latest') {
            $baseUrl = "https://financialmodelingprep.com/api/v4/insider-trading"
        }
        else {
            $baseUrl = "https://financialmodelingprep.com/api/v4/insider-trading"
        }
    }

    Process {
        $queryParams = @{
            apikey = $ApiKey
            page   = $Page
            limit  = $Limit
        }

        # Add search-specific parameters if in Search mode
        if ($PSCmdlet.ParameterSetName -eq 'Search') {
            if ($Symbol) { $queryParams.symbol = $Symbol }
            if ($ReportingPersonName) { $queryParams.reportingPersonName = $ReportingPersonName }
            if ($TransactionType) { $queryParams.transactionType = $TransactionType }
            if ($ReportingCik) { $queryParams.reportingCik = $ReportingCik }
            if ($CompanyCik) { $queryParams.companyCik = $CompanyCik }
            if ($FromDate) { $queryParams.from = $FromDate.ToString("yyyy-MM-dd") }
            if ($ToDate) { $queryParams.to = $ToDate.ToString("yyyy-MM-dd") }
        }

        $queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
        $url = "{0}?{1}" -f $baseUrl, $queryString

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error searching insider trades: $_"
        }
    }
 
 };

