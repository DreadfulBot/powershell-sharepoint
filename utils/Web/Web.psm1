function Get-List-On-Web {
    Param(
        [Microsoft.SharePoint.SPWeb] $web,
        [string] $listUrl
    )

    return $web.GetList($web.Url, $listUrl)
}