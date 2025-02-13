@echo off
:: Menentukan judul jendela Command Prompt
title ModPack Updater Lethal Company

setlocal enabledelayedexpansion

:: Warna teks untuk meningkatkan UI
for /f "delims==" %%A in ('"echo prompt $E| cmd"') do set "ESC=%%A"

:: URL tempat mengambil nama file ZIP
set VERSION_URL=https://raw.githubusercontent.com/dyrixx/modlethal1x/refs/heads/main/version.txt

:: Folder sementara untuk menyimpan file yang diunduh
set TEMP_FILE=%TEMP%\version.txt

:: Unduh nama file ZIP
echo %ESC%[36mMengambil file mod Lethal Company...%ESC%[0m
curl -s %VERSION_URL% -o %TEMP_FILE%
if %errorlevel% neq 0 (
    echo %ESC%[31mGagal mengambil file mod Lethal Company!%ESC%[0m
    exit /b
)

:: Baca isi file untuk mendapatkan nama file ZIP
set /p ZIP_NAME=<%TEMP_FILE%
echo %ESC%[32mNama file mod Lethal Company: %ZIP_NAME%%ESC%[0m

:: Hapus file sementara
del %TEMP_FILE%

:: URL tempat mengunduh file ZIP
set DOWNLOAD_URL=https://github.com/dyrixx/modlethal1x/releases/download/public/%ZIP_NAME%

:: Unduh file ZIP dengan progress bar
echo %ESC%[36mMengunduh %ZIP_NAME%...%ESC%[0m
curl -# -L -o "%ZIP_NAME%" %DOWNLOAD_URL%
if %errorlevel% neq 0 (
    echo %ESC%[31mGagal mengunduh file mod Lethal Company!%ESC%[0m
    exit /b
)

:: Hapus folder BepInEx jika ada sebelum ekstraksi
if exist "BepInEx" (
    echo %ESC%[33mMenghapus folder BepInEx...%ESC%[0m
    rmdir /s /q "BepInEx"
)

:: Mengekstrak file ZIP dengan menimpa file yang sudah ada
echo %ESC%[36mMengekstrak file ZIP...%ESC%[0m
powershell -command "Expand-Archive -Path '%ZIP_NAME%' -DestinationPath '.' -Force"
if %errorlevel% neq 0 (
    echo %ESC%[31mGagal mengekstrak file mod Lethal Company!%ESC%[0m
    exit /b
)

:: Hapus file ZIP setelah ekstraksi
del "%ZIP_NAME%"

echo %ESC%[32mMod berhasil diperbarui!%ESC%[0m

:: Jalankan Lethal Company.exe jika ada
if exist "Lethal Company.exe" (
    echo %ESC%[36mMenjalankan Lethal Company...%ESC%[0m
    start "" "%CD%\Lethal Company.exe"
) else (
    echo %ESC%[31mGagal menemukan Lethal Company.exe!%ESC%[0m
)

:: Selesai
echo %ESC%[32mProses selesai!%ESC%[0m
exit /b
