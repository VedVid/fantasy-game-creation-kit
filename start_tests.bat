@echo off
cd fantasy_console
lua5.1.exe api_test.lua -v -o TAP
lua5.1.exe canvas_test.lua -v -o TAP
lua5.1.exe palette_test.lua -v -o TAP
lua5.1.exe sprite_test.lua -v -o TAP
lua5.1.exe sprite_editor_test.lua -v -o TAP
lua5.1.exe utils_test.lua -v -o TAP
cd ..