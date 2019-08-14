Add-PSSnapin Microsoft.Sharepoint.Powershell

.\Load-Module.ps1 Web

$siteUrl = "http://bot-sp2016/"
$webUrl = "http://bot-sp2016/SalesManagement/"
$list = "Sale"

$web = Get-SPWeb $webUrl
$list = Get-List-On-Web $web $list

