@echo off
setlocal

cd /d "%~dp0"

echo [1/5] Switch to stable branch...
git switch stable
if errorlevel 1 goto error

echo [2/5] Detect remote...

git remote | findstr /x "upstream" >nul

if errorlevel 1 (
    set REMOTE=origin
    echo Using remote: origin
) else (
    set REMOTE=upstream
    echo Using remote: upstream
)

echo [3/5] Fetch %REMOTE% stable...
git fetch %REMOTE% stable
if errorlevel 1 goto error

echo [4/5] Merge %REMOTE%/stable...
git merge %REMOTE%/stable
if errorlevel 1 goto conflict

echo [5/5] Update workflow trigger file...

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-ddTHH:mm:ss.fffK"') do set SYNC_TIME=%%i

echo last_sync=%SYNC_TIME%> .sync-stable-trigger

git add .sync-stable-trigger

git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Trigger stable sync workflow"
)

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