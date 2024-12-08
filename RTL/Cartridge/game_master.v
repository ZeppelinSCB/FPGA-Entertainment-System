module master_state_machine(
    input CLK,
    input RESET,
    input BTNU,
    input BTND,
    input BTNL,
    input BTNR,
    input [3:0] Current_score,
    input Game_over,
    output [1:0] Master_state
    );
    reg [1:0] Curr_State;
    reg [1:0] Next_State = 2'b00;
    
    always@(posedge CLK)
    begin
        if(RESET)   
            Curr_State <= 2'b00;
        
        else    
            Curr_State <= Next_State;
        
    end
    
    always@(posedge CLK)
    begin
        case(Curr_State)
            2'b00   :   begin
                if (BTNU) 
                    Next_State <= 2'b01;
                else 
                    Next_State <= 2'b00;
            end
            
            2'b01   :   begin
                if (Current_score == 10)      
                    Next_State <= 2'b10;
                else if(Game_over == 1)                 
                    Next_State <= 2'b11;
                else 
                    Next_State <= 2'b01;
            end
				 2'b10   :   begin
                if(Current_score < 10)                 
                    Next_State <= 2'b01;
            end
				2'b11   :   begin
                if(Game_over == 0)                 
                    Next_State <= 2'b01;
            end
				
        endcase
    end 
    
    assign  Master_state = Curr_State;
           
endmodule