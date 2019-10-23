Function BindParams(
    [System.String] $template,
    [object[]] $params
) {
    $result = $template

    foreach($parameter in $params) {
        $result = $result -replace "{$($parameter.key)}", $parameter.value
    }

    return $result
}