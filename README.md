# OG Xbox Tools

This repository contains a set of utilities for the OG Xbox. The tools provided include:

- **XBMCEmustationSynopsisFilesGenerator**: Generates synopsis files for XBMC-Emustation from `gamelist.xml` files used by EmulationStation.
- **OGXboxROMRenamer**: Renames ROM files to be compatible with the OG Xbox by removing unwanted text and truncating filenames.

## Scripts

### XBMCEmustationSynopsisFilesGenerator

- **`XBMCEmustationSynopsisFilesGenerator.ps1`**: PowerShell script to generate synopsis files from `gamelist.xml` files. It extracts game details and creates corresponding text files in a "synopsis" subdirectory.
- **`XBMCEmustationSynopsisFilesGenerator.bat`**: Batch script that allows you to drag and drop folders directly onto it. This will call the PowerShell script to generate synopsis files for the dropped folders.

### OGXboxROMRenamer

- **`OGXboxROMRenamer.ps1`**: PowerShell script to rename ROM files by removing text within parentheses and brackets, and truncating filenames to a maximum length of 42 characters.
- **`OGXboxROMRenamer.bat`**: Batch script that allows you to drag and drop folders directly onto it. This will call the PowerShell script to rename ROM files in the dropped folders.

## Usage

```powershell
.\XBMCEmustationSynopsisFilesGenerator.ps1 "C:\Path\To\Directory1" "C:\Path\To\Directory2"
```

```powershell
.\OGXboxROMRenamer.ps1 "C:\Path\To\Directory1" "C:\Path\To\Directory2"
```
