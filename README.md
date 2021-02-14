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
kommt noch ...