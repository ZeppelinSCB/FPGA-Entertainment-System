# Controller
## Key input
+ The controller unit read the key input and output the direction signal. <br />
+ The direction is store in a state machine, and it won't jump to opposide direction to avoid self collection


# Graphic Module
Next, how we display such fancy graphic.

## Tile renderer
In particular, how we render the tile.<br />

As we known, at each pixel clock, VGA controller scan to one pixel in its range.<br />

And if the pixel in on screen, it will enquire the game logic system which entity it hit,<br />

it could be either of the five entity on tile map.<br />

Then, the tile renderer can calculate which pixel to read from this tile map 
with given pixel coordinate and the entity tile to display.<br />
  
# Game logic
## Game FSM
The game decide which page to display using this state machine.<br />

1. It start at start menu, <br />

2. press a key, jump to the In Game state, <br />

3. and if the snake hit the itself or the wall, the game over.

4. Press the key again, the game start again.

## Sprite
Back to the Game,<br />

+ Every Thing we see on screen is called a sprite, <br />

+ it store its coordinate,<br />
for Graphic system will know where to display them.

+ And to make the game work, is to make the sprite move.

So next I'll talk about how we move them.   

## Move head
+ At each snake update clock, <br />
    the head will shift one block toward the direction controller indicated.

## Shift tail
+ At each snake update clock, 
    1. every tile will move to where it's previous tile was at last clock
    2. first tail will move to the position of head at last clock,
+ The continue shift of the tail makes the snakes looks like its moving.

## Eat Apple
+ At each snake update clock,
+ apple will detect if it have same coordinate as the head.
+ If so, it will jump to a random location, and add the snake counter by one.

## Detect Collection
+ At each game update clock
+ Check if the head have same coordinate as either a tail or the wall. 
+ If it does, it will raise the game over flag to the game FSM to indicate a end of game.