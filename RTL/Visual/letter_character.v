module letter_character
(
    letter_i        ,
    letter_x        ,
    letter_y        ,
    letter_o        
);

input wire  [4:0]   letter_i     ;//letter input
input wire  [3:0]   letter_x     ;//x coordinate of pixel with respect to letter
input wire  [3:0]   letter_y     ;//y coordinate of pixel with respect to letter

output reg  [0:0]   letter_o     ;//letter output

reg                 scan_x       ;

wire        [431:0] letter [15:0];

//27th is the Space of 16 pixels if needed
assign          letter[ 0] = {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000,8'b00000000,8'b00000000};
assign          letter[ 1] = {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000,8'b00000000,8'b00000000};
assign          letter[ 2] = {8'b00011111, 8'b11100000, 8'b11111111, 8'b11111000, 8'b00011111, 8'b11111000, 8'b11111111, 8'b11100000, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11111110, 8'b00011111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b00011111, 8'b11111000, 8'b00000111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b01111110, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b01111111, 8'b11111000, 8'b11111111, 8'b11111000, 8'b01111111, 8'b11111000, 8'b11111111, 8'b11111000, 8'b01111111, 8'b11100000, 8'b01111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b01111110, 8'b01111110, 8'b11111111, 8'b11111110,8'b00000000,8'b00000000};
assign          letter[ 3] = {8'b00011111, 8'b11100000, 8'b11111111, 8'b11111000, 8'b00011111, 8'b11111000, 8'b11111111, 8'b11100000, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11111110, 8'b00011111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b00011111, 8'b11111000, 8'b00000111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b01111110, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b01111111, 8'b11111000, 8'b11111111, 8'b11111000, 8'b01111111, 8'b11111000, 8'b11111111, 8'b11111000, 8'b01111111, 8'b11100000, 8'b01111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b01111110, 8'b01111110, 8'b11111111, 8'b11111110,8'b00000000,8'b00000000};
assign          letter[ 4] = {8'b01111111, 8'b11111000, 8'b11111000, 8'b01111110, 8'b01111110, 8'b01111110, 8'b11111001, 8'b11111000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b00000000, 8'b01111110, 8'b00000000, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b00000000, 8'b01111110, 8'b11111001, 8'b11111000, 8'b01111110, 8'b00000000, 8'b11111011, 8'b01111110, 8'b11111110, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111001, 8'b11111000, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11111110, 8'b01111110, 8'b01111110, 8'b00000001, 8'b11111110,8'b00000000,8'b00000000};
assign          letter[ 5] = {8'b01111111, 8'b11111000, 8'b11111000, 8'b01111110, 8'b01111110, 8'b01111110, 8'b11111001, 8'b11111000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b00000000, 8'b01111110, 8'b00000000, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b00000000, 8'b01111110, 8'b11111001, 8'b11111000, 8'b01111110, 8'b00000000, 8'b11111111, 8'b11111110, 8'b11111110, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111001, 8'b11111000, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11111110, 8'b01111110, 8'b01111110, 8'b00000001, 8'b11111110,8'b00000000,8'b00000000};
assign          letter[ 6] = {8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b00000000, 8'b01111110, 8'b11111111, 8'b11100000, 8'b01111110, 8'b00000000, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111011, 8'b01111110, 8'b01111111, 8'b11111000, 8'b01111110, 8'b01111110, 8'b00000111, 8'b11111000,8'b00000000,8'b00000000};
assign          letter[ 7] = {8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b00000000, 8'b01111110, 8'b11111111, 8'b11100000, 8'b01111110, 8'b00000000, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11111110, 8'b01111111, 8'b11111000, 8'b01111110, 8'b01111110, 8'b00000111, 8'b11111000,8'b00000000,8'b00000000};
assign          letter[ 8] = {8'b11111000, 8'b01111110, 8'b11111111, 8'b11111000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11111000, 8'b11111111, 8'b11111000, 8'b11111001, 8'b11111110, 8'b11111111, 8'b11111110, 8'b00000111, 8'b11100000, 8'b00000000, 8'b01111110, 8'b11111111, 8'b10000000, 8'b01111110, 8'b00000000, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11111000, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11111000, 8'b01111111, 8'b11111000, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11111110, 8'b00011111, 8'b11100000, 8'b00011111, 8'b11111000, 8'b00011111, 8'b11100000,8'b00000000,8'b00000000};
assign          letter[ 9] = {8'b11111000, 8'b01111110, 8'b11111111, 8'b11111000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11111000, 8'b11111111, 8'b11111000, 8'b11111001, 8'b11111110, 8'b11111111, 8'b11111110, 8'b00000111, 8'b11100000, 8'b00000000, 8'b01111110, 8'b11111111, 8'b10000000, 8'b01111110, 8'b00000000, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11111000, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11111000, 8'b01111111, 8'b11111000, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11111110, 8'b00011111, 8'b11100000, 8'b00011111, 8'b11111000, 8'b00011111, 8'b11100000,8'b00000000,8'b00000000};
assign          letter[10] = {8'b11111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11100000, 8'b01111110, 8'b00000000, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11100000, 8'b00000000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b01111111, 8'b11111000, 8'b11111111, 8'b11111110, 8'b01111111, 8'b11111000, 8'b00000111, 8'b11100000, 8'b01111111, 8'b10000000,8'b00000000,8'b00000000};
assign          letter[11] = {8'b11111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b11111111, 8'b11100000, 8'b01111110, 8'b00000000, 8'b11111100, 8'b11111110, 8'b11111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11100000, 8'b00000000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b01111111, 8'b11111000, 8'b11111111, 8'b11111110, 8'b01111111, 8'b11111000, 8'b00000111, 8'b11100000, 8'b01111111, 8'b10000000,8'b00000000,8'b00000000};
assign          letter[12] = {8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b01111110, 8'b01111110, 8'b11111001, 8'b11111000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b00000000, 8'b01111110, 8'b01111110, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b11111001, 8'b11111000, 8'b01111110, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111001, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111001, 8'b11111000, 8'b11111001, 8'b11111000, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b00011111, 8'b11100000, 8'b11111111, 8'b11111110, 8'b11111111, 8'b11111110, 8'b00000111, 8'b11100000, 8'b11111110, 8'b00000000,8'b00000000,8'b00000000};
assign          letter[13] = {8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b01111110, 8'b01111110, 8'b11111001, 8'b11111000, 8'b11111000, 8'b00000000, 8'b11111000, 8'b00000000, 8'b01111110, 8'b01111110, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b11111001, 8'b11111000, 8'b01111110, 8'b00000000, 8'b11111000, 8'b01111110, 8'b11111001, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b00000000, 8'b11111001, 8'b11111000, 8'b11111001, 8'b11111000, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b11111000, 8'b01111110, 8'b00011111, 8'b11100000, 8'b11111100, 8'b11111110, 8'b11111111, 8'b11111110, 8'b00000111, 8'b11100000, 8'b11111110, 8'b00000000,8'b00000000,8'b00000000};
assign          letter[14] = {8'b11111000, 8'b01111110, 8'b11111111, 8'b11111000, 8'b00011111, 8'b11111000, 8'b11111111, 8'b11100000, 8'b11111111, 8'b11111110, 8'b11111000, 8'b00000000, 8'b00011111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b00011111, 8'b11111000, 8'b01111111, 8'b11111000, 8'b11111000, 8'b01111110, 8'b01111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b01111111, 8'b11111000, 8'b11111000, 8'b00000000, 8'b01111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b01111111, 8'b11111000, 8'b00000111, 8'b11100000, 8'b01111111, 8'b11111000, 8'b00000111, 8'b10000000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b11111111, 8'b11111110,8'b00000000,8'b00000000};
assign          letter[15] = {8'b11111000, 8'b01111110, 8'b11111111, 8'b11111000, 8'b00011111, 8'b11111000, 8'b11111111, 8'b11100000, 8'b11111111, 8'b11111110, 8'b11111000, 8'b00000000, 8'b00011111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b00011111, 8'b11111000, 8'b01111111, 8'b11111000, 8'b11111000, 8'b01111110, 8'b01111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b01111111, 8'b11111000, 8'b11111000, 8'b00000000, 8'b01111111, 8'b11111110, 8'b11111000, 8'b01111110, 8'b01111111, 8'b11111000, 8'b00000111, 8'b11100000, 8'b01111111, 8'b11111000, 8'b00000111, 8'b10000000, 8'b11111000, 8'b01111110, 8'b11111000, 8'b01111110, 8'b00000111, 8'b11100000, 8'b11111111, 8'b11111110,8'b00000000,8'b00000000};


always@(*)
begin
    scan_x = letter_x + letter_i*16;//each character has original width of 16 pixels
    letter_o = letter[letter_y][scan_x];
end

endmodule  