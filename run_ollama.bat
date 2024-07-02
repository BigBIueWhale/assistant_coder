setlocal enabledelayedexpansion

REM Listen on all interfaces (instead of default 127.0.0.1)
set OLLAMA_HOST=0.0.0.0

REM Start daemon. Can be killed from Windows 10/11 tray
ollama serve
