@echo off

echo =========================
echo    OG Xbox ROM Renamer
echo =========================
echo.
echo This script will rename ROM files to be compatible with the OG Xbox.
echo It removes text within parentheses () and brackets [],
echo and truncates filenames to a maximum length of 42 characters.
echo This ensures the ROM files can be read correctly by the OG Xbox.
echo.
echo ---
echo.
echo Press any key to start...
pause >nul
echo.

set "scriptPath=%~dp0OGXboxROMRenamer.ps1"
powershell.exe -File "%scriptPath%" %*

echo.
echo Process completed! Press any key to exit...
pause >nul
