$secFileId = Get-VstsInput -Name SecureFile -Require
$secTicket = Get-VstsSecureFileTicket -Id $secFileId
$secName = Get-VstsSecureFileName -Id $secFileId
$tempDirectory = Get-VstsTaskVariable -Name "Agent.TempDirectory" -Require
$collectionUrl = Get-VstsTaskVariable -Name "System.TeamFoundationCollectionUri" -Require
$project = Get-VstsTaskVariable -Name "System.TeamProject" -Require
$filePath = Join-Path $tempDirectory $secName

$token= Get-VstsTaskVariable -Name "System.AccessToken" -Require
$user = Get-VstsTaskVariable -Name "Release.RequestedForId" -Require

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User, $token)))
$headers = @{
    Authorization=("Basic {0}" -f $base64AuthInfo)
    Accept="application/octet-stream"
} 

Invoke-RestMethod -Uri "$($collectionUrl)$project/_apis/distributedtask/securefiles/$($secFileId)?ticket=$($secTicket)&download=true&api-version=5.0-preview.1" -Headers $headers -OutFile $filePath