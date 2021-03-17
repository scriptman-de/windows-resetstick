# GET Serial Number
$serial = (Get-CimInstance Win32_Bios).SerialNumber
$pantherPath = "V:\Windows\Panther"

function Test-Panther {
	$pathTest = Test-Path($pantherPath)
	if (-not $pathTest) {
		New-Item -Type Directory -Path $pantherPath
	}
}

Write-Host $env:UNATTED_AVAIL
if ($env:UNATTED_AVAIL) {
	Write-Host "Prüfe ob Unattend-Datei vorhanden ist."
	$xmlFileName = "unattend-$serial.xml"
	$xmlFile = $env:UNATTENDEDFOLDER + "\" + $xmlFileName
	$isXMLavailable = Test-Path $xmlFile

	if ($isXMLavailable) {
		Test-Panther

		Write-Host "Kopiere Unattend-Datei"
		Copy-Item -Path $xmlFile -Destination "$pantherPath\unattend.xml"
	}
	else {
		Write-Host -BackgroundColor Red -ForegroundColor Black "'$xmlFile' ist nicht vorhanden"
		Write-Host -ForegroundColor Red "...Das System wird ohne Sysprep starten!"
	}

	Exit
}

# Enable setup
try {
	Test-Panther
	
	$result = Invoke-RestMethod -Uri "http://windowsreset/api/v1/unattend?serial=$serial" -Method GET -OutFile "$pantherPath\unattend.xml"
	Write-Host -BackgroundColor Green -ForegroundColor Black $result.message
}
catch {
	
	Write-Host -BackgroundColor Red -ForegroundColor Black "Unattended Datei konnte nicht abgerufen werden!"
}
