# Windows Reset Stick

Scripts zum Erstellen einer Windows NativeBoot Umgebung zum automatischen Zurücksetzen in den Urzustand.

## tl;dr

* Windows AIK-Shell Run: ``New-WinPE-BootMedia.cmd``
* Mount boot.wim
* ``Copy-RequiredFiles.ps1``
* Upload boot.wim zu WDS (falls PXE-Boot des WinPE)
* Bootstick erstellen mit FAT32 und Datei _IMAGEDRIVE.MRK_
* ``Copy-Scripts.ps1``
* Im WinPE Script ``Prepare-Environment.ps1`` ausführen
* Booten, Einstellungen, Programme, etc.
* Wieder im WinPE Script ``Prepare-Reset.ps1`` ausführen

## Ausführliche Anleitung

{:toc}


1. Prepare Scripts
    1. Boot Medium
        - New-BootMedia-Prepare.cmd
        - startnet-prepare.cmd
        - Copy-Prepare.ps1
    2. Execution Scripts
        - Run-Prepare.ps1
            - ResetOS.wim
            - win10-PARENT.vhdx (oder auf Netzlaufwerk)
            - Mount-VirtualDisk-Parent.diskpart
        - Enable-Unattend.ps1
        - Get-UnattededFile.ps1

2. Reset Scripts
    1. Boot Medium
        - New-BootMedia-Reset.cmd
        - startnet-reset.cmd
        - Copy-Reset.ps1
    2. Execution Scripts
        - Run-Reset.ps1
            - Mount-Partitions.ps1
            - Mount-Partitions.diskpart
            - Create-VirtualDisk-Child.diskpart
            - Mount-VirtualDisk-Child.diskpart
            - Create-ResetBootEntry.cmd
            - Hide-Partitions.ps1
            - Hide-Partitions.diskpart

3. Change Scripts
    1. Boot Medium
        - New-BootMedia-Change.cmd
        - startnet-reset.cmd
    2. Execution Scripts
        - Run-Change.ps1
            - Mount-EnvPartitions.diskpart
            - Mount-VirtualDisk-Parent.diskpart
            - Prepare-Change.ps1