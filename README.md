# FPGA Entertainment System - Snake
## Demo Video


https://github.com/user-attachments/assets/5d3310fa-f0f1-459c-8c2a-37ef650b40ce


## Introduction
The FES-Snake project aims to create a Snake Game on Cyclone IV FPGA Chips. 

We had finished the implementation of some basic features. Currently, the game has the following features working:

+ IO
  + VGA and HDMI video output
  + On board key input
+ In Game Experience
  + Start/End Menu (Color only)
  + Miku Increase Length
  + Miku die from hitting wall or itself
  + Miku die from hitting Teto (wall)
+ Graphic
  + 16*16 tiles
  + 3 bit color image

## Block Design
You may found a more detailed explanation of the function for each block at [here](/RTL/block_design.md)
+ Console System [TODO]
  + Console State Machine
+ Cartridge System
  + Menu Switch
  + Game Logic
+ Graphic System
  + Graphic Render
    + Tile Renderer
    + Text Renderer (WIP)
    + Background Renderer [TODO]
  + VGA driver
  + HDMI driver
+ Control System
  + On board Key Drive
  + Keyboard Input [TODO]
+ Audio System [TODO]
  + Audio ROMs
  + Midi ROM
  + Midi Player
  + driver


## Reference
+ [GBA Archetecture](https://www.copetti.org/writings/consoles/game-boy-advance/) : Due to the limit in performance and internal storage, we reference the structure of early Nintendo Console 
+ [NES Develop Guide](https://www.nesdev.org/NES%20emulator%20development%20guide.txt) : Similarly, we reference this NES developer guide for how to render a frame and put it on the display
+ [Snake Game FPGA](https://github.com/tymur-l/SnakeGame_FPGA) : We used the same implementation for the game and pixel renderer as his.
+ [16*16 Sprites](https://www.deviantart.com/nanouw/journal/Commissions-and-stuff-CLOSED-958600593) : Where the Miku and Snow Miku Sprite is from.