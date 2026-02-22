# Fix root level files
@('home.html', 'operations.html', 'provincial-flag-reform.html', 'TBExit27.html', 'about.html', 'search.html', 'blocked.html', 'index.html', '404.html') | ForEach-Object {
    $file = $_
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        if ($content -like '*site-footer-text*') {
            $newContent = $content -replace 'src="scripts/footer.js"', 'src="./scripts/footer.js"'
            $newContent | Set-Content $file -Encoding UTF8
            Write-Host "Fixed root: $file"
        }
    }
}

# Get all subdirectory HTML files and fix path  
$baseDir = Get-Location
Get-ChildItem -Recurse -Filter '*.html' -File | ForEach-Object {
    $isRootFile = $false
    @('home.html', 'index.html', '404.html', 'about.html', 'operations.html', 'provincial-flag-reform.html', 'TBExit27.html', 'search.html', 'blocked.html') | ForEach-Object {
        if ($_.FullName.EndsWith($_)) { $isRootFile = $true }
    }
    
    if (-not $isRootFile) {
        $content = Get-Content $_.FullName -Raw
        if ($content -like '*site-footer-text*' -and $content -like '*src="scripts/footer.js"*') {
            $newContent = $content -replace 'src="scripts/footer.js"', 'src="../scripts/footer.js"'
            $newContent | Set-Content $_.FullName -Encoding UTF8
            Write-Host "Fixed subdir: $($_.FullName)"
        }
    }
}
Write-Host "Done!"
