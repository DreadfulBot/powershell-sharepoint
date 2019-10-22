function Add-SharePoint-Snapin {
  Add-PSSnapin Microsoft.Sharepoint.Powershell
}

function Remove-SharePoint-Snapin {
    if ($null -ne (Get-PSSnapin -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue)) {
        Remove-PSSnapin Microsoft.SharePoint.PowerShell
    }
}