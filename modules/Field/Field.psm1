function Get-Lookup-Value($item, $field) {
    return new-object Microsoft.SharePoint.SPFieldLookupValue($item[$field])
}