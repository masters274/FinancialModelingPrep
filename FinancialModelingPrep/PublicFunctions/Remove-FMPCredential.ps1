function Remove-FMPCredential { 
 
    [CmdletBinding()]
    Param ()

    $apiKeyVarName = 'FMPApiKey'

    if (Test-Path -Path ("env:{0}" -f $apiKeyVarName)) {
        Remove-Item -Path ("env:{0}" -f $apiKeyVarName)
    }

    if (Test-Path "HKCU:\Environment\$apiKeyVarName") {
        Remove-ItemProperty -Path "HKCU:\Environment" -Name $apiKeyVarName
    }
 
 };

