This project is a work-in-progress game creation kit. Heavily inspired by fantasy consoles like PICO-8 and TIC-80. This project aims to provide all the tools usually found in fantasy consoles, such as sprite editor, map editor, sound editor, and simple, rather high level API.

Under the hood, it's wrapper around Love2D.

Goals:
- provide all the basic tools to create simple games
- create API that will feel familiar to people who know PICO-8
- make sure that the kit is extensible (e.g. can be used with third-party libraries)
- keep the magic of fantasy consoles by providing arbitrary limitations

Non-goals:
- become PICO-8 compatible,
- implement full-fledged fantasy console (ergo, no hardware specs, no VM emulation, etc.),
- implement severe limitations that would force small scale of games.

Prerequisites:  
Love2D.

How to start:
- use the `_cart.lua` to program your app,
- start the app, either by:
	- drag-and-drop `fantasy_console` directory on you Love2D installation, or
	- by executing `start.bat` file (this assument that `fantasy_console` and `love` directory are in the same root directory).


