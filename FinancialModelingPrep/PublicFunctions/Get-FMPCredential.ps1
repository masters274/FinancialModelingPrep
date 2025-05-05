function Get-FMPCredential { 
 
    [CmdletBinding()]
    Param ()

    try {

        $aKeyPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode(($env:FMPApiKey | ConvertTo-SecureString -ErrorAction SilentlyContinue))

        $aKey = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($aKeyPtr)
    }
    catch {

        return $null
    }
    finally {
        # Always free the unmanaged memory to reduce exposure of sensitive data.
        if ($apiKeyPtr <# -ne [IntPtr]::Zero #>) {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($apiKeyPtr)
        }
    }

    return $aKey
 
 };

