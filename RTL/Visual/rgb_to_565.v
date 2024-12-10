module rgb_to_565(
    iR          ,
    iG          ,
    iB          ,
    oRGB_565    
);
parameter   GRAY    = 16'hD69A;
input  wire iR;
input  wire iG;
input  wire iB;
wire [15:0] RGB_565;
output wire [15:0] oRGB_565;

reg [4:0] hRed;
reg [5:0] hGreen;
reg [4:0] hBlue;


always @(*) begin
    case (iR)
        1'b0:    hRed = 5'b00000;
        1'b1:    hRed = 5'b11111;
        default: hRed = 5'b00000;
        endcase
    case (iG)
        1'b0:    hGreen = 6'b000000;
        1'b1:    hGreen = 6'b111111;
        default: hGreen = 6'b000000;
        endcase
    case (iB)
        1'b0:    hBlue = 5'b00000;
        1'b1:    hBlue = 5'b11111;
        default: hBlue = 5'b00000;
        endcase
end

assign RGB_565 = {hRed,hGreen,hBlue};
assign oRGB_565 = (RGB_565 == 16'hffff) ? GRAY : RGB_565;

endmodule