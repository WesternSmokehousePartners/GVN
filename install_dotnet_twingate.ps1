# Define URLs for the files
$url1 = "https://github.com/sparker81/GVN/raw/master/windowsdesktop-runtime-6.0.29-win-x64.exe"
$url2 = "https://github.com/sparker81/GVN/raw/master/TwingateWindowsInstaller.msi"

# Define local paths to save the files
$localPath1 = "$env:TEMP\windowsdesktop-runtime-6.0.29-win-x64.exe"
$localPath2 = "$env:TEMP\TwingateWindowsInstaller.msi"

# Download the files
Invoke-WebRequest -Uri $url1 -OutFile $localPath1
Invoke-WebRequest -Uri $url2 -OutFile $localPath2

# Install the files
Start-Process -FilePath $localPath1 -Args "/quiet /norestart" -Wait
Start-Process -FilePath $localPath2 -Args "/quiet /norestart" -Wait
