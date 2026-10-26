@echo off
chcp 65001 >nul
REM Практическая работа: Диагностика клиентского компьютера
REM Автор: Воробьев Андрей Дата: 26.10.2026

set "REPORT=%~dp0pc_report.txt"

REM --- Заголовок ---
echo Диагностика компьютера> "%REPORT%"
echo ==============================>> "%REPORT%"
echo.>> "%REPORT%"

REM --- Операционная система ---
echo Операционная система>> "%REPORT%"
for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value') do for /f "delims=" %%b in ("%%a") do >>"%REPORT%" echo Название: %%b
for /f "tokens=2 delims==" %%a in ('wmic os get Version /value') do for /f "delims=" %%b in ("%%a") do >>"%REPORT%" echo Версия: %%b
echo ------------------------------>> "%REPORT%"

REM --- Процессор ---
echo Процессор>> "%REPORT%"
for /f "tokens=2 delims==" %%a in ('wmic cpu get Name /value') do for /f "delims=" %%b in ("%%a") do >>"%REPORT%" echo %%b
echo ------------------------------>> "%REPORT%"

REM --- Оперативная память (КБ -> ГБ) ---
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /value') do for /f "delims=" %%b in ("%%a") do set /a RAM_TOTAL=%%b/1048576
for /f "tokens=2 delims==" %%a in ('wmic OS get FreePhysicalMemory /value') do for /f "delims=" %%b in ("%%a") do set /a RAM_FREE=%%b/1048576
echo Оперативная память>> "%REPORT%"
echo Всего памяти: %RAM_TOTAL% ГБ>> "%REPORT%"
echo Свободно памяти: %RAM_FREE% ГБ>> "%REPORT%"
echo ------------------------------>> "%REPORT%"

REM --- Диск C (байты -> ГБ; отбрасываем 3 последние цифры, чтобы set /a не переполнился) ---
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get Size /value') do for /f "delims=" %%b in ("%%a") do set "S=%%b"
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value') do for /f "delims=" %%b in ("%%a") do set "F=%%b"
set /a DISK_TOTAL=%S:~0,-3%/1048576
set /a DISK_FREE=%F:~0,-3%/1048576
echo Диск C>> "%REPORT%"
echo Всего: %DISK_TOTAL% ГБ>> "%REPORT%"
echo Свободно: %DISK_FREE% ГБ>> "%REPORT%"
echo ------------------------------>> "%REPORT%"

REM --- Установленные программы (реестр) ---
echo Установленные программы>> "%REPORT%"
for /f "tokens=2,*" %%a in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s ^| findstr /r /c:"DisplayName *REG_SZ"') do >>"%REPORT%" echo %%b
for /f "tokens=2,*" %%a in ('reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s ^| findstr /r /c:"DisplayName *REG_SZ"') do >>"%REPORT%" echo %%b

REM --- Вывод отчёта в окно ---
type "%REPORT%"
echo.
echo Отчёт сохранён
pause