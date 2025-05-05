# Financial Modeling Prep - PowerShell Module

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/masters274/FinancialModelingPrep/blob/main/LICENSE)

## Overview

**FinancialModelingPrep** is a PowerShell module designed to interact with the [Financial Modeling Prep (FMP) API](https://site.financialmodelingprep.com/developer/docs/stable). It provides functions to access a wide range of financial data, including stock market information, company valuations, financial statements, and more directly from your PowerShell console or scripts.

To use this module, you will need an API key from Financial Modeling Prep.

## Getting Started

### Prerequisites

*   **PowerShell 5.1** or later / PowerShell Core. Recommended to use 7.5 or later, as compound operators (```+=```) are used in the module.
*   An active [Financial Modeling Prep account](https://site.financialmodelingprep.com/register) and API Key.

### Installation

You can install this module, and required module from the PowerShell Gallery:

```powershell
# Navigate to your project directory
Install-Module -Name 'FinancialModelingPrep' -Scope CurrentUser -AcceptLicense

# Import the module
Import-Module -Name 'FinancialModelingPrep'
```

### Setting Up Your API Access For Auotmation


```powershell
# Save your credentials for use across sessions (for automation)
Save-FMPCredentials -ApiKey "YOUR_FMP_API_KEY"
```

> **Note:** The API key is securely stored as an encrypted environment variable, but are only accessible by the user account that created them, and on the computer where they were saved. This variable is not portable, and cannot be used between other computers or user accounts. Saving your API key will allow you to run the functions without needing to pass the API key each time. If you do not want to save your API key, you can pass it as a parameter to each function that requires it.


**Remove Credentials (if needed):**
You can remove stored API keys using:
```powershell
Remove-RHCCredentials
```

## Usage Examples



### Get the Latest Market Data for Bitcoin

```powershell
# Get the hourly intra-day kline chart data for Bitcoin, for the past 5 days
Get-FMPCryptoIntradayKlineData -Interval 1hour -Symbol btcusd -FromDate ((Get-Date).AddDays(-5))
```

### Get the company profile for Apple Inc.

```powershell
# Retrieves company profile data for a specified trading symbol
Get-FMPCompanyProfile -Symbol AAPL
```

> **Note:** The examples above do not constitute financial advice. Use these functions at your own risk and always secure your API keys.

## Additional Information

- **API Documentation:**
  For more details on available API routes and usage parameters, please refer to the [Financial Modeling Prep API docs](https://site.financialmodelingprep.com/developer/docs/stable).

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/masters274/FinancialModelingPrep/blob/main/LICENSE) file for details.
