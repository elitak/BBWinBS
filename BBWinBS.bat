@echo off
set BUSYBOX=%TEMP%\busybox.exe
set BBMH=QmRHEpjXxnyDuHy42v5zocngHALvk2jpenXserVnxk3CsY

REM Always copy, so that this script's busybox.exe can distribution-specific
if exist "%~dp0\busybox.exe" copy /y "%~dp0\busybox.exe" "%BUSYBOX%"

if not exist "%BUSYBOX%" (
  echo ERROR: Can't find busybox.exe in this script's directory or in %TEMP%
  REM echo I will try to fetch it using various methods, if you press Enter.
  echo Close this window if you wish to abort.
  REM pause
)

if not exist "%BUSYBOX%" powershell -command "& { iwr https://ipfs.io/ipfs/%BBMH% -OutFile '%BUSYBOX%' }" 
if not exist "%BUSYBOX%" bitsadmin /transfer mydownloadjob /download /priority normal https://ipfs.io/ipfs/%BBMH% "%BUSYBOX%" 
if not exist "%BUSYBOX%" (
  echo Attempting to fetch via ipfs daemon. Hit Ctrl-C and answer N to "Terminate batch job ?" if it takes more than a minute.
  ipfs cat %BBMH% > "%BUSYBOX%"
  if ["%errorlevel%"]==["0"] ipfs pin add %BBMH%
)

if not exist "%BUSYBOX%" (
  echo Nothing worked, sorry! You could try to download https://ipfs.io/ipfs/QmRHEpjXxnyDuHy42v5zocngHALvk2jpenXserVnxk3CsY manually and save it in the same directory as this script, naming it busybox.exe...
  pause
  exit
)

"%BUSYBOX%" sed "1,/^#! *\/usr\/bin\/env *bash/d" %0 > "%TEMP%\%~n0.sh"

REM Comment out or delete this block if you don't need elevated privileges (UAC)
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\OEgetPrivileges.vbs" 
ECHO UAC.ShellExecute "%BUSYBOX%", "bash %TEMP%\%~n0.sh", "", "runas", 1 >> "%TEMP%\OEgetPrivileges.vbs" 
"%TEMP%\OEgetPrivileges.vbs" 
if ["%errorlevel%"]==["0"] exit /B 

REM If no error or the above is commented out, proceed to run unprivileged
REM TODO this failover is not thoroughly tested
"%BUSYBOX%" bash "%TEMP%\%~n0.sh"
exit /B 

#! /usr/bin/env bash
# DO NOT ALTER THE LINE ABOVE. It demarcates the script below from the bootstrapping above.

echo "Hello, $(whoami)"\!
echo "Press Enter..."
read
