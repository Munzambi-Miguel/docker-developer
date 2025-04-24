@echo off
pwsh -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0\containers\bash\win.ps1' %*"

