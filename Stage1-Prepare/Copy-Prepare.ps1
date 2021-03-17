$MountFolder = ..\WinPE_amd64_Prepare\mount\
$ValidPath = Test-Path -Path .\WinPE_amd64_ResetChild\mount\

if (-Not $ValidPath) {
    New-Item .\WinPE_amd64_ResetChild\mount\Scripts -ItemType Directory
}

Copy-Item -Path .\Prepare-Environment.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Windows\System32
# Copy-Item -Path .\Prepare-Reset.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Windows\System32

# Powershell scripts
Copy-Item -Path .\Prepare-Environment.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Scripts

# startnet.cmd
Copy-Item -Path .\startnet-prepare.cmd -Destination .\WinPE_amd64_ResetChild\mount\Windows\System32
Copy-Item -Path .\Run-Prepare.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Windows\System32