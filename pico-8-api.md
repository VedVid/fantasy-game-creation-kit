Game loop:
* [x] init
* [x] update
* [x] draw
Will not implement:
- flip

Graphics:
- [] camera
* [x] circ
* [x] circfill
* [x] oval
* [x] ovalfill
* [x] cls
* [x] line
* [x] print
* [x] pset
* [x] rect
* [x] rectfill
* [ ] spr
* [ ] sspr
Not sure if it will be implemented:
- clip
- color
- fget
- fillp
- fset
- pget
- sget
- sset
- tline
Will not implement:
- cursor
- pal
- palt

Tables:
- [] add
- [] all
- [] count
- [] del
- [] deli
- [] foreach
- [] next
Not sure if ti will be implemented (e.g. because it's natively supported by Lua):
- ipairs
- pack
- pairs
- unpack

Input:
- [] btn
- [] btnp

Sound:
- not sure about that yet, I'd need to implement sound and have a concept for sound editor first

Map:
- not sure about that yet

Memory:
- direct memory editing will not be supported

Math:
- [] abs
- [] atan2
- [] ceil
- [] cos
- [] flr
- [] max
- [] mid
- [] min
- [] rnd
- [] sgn
- [] sin
- [] sqrt
- [] srand
Will not implement:
- band
- bnot
- bor
- bxor
- lshr
- rotl
- rotr
- shl
- shr

Cartridge data:
- depends on the cartridge layout; will be decided in the future if functions for cartridge data manipulation are necessary

Coroutines:
- will not be implemented

Strings:
* [x] split
* [x] sub
- [] chr
- [] ord
- [] tonum
- [] tostr

Values and objects:
- implementation depends if the PICO-8 API does not double Lua functions there

Time:
- [] time

System:
- will not be implemented

Debugging:
- [] assert
- [] printh
Not sure if it will be implemented:
- stat (at least not fully)



Goals:
- create API inspired by PICO-8, but perhaps a bit higher level
- create API that will allow to create simple games easily

Non-goals:
- being PICO-8 compatible
- creating fantasy console sensu stricto (with emulating specific hardware)

Challanges:
- designing API that is inspired on surface by PICO-8 but without limiting access to Lua idioms and standard library (and Love2d if someone wants) is challanging because it's prone to inconsistiences and redundancy; therefore, it would be necessary to:
	- implement basic API based on PICO-8 API
	- remove redundancy between API and Lua
	- fill the gaps



