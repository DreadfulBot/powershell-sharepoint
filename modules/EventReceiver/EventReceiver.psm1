function Disable-Event-Firing() {
    $myAss = [Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
    $type = $myAss.GetType("Microsoft.SharePoint.SPEventManager")
    $prop = $type.GetProperty("EventFiringDisabled", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Static);
    $prop.SetValue($null, $true)
    $prop.GetValue($null)
}