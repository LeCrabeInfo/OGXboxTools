<#
.SYNOPSIS
    PowerShell script to rename files by removing text within parentheses and brackets,
    and truncating filenames to a maximum length of 42 characters.

.NOTES
    Author: Le Crabe
    Repository: https://github.com/LeCrabeInfo/OGXboxTools
    License: Creative Commons Attribution 4.0 International (CC BY 4.0)

.EXAMPLE
    .\OGXboxROMRenamer.ps1 "C:\Path\To\Directory1" "C:\Path\To\Directory2"
#>

[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments=$true, Mandatory=$true)]
    [string[]]$Directories
)

# Set the maximum length for filenames (without the extension)
$maxLength = 38

foreach ($Dir in $Directories) {
    # Check if the directory exists
    if (-not (Test-Path $Dir)) {
        Write-Host "The specified directory '$Dir' does not exist. Skipping..."
        continue
    }

    # Process files in the directory
    Get-ChildItem -Path $Dir -File | ForEach-Object {
        Write-Host "Processing: $($_.Name)"

        # Remove text within parentheses () and brackets []
        $newName = $_.Name -replace '\s*[\(\[].*?[\)\]]', ''

        # Check if the filename length (without the extension) exceeds the maximum length
        $nameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($newName)
        if ($nameWithoutExtension.Length -gt $maxLength) {
            $nameWithoutExtension = $nameWithoutExtension.Substring(0, $maxLength)
            $extension = [System.IO.Path]::GetExtension($newName)
            $newName = "$nameWithoutExtension$extension"
        }

        # Rename the file if necessary
        if ($_.Name -ne $newName) {
            Write-Host "  New name: $newName"
            Rename-Item -Path $_.FullName -NewName $newName
        }
    }
}
