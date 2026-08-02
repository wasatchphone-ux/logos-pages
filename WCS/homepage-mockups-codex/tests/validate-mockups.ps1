param(
    [string]$Page = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$concepts = [ordered]@{
    "concept-01-cinematic.html" = @{
        Concept = "cinematic-editorial"
        Layout = "split-diagonal"
        Motion = "poster-reveal"
        Type = "oswald-dm-sans"
        Color = "noir-red-gold"
    }
    "concept-02-gridline.html" = @{
        Concept = "swiss-brutalist"
        Layout = "exposed-grid"
        Motion = "ticker-snap"
        Type = "oswald-mono"
        Color = "paper-black-red"
    }
    "concept-03-neighbor.html" = @{
        Concept = "warm-community"
        Layout = "asymmetric-collage"
        Motion = "gentle-drift"
        Type = "serif-dm-sans"
        Color = "cream-ink-gold"
    }
    "concept-04-first-round.html" = @{
        Concept = "conversion-landing"
        Layout = "form-first-product"
        Motion = "guided-progress"
        Type = "condensed-modern"
        Color = "charcoal-ivory-red"
    }
}

$programs = @(
    "Muay Thai",
    "MMA",
    "Jiu Jitsu",
    "Boxing",
    "Women",
    "Youth Program",
    "Strength &amp; Conditioning"
)

$coaches = @(
    "Rad Martinez",
    "Roberto Salomao",
    "Kani Correa",
    "Master Piboon Soumphol",
    "Jeff",
    "Cheryl"
)

$requiredIds = @(
    'id="programs"',
    'id="why-wasatch"',
    'id="beginner"',
    'id="coaches"',
    'id="reviews"',
    'id="faq"',
    'id="resources"',
    'id="visit"',
    'id="lead-form"',
    'id="final-cta"'
)

$targets = if ($Page) {
    if (-not $concepts.Contains($Page)) {
        throw "Unknown concept file: $Page"
    }
    @($Page)
}
else {
    @($concepts.Keys)
}

$failures = [System.Collections.Generic.List[string]]::new()

function Require-Text {
    param(
        [string]$Html,
        [string]$Needle,
        [string]$FileName
    )

    if ($Html.IndexOf($Needle, [System.StringComparison]::OrdinalIgnoreCase) -lt 0) {
        $failures.Add("$FileName is missing: $Needle")
    }
}

foreach ($fileName in $targets) {
    $path = Join-Path $root $fileName
    if (-not (Test-Path -LiteralPath $path)) {
        $failures.Add("$fileName does not exist")
        continue
    }

    $html = Get-Content -LiteralPath $path -Raw
    $profile = $concepts[$fileName]

    Require-Text $html '<meta name="viewport"' $fileName
    Require-Text $html '<nav' $fileName
    Require-Text $html '<main' $fileName
    Require-Text $html '<h1' $fileName
    Require-Text $html 'Orem' $fileName
    Require-Text $html 'Utah County' $fileName
    Require-Text $html 'Come Meet the New You.' $fileName
    Require-Text $html 'highest Google-rated gym in Utah County' $fileName
    Require-Text $html '329' $fileName
    Require-Text $html '"@type": "ExerciseGym"' $fileName
    Require-Text $html '972 N 1430 W' $fileName
    Require-Text $html '801-857-0611' $fileName
    Require-Text $html 'maps.google.com/maps' $fileName
    Require-Text $html 'name="name"' $fileName
    Require-Text $html 'name="email"' $fileName
    Require-Text $html 'name="phone"' $fileName
    Require-Text $html 'name="program"' $fileName
    Require-Text $html 'Youth Juniors' $fileName
    Require-Text $html 'Youth Seniors' $fileName
    Require-Text $html 'Adult programs' $fileName
    Require-Text $html '2026' $fileName
    Require-Text $html '<details' $fileName
    Require-Text $html "data-concept=`"$($profile.Concept)`"" $fileName
    Require-Text $html "data-layout=`"$($profile.Layout)`"" $fileName
    Require-Text $html "data-motion=`"$($profile.Motion)`"" $fileName
    Require-Text $html "data-type-system=`"$($profile.Type)`"" $fileName
    Require-Text $html "data-color-mode=`"$($profile.Color)`"" $fileName

    foreach ($program in $programs) {
        Require-Text $html $program $fileName
    }

    foreach ($coach in $coaches) {
        Require-Text $html $coach $fileName
    }

    foreach ($id in $requiredIds) {
        Require-Text $html $id $fileName
    }

    $claimIndex = $html.IndexOf("highest Google-rated gym in Utah County", [System.StringComparison]::OrdinalIgnoreCase)
    $programIndex = $html.IndexOf('id="programs"', [System.StringComparison]::OrdinalIgnoreCase)
    if ($claimIndex -lt 0 -or $programIndex -lt 0 -or $claimIndex -gt $programIndex) {
        $failures.Add("$fileName does not place the Google-rating claim before the program section")
    }

    foreach ($forbidden in @("free trial", "special offer", "seasonal promotion", '$59', '$65')) {
        if ($html.IndexOf($forbidden, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
            $failures.Add("$fileName contains forbidden offer language: $forbidden")
        }
    }
}

if (-not $Page) {
    $indexPath = Join-Path $root "index.html"
    if (-not (Test-Path -LiteralPath $indexPath)) {
        $failures.Add("index.html does not exist")
    }
    else {
        $index = Get-Content -LiteralPath $indexPath -Raw
        foreach ($fileName in $concepts.Keys) {
            Require-Text $index "href=`"$fileName`"" "index.html"
        }
        foreach ($reference in @("Temple Noble Art", "25 Live", "Born &amp; Bred", "Dragon Gym")) {
            Require-Text $index $reference "index.html"
        }
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Validated $($targets.Count) homepage concept(s) with 0 failures."
