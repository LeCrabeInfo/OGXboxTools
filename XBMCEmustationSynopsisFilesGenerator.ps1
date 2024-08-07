<#
.SYNOPSIS
    PowerShell script to generate synopsis files for XBMC-Emustation (OG Xbox) from gamelist.xml files 
    used by EmulationStation.

.NOTES
    Author: Le Crabe
    License: Creative Commons Attribution 4.0 International (CC BY 4.0)

.EXAMPLE
    .\XBMCEmustationSynopsisFilesGenerator.ps1 "C:\Path\To\Directory1" "C:\Path\To\Directory2"
#>

[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments=$true, Mandatory=$true)]
    [string[]]$Directories
)

if ($Directories.Count -eq 0) {
    Write-Host "Usage: .\XBMCEmustationSynopsisFilesGenerator.ps1 <directory1> <directory2> ..."
    exit 1
}

foreach ($Dir in $Directories) {
    $GamelistPath = Join-Path -Path $Dir -ChildPath "gamelist.xml"
    $Destination = Join-Path -Path $Dir -ChildPath "synopsis"

    if (-not (Test-Path $GamelistPath)) {
        Write-Host "Error: gamelist.xml not found in $Dir"
        continue
    }

    if (-not (Test-Path $Destination)) {
        New-Item -Path $Destination -ItemType Directory | Out-Null
    }

    $TextName = "Name: unknown"
    $TextDescription = "_________________________`n"
    $TextRating = "Rating: unknown"
    $TextReleaseDate = "Released: unknown"
    $TextDeveloper = "Developer: unknown"
    $TextPublisher = "Publisher: unknown"
    $TextGenre = "Genre: unknown"
    $TextPlayers = "Players: at least 1"

    $InputData = Get-Content -Path $GamelistPath

    foreach ($Line in $InputData) {
        if ($Line -match "<path>(.*?)</path>") {
            $TextFilename = $matches[1] -replace '&#39;', "'" -replace '&amp;', '&' -replace '\+', '_'
            $TextFilename = $TextFilename.Trim()
            $BaseName, $Ext = [System.IO.Path]::GetFileNameWithoutExtension($TextFilename), [System.IO.Path]::GetExtension($TextFilename)
            $TextFilenameExt = "Filename: " + $BaseName
            Write-Host "Processing:" $TextFilename
        }

        if ($Line -match "<name>(.*?)</name>") {
            $TextName = $matches[1] -replace '&#39;', "'" -replace '&amp;', '&'
            $TextName = 'Name: ' + $TextName
            if ($TextName -eq "Name: ") {
                $TextName = "Name: " + $BaseName
            }
        }

        if ($Line -match "<desc>(.*?)</desc>") {
            $TextDescription = $matches[1] -replace '&amp;quot;', '"' -replace '&#39;', "'" -replace '&amp;', '&' -replace 'quot;', '"' -replace '&#xD;&#xA;', '[CR]' -replace '&#xA;&#xA;', '[CR]' -replace '&#xD;&#xD;', '[CR]' -replace '&#xA;', '[CR]' -replace '&#xD;', '[CR]'
            $TextDescription = "_________________________`n" + $TextDescription
        }

        if ($Line -match "<rating>(.*?)</rating>") {
            $TextRating = $matches[1]
            $TextRating = 'Rating: ' + $TextRating
            if ($TextRating -eq "Rating: ") {
                $TextRating = "Rating: unknown"
            }
        }

        if ($Line -match "<releasedate>(.*?)</releasedate>") {
            $TextReleaseDate = $matches[1] -replace 'T.*$', ''
            $TextReleaseDateYear = $TextReleaseDate.Substring(0, 4)
            $TextReleaseDate = 'Release Year: ' + $TextReleaseDateYear
            if ($TextReleaseDate -eq "Release Year: .." -or $TextReleaseDate -eq "Release Year: ") {
                $TextReleaseDate = "Released: unknown"
            }
        }

        if ($Line -match "<developer>(.*?)</developer>") {
            $TextDeveloper = $matches[1] -replace '&#39;', "'" -replace '&amp;', '&'
            $TextDeveloper = 'Developer: ' + $TextDeveloper
            if ($TextDeveloper -eq "Developer: ") {
                $TextDeveloper = "Developer: unknown"
            }
        }

        if ($Line -match "<publisher>(.*?)</publisher>") {
            $TextPublisher = $matches[1] -replace '&#39;', "'" -replace '&amp;', '&'
            $TextPublisher = 'Publisher: ' + $TextPublisher
            if ($TextPublisher -eq "Publisher: ") {
                $TextPublisher = "Publisher: unknown"
            }
        }

        if ($Line -match "<genre>(.*?)</genre>") {
            $TextGenre = $matches[1] -replace '&#39;', "'" -replace '&amp;', '&'
            $TextGenre = 'Genre: ' + $TextGenre
            if ($TextGenre -eq "Genre: ") {
                $TextGenre = "Genre: unknown"
            }
        }

        if ($Line -match "<players>(.*?)</players>") {
            $TextPlayers = $matches[1]
            $TextPlayers = 'Players: ' + $TextPlayers
            if ($TextPlayers -eq "Players: ") {
                $TextPlayers = "Players: unknown"
            }
        }

        if ($BaseName) {
            $OutputFilePath = Join-Path -Path $Destination -ChildPath ($BaseName + '.txt')
            $OutputContent = @(
                $TextFilenameExt
                $TextName
                $TextRating
                $TextReleaseDate
                $TextDeveloper
                $TextPublisher
                $TextGenre
                $TextPlayers
                $TextDescription
            )
            $OutputContent | Set-Content -Path $OutputFilePath
        }
    }
}
