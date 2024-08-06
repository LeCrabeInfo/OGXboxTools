<#
.SYNOPSIS
    PowerShell script to rename files by removing text within parentheses and brackets,
    and truncating filenames to a maximum length of 42 characters.

.DESCRIPTION
    This script processes all files in specified directories, removes any text within parentheses
    or brackets from the filenames, and ensures the filenames do not exceed a specified maximum
    length of 42 characters. If a filename is modified, the script renames the file and displays
    the old and new filenames.

.PARAMETER Path
    One or more paths to the directories containing the files to be processed.
    Multiple paths can be provided, separated by spaces.

.NOTES
    Author: Le Crabe
    License: Creative Commons Attribution 4.0 International (CC BY 4.0)

.EXAMPLE
    .\OGXboxROMRenamer.ps1 "C:\Path\To\Directory1" "C:\Path\To\Directory2"
#>

[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Path
)

Write-Host "======================================="
Write-Host "          OG Xbox ROM Renamer          "
Write-Host "======================================="
Write-Host
Write-Host "This script will rename ROM files to be compatible with the original Xbox."
Write-Host "It removes text within parentheses () and brackets [],"
Write-Host "and truncates filenames to a maximum length of 42 characters."
Write-Host "This ensures the ROM files can be read correctly by the OG Xbox."
Write-Host
Write-Host "----------------------------------------"
Write-Host

# Process each provided path
foreach ($folder in $Path) {
    # Check if the directory exists
    if (-not (Test-Path $folder)) {
        Write-Host "The specified directory '$folder' does not exist. Skipping..."
        continue
    }

    # Set the maximum length for filenames (excluding the extension)
    $maxLength = 38

    # Iterate over all files in the folder
    Get-ChildItem -Path $folder -File | ForEach-Object {
        # Remove all text within parentheses () and brackets []
        $newName = $_.Name -replace '\s*[\(\[].*?[\)\]]', ''

        # Check if the filename length (excluding the extension) exceeds the maximum length
        $nameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($newName)
        if ($nameWithoutExtension.Length -gt $maxLength) {
            # Truncate the filename to the maximum allowed length
            $nameWithoutExtension = $nameWithoutExtension.Substring(0, $maxLength)
            # Retain the original extension
            $extension = [System.IO.Path]::GetExtension($newName)
            # Create the new full filename
            $newName = "$nameWithoutExtension$extension"
        }

        # Rename the file if necessary
        if ($_.Name -ne $newName) {
            Write-Host "Renaming: $($_.Name) -> To: $newName"
            Rename-Item $_.FullName -NewName $newName
        }
    }
}

Write-Host
Write-Host "Press any key to close..."
[System.Console]::ReadKey($true) | Out-Null
