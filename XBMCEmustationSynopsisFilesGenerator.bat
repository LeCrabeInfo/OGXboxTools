@echo off

echo ==============================================
echo    XBMC-Emustation Synopsis Files Generator
echo ==============================================
echo.
echo This script will generate synopsis files for XBMC-Emustation (OG Xbox).
echo It processes gamelist.xml files used by EmulationStation,
echo extracts game details such as name, description, rating, release date,
echo developer, publisher, genre, and players, and creates corresponding
echo text files in a "synopsis" folder within each provided directory.
echo.
echo ---
echo.
echo Press any key to start...
pause >nul
echo.

powershell.exe -file XBMCEmustationSynopsisFilesGenerator.ps1 %*

echo.
echo Process completed! Press any key to exit...
pause >nul
