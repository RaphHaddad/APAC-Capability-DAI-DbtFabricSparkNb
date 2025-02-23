# Load json from config.json
#$config = Get-Content -Raw -Path "./config.json" | ConvertFrom-Json
 
#populate variables from config.json
$workspaceName = '{{workspace_id}}'
$itemPath = '{{lakehouse_id}}/Files'#'$($config.OnelakeGuid)/Files'
#$day = $env:Today
 
$env:AZCOPY_CRED_TYPE = "OAuthToken";
$env:AZCOPY_CONCURRENCY_VALUE = "AUTO";
$azloginstatus = azcopy login status
if($azloginstatus -eq 'INFO: You have successfully refreshed your token. Your login session is still active')
{
    Write-Host "Already logged in"
}
else
{
    Write-Host "Logging in"
    & azcopy login #--tenant-id 72f988bf-86f1-41af-91ab-2d7cd011db47
}
& azcopy copy "./{{project_root}}/target/notebooks/" "https://onelake.blob.fabric.microsoft.com/$workspacename/$itemPath/" --overwrite=true --from-to=LocalBlob --blob-type BlockBlob --follow-symlinks --check-length=true --put-md5 --follow-symlinks --disable-auto-decoding=false --recursive --trusted-microsoft-suffixes=onelake.blob.fabric.microsoft.com --log-level=INFO;
