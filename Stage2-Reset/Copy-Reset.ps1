$ValidPath = Test-Path -Path .\WinPE_amd64_ResetChild\mount\Scripts

if($ValidPath -eq $False) {
    New-Item .\WinPE_amd64_ResetChild\mount\Scripts -ItemType Directory
}

Copy-Item -Path .\Prepare-Environment.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Windows\System32
Copy-Item -Path .\Prepare-Reset.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Windows\System32

# Powershell scripts
Copy-Item -Path .\Prepare-Environment.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Scripts
Copy-Item -Path .\Prepare-Reset.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Scripts
Copy-Item -Path .\Enable-Unattend.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Scripts
Copy-Item -Path .\Get-UnattendedFile.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Scripts
Copy-Item -Path .\Connect-NetworkShare.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Scripts
Copy-Item -Path .\Create-ResetBootEntry.cmd -Destination .\WinPE_amd64_ResetChild\mount\Scripts


# Diskpart scripts
Copy-Item -Path .\Hide-Partitions.diskpart -Destination .\WinPE_amd64_ResetChild\mount\Scripts
Copy-Item -Path .\Create-VirtualDisk-Child.diskpart -Destination .\WinPE_amd64_ResetChild\mount\Scripts
Copy-Item -Path .\Mount-Env-Partitions.diskpart -Destination .\WinPE_amd64_ResetChild\mount\Scripts
Copy-Item -Path .\Mount-VirtualDisk-Parent.diskpart -Destination .\WinPE_amd64_ResetChild\mount\Scripts
Copy-Item -Path .\Mount-VirtualDisk-Child.diskpart -Destination .\WinPE_amd64_ResetChild\mount\Scripts

# startnet.cmd
Copy-Item -Path .\startnet.cmd -Destination .\WinPE_amd64_ResetChild\mount\Windows\System32
Copy-Item -Path .\RunScripts.ps1 -Destination .\WinPE_amd64_ResetChild\mount\Windows\System32