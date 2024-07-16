# Declare a function to check if a file or folder exists
function FileOrFolderExists {
    param (
        [string]$path
    )
    return Test-Path $path
}

# Declare the urls to download the icons
$urls = @(
    "https://github.com/sparker81/GVN/raw/master/icons/deacom_icon_blue.ico",
    "https://github.com/sparker81/GVN/raw/master/icons/deacom_icon_green.ico",
    "https://github.com/sparker81/GVN/raw/master/icons/deacom_icon_red.ico",
    "https://github.com/sparker81/GVN/raw/master/icons/deacom_icon_yellow.ico"
)

# Task 1: Declare the local path to download the icons to
$path = "C:\Users\Public\icons"

# Check if the folder already exists
if (-not (FileOrFolderExists $path)) {
    try {
        New-Item -ItemType Directory -Path $path -ErrorAction Stop | Out-Null
        Write-Host "Folder '$path' created successfully."
    } catch {
        Write-Host "Error creating folder '$path'. Error: $_"
        exit 1
    }
} else {
    Write-Host "Folder '$path' already exists."
}

# Download the icons
foreach ($url in $urls) {
    $fileName = [System.IO.Path]::GetFileName($url)
    $filePath = Join-Path -Path $path -ChildPath $fileName
    try {
        Invoke-WebRequest -Uri $url -OutFile $filePath -ErrorAction Stop
        Write-Host "Downloaded '$fileName' successfully."
    } catch {
        Write-Host "Error downloading '$fileName'. Error: $_"
        exit 1
    }
}

# Create WScriptShell object
$WScriptShell = New-Object -ComObject WScript.Shell

# Task 2: Create internet shortcut for "Deacom v16 - Production"
$productionShortcut = Join-Path -Path "$env:PUBLIC\Desktop" -ChildPath "Deacom v16 - Production.lnk"
$productionIcon = Join-Path -Path $path -ChildPath "deacom_icon_blue.ico"
$productionURL = "http://deacom.goldenvalleynatural.com:8080"

if (FileOrFolderExists $productionIcon) {
    $shortcut = $WScriptShell.CreateShortcut($productionShortcut)
    $shortcut.TargetPath = $productionURL
    $shortcut.IconLocation = $productionIcon
    $shortcut.Save()
} else {
    Write-Host "Production icon does not exist. Skipping Task 2."
}

# Task 3: Create internet shortcut for "Deacom v16 - Training"
$trainingShortcut = Join-Path -Path "$env:PUBLIC\Desktop" -ChildPath "Deacom v16 - Training.lnk"
$trainingIcon = Join-Path -Path $path -ChildPath "deacom_icon_red.ico"
$trainingURL = "http://deacom.goldenvalleynatural.com:8083"

if (FileOrFolderExists $trainingIcon) {
    $shortcut = $WScriptShell.CreateShortcut($trainingShortcut)
    $shortcut.TargetPath = $trainingURL
    $shortcut.IconLocation = $trainingIcon
    $shortcut.Save()
} else {
    Write-Host "Training icon does not exist. Skipping Task 3."
}

# Task 4: Create shortcut for "Enable Local Printing"
$localPrintingShortcut = Join-Path -Path "$env:PUBLIC\Desktop" -ChildPath "Enable Local Printing.lnk"
$localPrintingIcon = Join-Path -Path $path -ChildPath "deacom_icon_green.ico"
$localPrintingPath = "C:\Program Files\Deacom\Local\16.06\Deacom.Local.exe"

if (FileOrFolderExists $localPrintingIcon) {
    $shortcut = $WScriptShell.CreateShortcut($localPrintingShortcut)
    $shortcut.TargetPath = $localPrintingPath
    $shortcut.IconLocation = $localPrintingIcon
    $shortcut.Save()
} else {
    Write-Host "Local Printing icon does not exist. Skipping Task 4."
}
