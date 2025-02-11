@echo off
:: Menentukan judul jendela Command Prompt
title Launcher Lethal Companys

:: Mengecek apakah skrip dijalankan sebagai administrator
>nul 2>&1 net session
if %errorlevel% neq 0 (
    echo Launcher ini membutuhkan izin administrator. Menjalankan ulang dengan izin administrator...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit /b
)
setlocal enabledelayedexpansion

:: URL tempat mengambil nama file ZIP
set VERSION_URL=https://raw.githubusercontent.com/dyrixx/modlethal1x/refs/heads/main/version.txt

:: Folder sementara untuk menyimpan file yang diunduh
set TEMP_FILE=%TEMP%\version.txt

:: Unduh nama file ZIP
echo Mengambil file mod Lethal Company...
curl -s %VERSION_URL% -o %TEMP_FILE%
if %errorlevel% neq 0 (
    echo Gagal file mod Lethal Company!
    exit /b
)

:: Baca isi file untuk mendapatkan nama file ZIP
set /p ZIP_NAME=<%TEMP_FILE%
echo Nama file mod Lethal Company: %ZIP_NAME%

:: Hapus file sementara
del %TEMP_FILE%

:: URL tempat mengunduh file ZIP
set DOWNLOAD_URL=https://github.com/dyrixx/modlethal1x/releases/download/public/%ZIP_NAME%

:: Unduh file ZIP
echo Mengunduh %ZIP_NAME% ...
curl -L -o "%ZIP_NAME%" %DOWNLOAD_URL%
if %errorlevel% neq 0 (
    echo Gagal mengunduh file mod Lethal Company!
    exit /b
)

:: Hapus folder BepInEx jika ada sebelum ekstraksi
if exist "BepInEx" (
    echo Menghapus folder BepInEx...
    rmdir /s /q "BepInEx"
)

:: Mengekstrak file ZIP dengan menimpa file yang sudah ada
echo Mengekstrak file ZIP...
powershell -command "Expand-Archive -Path '%ZIP_NAME%' -DestinationPath '.' -Force"
if %errorlevel% neq 0 (
    echo Gagal mengekstrak file mod Lethal Company!
    exit /b
)

:: Hapus file ZIP setelah ekstraksi
del "%ZIP_NAME%"

:: Jalankan Lethal Company.exe jika ada
if exist "Lethal Company.exe" (
    echo Menjalankan Lethal Company...
    start "" "%CD%\Lethal Company.exe"
) else (
    echo Gagal menemukan Lethal Company.exe!
)

:: Selesai
echo Proses selesai!
exit /b
