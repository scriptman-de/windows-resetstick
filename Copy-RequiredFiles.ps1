Copy-Item -Path .\Prepare-Environment.ps1 .\WinPE_amd64_ResetChild1\mount\Windows\System32
Copy-Item -Path .\Prepare-Reset.ps1 .\WinPE_amd64_ResetChild1\mount\Windows\System32

# Powershell scripts
Copy-Item -Path .\Prepare-Environment.ps1 .\WinPE_amd64_ResetChild1\mount\Scripts
Copy-Item -Path .\Prepare-Reset.ps1 .\WinPE_amd64_ResetChild1\mount\Scripts
Copy-Item -Path .\Enable-Unattend.ps1 .\WinPE_amd64_ResetChild1\mount\Scripts
Copy-Item -Path .\Get-UnattendedFile.ps1 .\WinPE_amd64_ResetChild1\mount\Scripts
Copy-Item -Path .\Connect-NetworkShare.ps1 .\WinPE_amd64_ResetChild1\mount\Scripts


# Diskpart scripts
Copy-Item -Path .\Hide-Partitions.diskpart .\WinPE_amd64_ResetChild1\mount\Scripts
Copy-Item -Path .\Create-VirtualDisk-Child.diskpart .\WinPE_amd64_ResetChild1\mount\Scripts
Copy-Item -Path .\Mount-Env-Partitions.diskpart .\WinPE_amd64_ResetChild1\mount\Scripts
Copy-Item -Path .\Mount-VirtualDisk-Parent.diskpart .\WinPE_amd64_ResetChild1\mount\Scripts
Copy-Item -Path .\Mount-VirtualDisk-Child.diskpart .\WinPE_amd64_ResetChild1\mount\Scripts