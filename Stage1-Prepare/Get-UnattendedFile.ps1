# GET Serial Number
$serial = (Get-CimInstance Win32_Bios).SerialNumber
$pantherPath = "V:\Windows\Panther"

# Enable setup
try {
	$pathTest = Test-Path($pantherPath)
	if (-not $pathTest) {
		New-Item -Type Directory -Path $pantherPath
	}
	
	$result = Invoke-RestMethod -Uri "http://windowsreset/api/v1/unattend?serial=$serial" -Method GET -OutFile "$($pantherPath)\unattend.xml"
	Write-Host -BackgroundColor Green -ForegroundColor Black $result.message
}
catch {
	
	Write-Host -BackgroundColor Red -ForegroundColor Black "Unattended Datei konnte nicht abgerufen werden!"
}
