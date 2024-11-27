# FPGA Entertainment System
## Introduction
This project aim to create a Snake Game on Cyclone IV FPGA Chips. The game should have following feature:
+ User Interface
  + Main Menu
+ In Game Experience
  + Score Display
+ Visual
  + 8 bit color image

## Block Design
+ Console System
  + Console State Machine
+ Cartridge System
  + Menu
  + In game
      + Sprit
      + Level
      + UI
+ Visual System
  + Tile ROMs
    + tiles
    + color map
  + Graphic Render
    + From tile to form
    + Mutiplex layers
  + Graphic Flip RAM
    + screen for edit
    + screen for display
  + VGA driver
    + read and scale from RAM to VGA
+ Control System
  + On board Key Drive
  + Serial Drive
  + BT Drive (Optional)
+ Audio System (Optional)
  + Audio ROMs
  + Midi ROM
  + Midi Player
  + driver

## Dev Work Flow
    For developer
## Reference
[GBA Archetecture](https://www.copetti.org/writings/consoles/game-boy-advance/) : Due to the limit in performance and internal storage, we reference the structure of early Nintendo Console 
[NES Develop Guide](https://www.nesdev.org/NES%20emulator%20development%20guide.txt) : Similarly, we reference this NES developer guide for how to render a frame and put it on the display