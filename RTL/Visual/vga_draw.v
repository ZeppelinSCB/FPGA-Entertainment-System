`include "../libs/define.vh"
`include "../libs/sprites.vh"

module	vga_draw	(	//	Read Out Side
						iVGA_CLK    ,
                        ivga_x      ,
                        ivga_y      ,
						//	Control Signals
						iReset_n    ,
						iColor_SW   ,
						iSprite     ,  
                        iGame_state ,
                        //  VGA port
                        oRGB        
                    );
input  wire [9:0]   ivga_x;
input  wire [9:0]   ivga_y;
input			    iVGA_CLK;
input			    iReset_n;
input			    iColor_SW; // drawing mode: either game or colored lines
input       [2:0]   iGame_state;
input       [0:1]   iSprite; // entity to draw
output reg  [15:0]  oRGB;

reg red, green, blue;
wire [15:0] rgb_sprite;   //wire to connect to module
reg  [15:0] rgb_background;//background color
reg  [15:0] rgb_game;      //menu color
reg  [15:0] rgb_menu;      //menu color

// Array of sprites
/*
0 - apple
1 - snake head
2 - snake tail

Every sprite consists of 3 bits - RGB values of a particular pixel
*/
reg [0:2] sp [0:3][0:`H_SQUARE_LAST_ADDR][0:`V_SQUARE_LAST_ADDR];
// assign value to the sprite
initial
begin
	`SPRITE_INIT
end

always@(iVGA_CLK) begin
    if(iSprite != `ENT_NOTHING)
        rgb_game <= rgb_sprite;
    else
        //rgb_game = rgb_background;
        rgb_game <= rgb_sprite;
end
// selete the signal to output
always @(iVGA_CLK) begin
    if(iColor_SW == 1'b1)
        oRGB <= rgb_background;
    else if (iGame_state == `STATE_INGAME)
        oRGB <= rgb_game;
    else
        oRGB <= rgb_menu;
end

// Draw the iSprite
rgb_to_565 rgb_sprite_converter(
    .iR          (red),
    .iG          (green),
    .iB          (blue),
    .oRGB_565    (rgb_sprite)
);

always @(posedge iVGA_CLK or negedge iReset_n) begin
	if(!iReset_n) begin
		red   <= sp[0][ivga_x % `H_SQUARE] [ivga_y % `V_SQUARE][0];
		green <= sp[0][ivga_x % `H_SQUARE] [ivga_y % `V_SQUARE][1];
		blue  <= sp[0][ivga_x % `H_SQUARE] [ivga_y % `V_SQUARE][2];
	    end
	else if((iSprite >= 0)&& (iSprite <= (`SPRITE_MAX -1)))begin
        red   <= sp[iSprite][(ivga_x) % `H_SQUARE] [(ivga_y) % `V_SQUARE][0];
        green <= sp[iSprite][(ivga_x) % `H_SQUARE] [(ivga_y) % `V_SQUARE][1];
        blue  <= sp[iSprite][(ivga_x) % `H_SQUARE] [(ivga_y) % `V_SQUARE][2];
        end
    else begin
        red   <= sp[3][ivga_x % `H_SQUARE] [ivga_y % `V_SQUARE][0];
        green <= sp[3][ivga_x % `H_SQUARE] [ivga_y % `V_SQUARE][1];
        blue  <= sp[3][ivga_x % `H_SQUARE] [ivga_y % `V_SQUARE][2];
        end
    end

localparam
   RED     = 16'hF800,
   ORANGE  = 16'hFC00,
   YELLOW  = 16'hFFE0,
   GREEN   = 16'h07E0,
   CYAN    = 16'h07FF,
   BLUE    = 16'h001F,
   PURPPLE = 16'hF81F,
   BLACK   = 16'h0000,
   WHITE   = 16'hFFFF,
   GRAY    = 16'hD69A;

// Draw the Background
always @(posedge iVGA_CLK) begin
    if(!(iColor_SW ))
        rgb_background <= 16'hffff;
    else
    begin
	    if      (ivga_x < 60)
            rgb_background <= RED;
        else if (ivga_x < 120)
            rgb_background <= ORANGE;
        else if (ivga_x < 180)
            rgb_background <= YELLOW;
        else if (ivga_x < 240)
            rgb_background <= GREEN;
        else if (ivga_x < 300)
            rgb_background <= CYAN;
        else if (ivga_x < 360)
            rgb_background <= BLUE;
        else if (ivga_x < 420)
            rgb_background <= PURPPLE;
        else
            rgb_background <= WHITE;
        end
    end

always @(posedge iVGA_CLK) begin
    if(iGame_state == `STATE_INGAME)
        rgb_menu <= BLUE;
    else if(iGame_state == `STATE_START)
        rgb_menu <= GRAY;
    else
        rgb_menu <= RED;
    end
endmodule
