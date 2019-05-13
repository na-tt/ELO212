`timescale 1ns / 1ps

module ALU(

    input logic [7:0] A,B,
    input logic [3:0] opcode, // UP,DOWN,RIGHT,LEFT
    output logic [7:0] result,
    output logic status 
    
    );
    
    always_comb begin
        
        if(opcode == 4'b1000) begin //UP
            result = A + B ;
            status = 1;
        end
            
        else if(opcode == 4'b0100) begin //DOWN
            result = A - B ;
            status = 1;
        end   
        
        else if(opcode == 4'b0010) begin //RIGHT
            result = A|B; // bitwise OR
            status = 1;
        end
        
        else if(opcode == 4'b0001) begin //Left
            result = A&B;    //bitwise AND
            status = 1;
        end  
        else begin
            result = 0;
            status = 0;
        end
    end       
endmodule
