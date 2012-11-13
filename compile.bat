@echo off

set backupdir=C:\Users\cheese\Desktop\zombiesbackup
set coddir=D:\Games\Call of Duty 1.1\main

echo **** Backing up...
echo.

cd zombies
@copy /Y *.* "%backupdir%\zombies"
cd ../modules
@copy /Y *.* "%backupdir%\modules"
cd ../maps/mp/gametypes
@copy /Y *.* "%backupdir%\maps\mp\gametypes"

echo.
echo **** Backup complete.
echo **** Updating...
echo.

echo ./zombies
cd ../../../zombies
copy /Y *.* "%coddir%\zombies"
echo ./modules
cd ../modules
copy /Y *.* "%coddir%\modules"
echo ./maps/mp/gametypes
cd ../maps/mp/gametypes
copy /Y *.* "%coddir%\maps\mp\gametypes"

echo.
echo **** Update complete.
pause