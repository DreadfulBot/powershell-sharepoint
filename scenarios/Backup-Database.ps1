.\Load-Module.ps1 SQLCmd
.\Load-Module.ps1 Date
.\Load-Module.ps1 ParameterBinder

$serverInstance = "BOT-SP2016"

$databases = @(@{ 
        name = "WSS_Content_ROZ"
        path = "\db\roz\content\dev\WSS_Content_ROZ_{date}_{time}.bak"
    })

$hostInfo = @{
    path     = $env:hostPath
    user     = $env:hostUser
    password = $env:hostPassword
}

Write-Host "[x] database preconfig"
Show-Advanced-Options $serverInstance
Xp-CmdShell $serverInstance

Write-Host "[x] virtual path mappings"
Net-Use-Delete "H:" $serverInstance
Net-Use-Add "H:" $hostInfo.path $hostInfo.user $hostInfo.password $serverInstance

$date = Get-Date

$databasePathParams = @(
    @{
        key   = 'date'
        value = $(Get-Date-Russia-Format $date)
    },
    @{
        key   = 'time'
        value = $(Get-Time $date)
    }
)

foreach ($database in $databases) {
    $databasePath = Join-Path -Path $hostInfo.path -ChildPath $(BindParams $database.path $databasePathParams)

    Write-Host "[x] database $($database.name) backing up to $databasePath"

    Backup-Database $database.name $databasePath $serverInstance
}