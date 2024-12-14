# Controller
## Key input
The controller unit read the key input and output the direction signal. <br />
The direction is also a state machine, and it won't jump to opposide direction to avoid self collection


# Graphic Module
## VGA drawer
This module is a multiplexer to select which graphic signal to output based on current state and position on screen.
The game state determine whether to display from menu or the game.

## Tile renderer
In particular, how we render the tile
As we known, at each pixel clock, VGA controller scan to one pixel in its range.
And if the pixel in on screen, it will enquire the game logic system which entity it hit,
it could be either of the five entity on tile map.
Then, the tile renderer can calculate which pixel to read from this tile map 
 with given pixel coordinate and the entity tile to display.

Note
To save storage space, we use three bit color on the tile map. 

## Display driver
The output pixel will be connect to display driver and convert to display signal to put on screen

  
# Game logic
## Game FSM
The game achieve it's ability to switch menu using this state machine.
It start at start menu, press a key enter the game, and if the game says game over, the game over.
Press the key again, the game start again.

## Sprite
Back to the Game,
Every Thing we see on screen is called a sprite, it store its coordinate,
so Graphic system will know where to display them.
And to make the game work, is to make the sprite move, So next I'll talk about how we move them.   

## Move head
At each snake update clock, 
the head will shift one block toward the direction controller indicated.

## Shift tail
At each snake update clock, 
every tile will move to where it's previous tile was at last clock
and the first tail will move to the position of head at last clock,
The continue shift of the tail makes the snakes looks like its moving.

## Eat Apple
At each snake update clock,
apple will detect if it have same coordinate as the head.
If so, it will jump to a random location, and add the snake counter by one.

## Detect Collection
After the snake is moved, game logic will check if the head have same coordinate as either a tail or the wall. If it does, it will raise the game over flag to the game FSM to indicate a end of game.