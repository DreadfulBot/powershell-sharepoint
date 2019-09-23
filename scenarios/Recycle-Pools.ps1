Import-Module WebAdministration

if([IntPtr]::size -eq 8) { Write-Host 'x64' } else { Write-Host 'x86' }

$appCmd = "C:\Windows\System32\inetsrv\appcmd.exe"

Write-Host "App Pool Recycling Started...."
& $appCmd recycle apppool /apppool.name:"SharePoint - 80" 
& $appCmd recycle apppool /apppool.name:"SharePoint - 4448" 
Write-Host "App Pool Recycling Completed"

Write-Host "[x] sleeping for 5 secs"
Write-Host "-----------------------------------"

sleep(5)

Write-Host "[x] restarting sharepoint timer service"
Write-Host "-----------------------------------"

net stop SPTimerV4
net start SPTimerV4

Write-Host "[x] there are all iis working pools:"
Write-Host "-----------------------------------"

& $appCmd list wp