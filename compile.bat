@echo off

set coddir=D:\Games\Call of Duty 1.1\main

echo Updating...
echo.

echo ./zombies
cd zombies
copy /Y *.* "%coddir%\zombies"
echo.

echo ./modules
cd ../modules
copy /Y *.* "%coddir%\modules"
echo.

echo ./maps/mp/gametypes
cd ../maps/mp/gametypes
copy /Y *.* "%coddir%\maps\mp\gametypes"
echo.

echo Completed.

pause