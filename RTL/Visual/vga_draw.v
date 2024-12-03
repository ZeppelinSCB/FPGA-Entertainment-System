`include "../libs/define.vh"
`include "../libs/sprites.vh"

module	vga_draw	(	//	Read Out Side
						oRGB     ,
						iVGA_X   ,
						iVGA_Y   ,
						iVGA_CLK ,
						//	Control Signals
						reset    ,
						iColor_SW,
						ent      
                    );
//	Read Out Side
output [15:0] 	    oRGB;
input	[9:0]		iVGA_X;
input	[9:0]		iVGA_Y;
input				iVGA_CLK;
//	Control Signals
input				reset;
input				iColor_SW; // drawing mode: either game or colored lines
input	[0:1]		ent; // entity to draw

// Array of sprites
/*
0 - apple
1 - snake head
2 - snake tail

Every sprite consists of 3 bits - RGB values of a particular pixel
*/
reg [0:`SPRITE_MSB] sp [0:2][0:`H_SQUARE_LAST_ADDR][0:`V_SQUARE_LAST_ADDR];

reg[4:0] hRed;
reg[5:0] hGreen;
reg[4:0] hBlue;
reg      oRed;
reg      oGreen;
reg      oBlue;

initial
begin
	`SPRITE_INIT
end
//convert RGB into 16bit color
always @(*) begin
    case (oRed)
        1'b0:    hRed = 5'b00000;
        1'b1:    hRed = 5'b11111;
        default: hRed = 5'b00000;
        endcase
    case (oGreen)
        1'b0:    hGreen = 6'b000000;
        1'b1:    hGreen = 6'b111111;
        default: hGreen = 6'b000000;
        endcase
    case (oBlue)
        1'b0:    hBlue = 5'b00000;
        1'b1:    hBlue = 5'b11111;
        default: hBlue = 5'b00000;
        endcase
end

assign oRGB = {hRed,hGreen,hBlue};

always @(posedge iVGA_CLK or posedge reset)
begin
	if(reset) begin
		oRed   <= 0;
		oGreen <= 0;
		oBlue  <= 0;
	    end
	else begin
	    if(iColor_SW == 0) begin
	    	// DRAW CURRENT STATE
	    	if (ent == `ENT_NOTHING) begin
	    		oRed   <= 1;
	    		oGreen <= 1;
	    		oBlue  <= 1;
	    	    end
	    	else begin
	    		// Drawing a particular pixel from  sprite
	    		oRed <= sp[ent][iVGA_X % `H_SQUARE] [iVGA_Y % `V_SQUARE][0];
	    		oGreen <= sp[ent][iVGA_X %  `H_SQUARE][iVGA_Y % `V_SQUARE][1];
	    		oBlue <= sp[ent][iVGA_X % `H_SQUARE]    [iVGA_Y % `V_SQUARE][2];
	    	    end
	        end
	    else begin //Draw lines of every color that can  be produces
	    	if (iVGA_Y < 60) begin
	    		oRed <= 1;
	    		oGreen <= 1;
	    		oBlue <= 1;
	    	    end 
            else if (iVGA_Y < 120) begin
	    		oRed <= 1;
	    		oGreen <= 0;
	    		oBlue <= 1;
	    	    end  
            else if (iVGA_Y < 180) begin
	    		oRed <= 1;
	    		oGreen <= 1;
	    		oBlue <= 0;
	    	    end  
            else if (iVGA_Y < 240) begin
	    		oRed <= 1;
	    		oGreen <= 0;
	    		oBlue <= 0;
	    	    end
            else if (iVGA_Y < 300) begin
	    		oRed <= 0;
	    		oGreen <= 1;
	    		oBlue <= 1;
	    	    end
            else if (iVGA_Y < 360) begin
	    		oRed <= 0;
	    		oGreen <= 0;
	    		oBlue <= 1;
	    	    end
            else if (iVGA_Y < 420) begin
	    		oRed <= 0;
	    		oGreen <= 1;
	    		oBlue <= 0;
	    	    end  
            else begin
	    		oRed <= 0;
	    		oGreen <= 0;
	    		oBlue <= 0;
	    	    end
            end
	    end
end

endmodule
