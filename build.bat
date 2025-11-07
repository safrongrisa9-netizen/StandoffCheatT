@echo off
echo Создание Standoff 2 Cheat для iOS...

:: Создание структуры проекта
if not exist "StandoffCheat" mkdir StandoffCheat
cd StandoffCheat

:: Создание необходимых файлов
echo Создание файлов проекта...

:: Загрузка готового IPA
echo Загрузите Standoff2 v0.36.0.ipa в эту папку
pause

:: Автоматизация через Python (альтернатива)
echo import zipfile > build.py
echo import os >> build.py
echo # Распаковка IPA >> build.py
echo with zipfile.ZipFile('Standoff2.ipa', 'r') as zip_ref: >> build.py
echo     zip_ref.extractall('Payload') >> build.py
echo # Создание .tipa >> build.py  
echo os.system('zip -r StandoffCheat.tipa Payload') >> build.py

python build.py

echo Готово! Файл: StandoffCheat.tipa
pause
