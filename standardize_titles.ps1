$baseDir = "c:\Users\Gabriel\Documents\toadvillebay.com-main"
$standardTitle = " - Republic of ToadVille Bay (Canada)"

$replacements = @{
    "home.html" = "Home"
    "index.html" = "Welcome"
    "about.html" = "About"
    "search.html" = "Search"
    "blocked.html" = "Site Blocked"
    "404.html" = "Page Not Found"
    "TBExit27.html" = "TBExit27"
    "provincial-flag-reform.html" = "Provincial Flag Reform"
    "operations.html" = "International Expansion Operations"
    
    # Legal
    "Legal\cookies.html" = "Cookie Policy"
    "Legal\termsofservice.html" = "Terms of Service"
    "Legal\privacy.html" = "Privacy Policy"
    "Legal\sanctions.html" = "Sanctions Policy"
    "Legal\communityguidelines.html" = "Community Guidelines"
    
    # Law
    "Law\laws.html" = "Laws"
    "Law\bills.html" = "Bills"
    "Law\applewood-impeachment.html" = "Impeachment of John Mark Applewood"
    "Law\plasticconsumption.html" = "Plastic Consumption Safety Act"
    
    # Immigration
    "Immigration\immigration.html" = "Immigration Services"
    "Immigration\work-permits.html" = "Work Permits"
    "Immigration\study-permits.html" = "Study Permits"
    "Immigration\visas.html" = "Visas & Travel Documents"
    "Immigration\spouse-sponsorship.html" = "Spouse & Partner Sponsorship"
    "Immigration\family-sponsorship.html" = "Family Sponsorship"
    "Immigration\parents-grandparents.html" = "Parents & Grandparents Sponsorship"
    "Immigration\settlement-services.html" = "Settlement Services"
    "Immigration\settle-services.html" = "Settlement & Services"
    "Immigration\rights-responsibilities.html" = "Rights and Responsibilities"
    "Immigration\pr-card.html" = "Permanent Resident Card"
    "Immigration\forms-guides.html" = "Immigration Forms & Guides"
    "Immigration\forms-documents.html" = "Immigration Forms & Documents"
    "Immigration\legal-assistance.html" = "Immigration Legal Assistance"
    "Immigration\know-your-rights.html" = "Immigration Rights"
    "Immigration\deportation.html" = "Deportation Process"
    "Immigration\biometrics.html" = "Biometrics Appointments"
    "Immigration\court-information.html" = "Immigration Court Information"
    "Immigration\application-status.html" = "Check Application Status"
    "Immigration\emergency-contacts.html" = "Emergency Contacts"
    "Immigration\eta-countries-added.html" = "New eTA Countries"
    
    # Circumnavigation
    "Guides\guides.html" = "Guides & Tips"
    
    # Government
    "Government\government.html" = "Government"
    "Government\president.html" = "President"
    "Government\prime-minister.html" = "Prime Minister"
    
    # Culture and History
    "Culture and History\cultureandhistory.html" = "Culture and History"
    "Culture and History\anthem.html" = "National Anthem"
    "Culture and History\branding.html" = "Branding"
    "Culture and History\flag-etiquette.html" = "Flag Etiquette"
    "Culture and History\gabe-the-narwhal.html" = "Gabe the Narwhal"
    "Culture and History\1915referendum.html" = "1915 Independence Referendum"
    "Culture and History\1964reftex.html" = "1964 Texica Independence Referendum"
    "Culture and History\2026puertovalleref.html" = "2026 ToadVille Sur Secession Referendum"
    "Culture and History\2026zelenoboraref.html" = "2026 Secession Referendum"
    
    # Citizenship
    "Citizenship\citizenship.html" = "Citizenship"
    "Citizenship\apply-citizenship.html" = "Apply for Citizenship"
    "Citizenship\citizenship-test.html" = "Citizenship Test"
    "Citizenship\ceremony.html" = "Citizenship Ceremony"
    "Citizenship\dual-citizenship.html" = "Dual Citizenship"
    "Citizenship\ordinary-passport.html" = "Ordinary Passport"
    "Citizenship\passports.html" = "Passport Services"
    "Citizenship\proof-citizenship.html" = "Proof of Citizenship"
    "Citizenship\renounce-citizenship.html" = "Renounce Citizenship"
    
    # Cities
    "Cities\cities.html" = "Cities"
    "Cities\toadvillebaydf.html" = "ToadVille Bay D.F."
    
    # Provinces
    "Provinces\provinces.html" = "Provinces"
    "Provinces\amilpan.html" = "Amilpan"
    "Provinces\desierto-altos.html" = "Desierto Altos"
    "Provinces\distrito-federal.html" = "Distrito Federal"
    "Provinces\metepan.html" = "Metepan"
    "Provinces\mihajl.html" = "Mihajl"
    "Provinces\national-preserve.html" = "National Preserve"
    "Provinces\puerto-valle.html" = "Puerto Valle"
    "Provinces\sierra.html" = "Sierra"
    "Provinces\sonora.html" = "Sonora"
    "Provinces\tasiq-nunaat.html" = "Tasiq Nunaat"
    "Provinces\tepayan.html" = "Tepayán"
    "Provinces\texica.html" = "Texica"
    "Provinces\toadville-sur.html" = "ToadVille Sur"
    "Provinces\zelenobora.html" = "Zelenobora"
}

foreach ($relPath in $replacements.Keys) {
    $fullPath = Join-Path $baseDir $relPath
    if (Test-Path $fullPath) {
        $content = Get-Content $fullPath -Raw -Encoding UTF8
        $pageName = $replacements[$relPath]
        
        # Update title tag (handle both – and - and various Unicode issues)
        $content = $content -replace '<title>[^<]*</title>', "<title>$pageName$standardTitle</title>"
        
        # Update og:title (handle both property orders and various separators)
        $content = $content -replace 'property="og:title"\s+content="[^"]*"', "property=`"og:title`" content=`"$pageName$standardTitle`""
        $content = $content -replace 'content="[^"]*"\s+property="og:title"', "content=`"$pageName$standardTitle`" property=`"og:title`""
        
        $content | Set-Content $fullPath -Encoding UTF8
        Write-Host "Updated: $relPath"
    } else {
        Write-Host "Not found: $fullPath"
    }
}

Write-Host "Done!"
