Function Get-UTF8RestMethod {
    [OutputType([string])]
    [CmdletBinding()]
    Param(
        [string]$uri
    )
    Try
    {
        Add-Type -AssemblyName System.IO
        Add-Type -AssemblyName System.Net
        Add-Type -AssemblyName System.Net.Http
    }
    Catch
    {
        [array]$error_clone = $Error.Clone()
        [string]$error_message = $error_clone | Where-Object { $null -ne $_.Exception } | Select-Object -First 1 | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
        Write-Warning "Error: Unable to load assemblies due to [$error_message]"
        Return
    }
    Try
    {
        [System.Net.WebRequest]$web_request = [System.Net.WebRequest]::Create($uri)
    }
    Catch
    {
        [array]$error_clone = $Error.Clone()
        [string]$error_message = $error_clone | Where-Object { $null -ne $_.Exception } | Select-Object -First 1 | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
        Write-Warning "Error: Unable to create web request due to [$error_message]"
        Return
    }
    Try
    {
        [System.Net.WebResponse]$response = $web_request.GetResponse()
    }
    Catch
    {
        [array]$error_clone = $Error.Clone()
        [string]$error_message = $error_clone | Where-Object { $null -ne $_.Exception } | Select-Object -First 1 | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
        Write-Warning "Error: Web response failed due to [$error_message]"
        Return
    }
    Try
    {
        [System.IO.StreamReader]$reader = New-Object -TypeName System.IO.StreamReader($response.GetResponseStream())
    }
    Catch
    {
        [array]$error_clone = $Error.Clone()
        [string]$error_message = $error_clone | Where-Object { $null -ne $_.Exception } | Select-Object -First 1 | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
        Write-Warning "Error: StreamReader failed to get the response stream due to [$error_message]"
        Return
    }
    Try
    {
        [string]$response_string = $reader.ReadToEnd()
    }
    Catch
    {
        [array]$error_clone = $Error.Clone()
        [string]$error_message = $error_clone | Where-Object { $null -ne $_.Exception } | Select-Object -First 1 | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
        Write-Warning "Error: StreamReader failed to read the response stream due to [$error_message]"
        Return
    }
    Return $response_string
}
