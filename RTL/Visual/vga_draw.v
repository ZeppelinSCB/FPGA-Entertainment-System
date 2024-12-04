`include "../libs/define.vh"
`include "../libs/sprites.vh"

module	vga_draw	(	//	Read Out Side
						iVGA_CLK    ,
                        ovga_x       ,
                        ovga_y       ,
						//	Control Signals
						sys_reset_n ,
						iColor_SW   ,
						ent         ,  
                        //  VGA port
                        vga_rgb     ,
                        vga_hsync   ,
                        vga_vsync   ,
                        vga_valid
                    );
//	Read Out Side
output  wire [9:0]		ovga_x;
output  wire [9:0]		ovga_y;
input				iVGA_CLK;
//	Control Signals
input				sys_reset_n;
input				iColor_SW; // drawing mode: either game or colored lines
input	[0:1]		ent; // entity to draw
output  wire [15:0]      vga_rgb;
output  wire             vga_hsync;
output  wire             vga_vsync;
output  wire             vga_valid;

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
wire[15:0] oRGB;

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


always @(posedge iVGA_CLK or negedge sys_reset_n)
begin
	if(!sys_reset_n) begin
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
	    		oRed   <= sp[ent][ovga_x % `H_SQUARE] [ovga_y % `V_SQUARE][0];
	    		oGreen <= sp[ent][ovga_x % `H_SQUARE] [ovga_y % `V_SQUARE][1];
	    		oBlue  <= sp[ent][ovga_x % `H_SQUARE] [ovga_y % `V_SQUARE][2];
	    	    end
	        end
	    else begin //Draw lines of every color that can  be produces
	    	if (ovga_x < 60) begin
	    		oRed <= 1;
	    		oGreen <= 1;
	    		oBlue <= 1;
	    	    end 
            else if (ovga_x < 120) begin
	    		oRed <= 1;
	    		oGreen <= 0;
	    		oBlue <= 1;
	    	    end  
            else if (ovga_x < 180) begin
	    		oRed <= 1;
	    		oGreen <= 1;
	    		oBlue <= 0;
	    	    end  
            else if (ovga_x < 240) begin
	    		oRed <= 1;
	    		oGreen <= 0;
	    		oBlue <= 0;
	    	    end
            else if (ovga_x < 300) begin
	    		oRed <= 0;
	    		oGreen <= 1;
	    		oBlue <= 1;
	    	    end
            else if (ovga_x < 360) begin
	    		oRed <= 0;
	    		oGreen <= 0;
	    		oBlue <= 1;
	    	    end
            else if (ovga_x < 420) begin
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

vga_ctrl vga_ctrl_inst(
    .vga_clk     (iVGA_CLK),
    .sys_rst_n   (sys_reset_n),
    .pix_data    (oRGB),
    .pix_x       (ovga_x),
    .pix_y       (ovga_y),
    .hsync       (vga_hsync),
    .vsync       (vga_vsync),
    .rgb         (vga_rgb),
    .rgb_valid   (vga_valid)
);

endmodule
