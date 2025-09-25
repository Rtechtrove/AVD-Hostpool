# Download AVD Agent and Bootloader
$agentUrl = "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv"
$bootloaderUrl = "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrxrH"

Invoke-WebRequest -Uri $agentUrl -OutFile "AVDAgent.msi"
Invoke-WebRequest -Uri $bootloaderUrl -OutFile "AVDBootloader.msi"

Start-Process msiexec.exe -ArgumentList "/i AVDAgent.msi /quiet /norestart" -Wait
Start-Process msiexec.exe -ArgumentList "/i AVDBootloader.msi /quiet /norestart" -Wait

# Read token from file
$token = Get-Content "$PSScriptRoot\registrationToken.txt" | Out-String
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\RDInfraAgent" -Name "RegistrationToken" -Value $token.Trim()

Restart-Service RDAgentBootLoader
