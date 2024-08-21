@echo off
set filenamestart="testreport"
set filenameend=".txt"
set "filenametotal=%filenamestart% %date% %time% %filenameend%"
cd fantasy_console
lua5.1.exe api_test.lua -v -o TAP
lua5.1.exe canvas_test.lua -v -o TAP
lua5.1.exe gamepixel_test.lua -v -o TAP
lua5.1.exe palette_test.lua -v -o TAP
lua5.1.exe sprite_test.lua -v -o TAP
lua5.1.exe utils_test.lua -v -o TAP
cd ..