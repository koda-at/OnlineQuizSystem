@echo off
setlocal
cd /d "%~dp0"
where dotnet >nul 2>nul
if errorlevel 1 (
  echo Install .NET 10 SDK from https://dotnet.microsoft.com/download/dotnet/10.0
  pause
  exit /b 1
)
echo Quiz Studio will start at http://localhost:5080
echo Stop the application with Ctrl+C.
dotnet run --project src\OnlineQuizSystem --launch-profile OnlineQuizSystem
if errorlevel 1 pause
