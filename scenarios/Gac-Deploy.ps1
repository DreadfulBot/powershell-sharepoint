param([String[]]$dllPath)

Import-Module WebAdministration

if([IntPtr]::size -eq 8) { Write-Host 'x64' } else { Write-Host 'x86' }

$gacutil = "C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\gacutil.exe"

Write-Host "[x] running gacutil"
Write-Host "-----------------------------------"

foreach($i in $dllPath) {
	Write-Host "[x] dll path is $i"
	& $gacutil -i $i
	Write-Host "-----------------------------------"
}

& "$PSScriptRoot\Recycle-Pools.ps1"