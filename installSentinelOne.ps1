# Declare the urls to download the SentinelOne installer and hash
$url1 = "https://github.com/sparker81/GVN/raw/master/SentinelInstaller_windows_64bit_v23_4_4_223.msi"
$url2 = "https://github.com/sparker81/GVN/raw/master/sentinel_sha256.txt"

# Declare the local path to download the installer to
$localPath1 = "C:\Temp\SentinelInstaller_windows_64bit_v23_4_4_223.msi"
$localPath2 = "C:\Temp\sentinel_sha256.txt"

# Declare the SITE_TOKEN variable
$s1_idaho_sitetoken = "eyJ1cmwiOiAiaHR0cHM6Ly91c2VhMS0wMTguc2VudGluZWxvbmUubmV0IiwgInNpdGVfa2V5IjogImdfNzhhODdhMDM0ODYyMmQ5OSJ9"

# Ensure the C:\Temp directory exists
if (-not (Test-Path "C:\Temp")) {
  New-Item -ItemType Directory -Path "C:\Temp"
}

# Download the installer and the hash file
Invoke-WebRequest -Uri $url1 -OutFile $localPath1
Invoke-WebRequest -Uri $url2 -OutFile $localPath2

# Read the expected SHA256 hash from the text file
$expectedHash = Get-Content -Path $localPath2 -Raw

# Calculate the SHA256 hash of the file
$fileHash = Get-FileHash -Path $localPath1 -Algorithm SHA256

function installSentinelOne {
  # Run the msiexec command with the SITE_TOKEN
  Start-Process msiexec.exe -ArgumentList "/i `"C:\Temp\SentinelInstaller_windows_64bit_v23_4_4_223.msi`" /q WSC=false SITE_TOKEN=$s1_idaho_sitetoken" -Wait

  # Delete the C:\Temp folder and all contents
  Remove-Item -Recurse -Force "C:\Temp"
}

# Compare the hashes
if ($expectedHash.Trim() -eq $fileHash.Hash) {
  installSentinelOne
  exit 0
} else {
  exit 5
}