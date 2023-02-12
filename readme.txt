================================================================================
================================================================================

  Fish Tank Simulator - GameBoy - v2.0
  (c) Paul Alan Freshney 1998-2023

  paul@freshney.org

  Source code and ROM
    https://github.com/MaximumOctopus/

  Assembled using rgbds
    https://github.com/gbdev/rgbds
  
  Tested/debugged with BGB
    https://bgb.bircd.org/
	
  Graphics and Screens created with GBTD/GBMB
    https://github.com/gbdk-2020/GBTD_GBMB
  
================================================================================
================================================================================

Started as a fun project in the late 90's, resurrected a few times since then
(adding new features), and tweaked in early 2023.

==================================================================================
==================================================================================

The greatest Fish Tank Simulator ever created for the GameBoy (probably!).

There are lots more things to add so please email me with suggestions and
feedback.

To "play" this great GameBoy ROM you'll need a gameboy emulator, I use BGB.

Keys:

  Main Screen  :

     START     : Show menu / select current menu item
     UP/DOWN   : Cycle through menu options

  Simulator    :

     START     : Exit to Main Screen
     SELECT    : Pause the simulator
               : Select a new special from the menu
     A         : Toggle settings menu when
     B         : Activate "special" background item
     UP/DOWN   : Cycle through menu options
     LEFT/RIGHT: Select from selected menu


  Instructions/Credits

     START     : Exit to Main Screen
     UP/DOWN   : Scroll the instructions

  Designer     :

     START     : Show menu (use >Back to close menu)
               : Select current menu option  
     SELECT    : Change tile palette
     A         : Paint the "on" tile
               : Select the "on" tile from the palette
     B         : Paint the "off" tile
               : Select the "off" tile from the palette
     UP/DOWN   : Move the mouse cursor
               : Cycle through menu options
     LEFT/RIGHT: Move the mouse cursor
                 Cycle through "Select" menu option

==================================================================================
==================================================================================
  Features
==================================================================================
==================================================================================

 - 16 fish
 - Several backdrops
 - Crab, octopus, snail, jellyfish!
 - Special background features (soon, only chest working at the moment)
 - Background designer

Use the menu in game (press A) to alter the number of fish, change the background,
change the fish type and activate one of the special creatures. These creatures
(snail, crab and octopus) will appear randomly, but use this menu if you get too
impatient!

==================================================================================
==================================================================================
  Some techie stuff
==================================================================================
==================================================================================

Written in 100% assembler (6945 lines of code), using Notepad++, RGBASM, No$GMB and BGB.

All the tiles and backgrounds are compressed using a custom compression system,
it's simple but works well with the data I have. The decompressor is fast and only
takes up 27 bytes!!

The backgrounds are compressed by a factor of around 15:1, the tiles 2:1.

The FTS now makes uses of banks. There are six banks in total:
	
  #0 : Important routines and data
  #1 : Opening menu screen
  #2 : Fish tank simulator code, backgrounds and tile data
  #3 : Instructions code, background and tile data
  #4 : Background designer code and tile data
  #5 : Credits, code and tiles

I have made a few reasonable performance increases by using HRAM for extra speed in
important and widely-used variables.

================================================================================

 Credits

   All coding            : Paul A Freshney
   Fonts and backgrounds : Paul A Freshney
   Animals/chest/anchor  : Steve Turner
   Development Cats      : Rutherford, Freeman, and Maxwell
					  
   Dedicated to Julie, Adam, and Dyanne.

All of my software is free and open source; please consider donating to a local cat charity or shelter.

Thanks.

================================================================================

Release History

2.0 / February 12th 2023

Release fixes issues caused by incorrect VRAM writes. It would run fine in an 
emulator, but not when "emulate as in reality" is enabled.

It should now run perfectly on an emulator and real hardware.

Jan 26th 2013

Added a credits page! A few optimisations to code and data usage.

Jan 21st 2013

Some general code optimisations. Each part (designer, sim, instructions) now has
their own tile data (rather than sharing). Lots of updates to the designer.

Jan 6th 2013

User interface now a bit more user-friendly, simple menus rather than complicated
sets of key commands to remember.

Added a designer mode! Draw your own background for the fishies!

A few minor optimisations.

Nov 28th 2012

Updates to this version include a much nicer background transition routine and the 
use of the hardware Window, placed at the bottom of the screen.

================================================================================