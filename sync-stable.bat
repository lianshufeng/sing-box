@echo off
setlocal

cd /d "%~dp0"

echo [1/4] Switch to stable branch...
git switch stable
if errorlevel 1 goto error

echo [2/4] Fetch upstream stable...
git fetch upstream stable
if errorlevel 1 goto error

echo [3/4] Merge upstream/stable...
git merge upstream/stable
if errorlevel 1 goto conflict

echo [4/4] Push to origin stable...
git push origin stable
if errorlevel 1 goto error

echo.
echo Done. stable has been updated and pushed.
goto end

:conflict
echo.
echo Merge stopped because there are conflicts.
echo Resolve the conflicts, then run:
echo   git add .
echo   git commit
echo   git push origin stable
goto end

:error
echo.
echo Update failed. Check the Git message above.

:end
pause
endlocal
