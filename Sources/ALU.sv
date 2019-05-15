`timescale 1ns / 1ps

module ALU #(
    parameter n = 8
    )

   ( input logic [n-1:0] A,B,
    input logic [3:0] opcode, // UP,DOWN,RIGHT,LEFT
    output logic [n-1:0] result,
    output logic [3:0]status 
    
    );
    
    always_comb begin
        
        if(opcode == 4'b1000) begin //UP
            result = A + B ;
            status = 4'b1000;
        end
            
        else if(opcode == 4'b0100) begin //DOWN
            result = A - B ;
            status = 4'b0100;
        end   
        
        else if(opcode == 4'b0010) begin //RIGHT
            result = A|B; // bitwise OR
            status = 4'b0010;
        end
        
        else if(opcode == 4'b0001) begin //Left
            result = A&B;    //bitwise AND
            status = 4'b0001;
        end  
        else begin
            result = 8'd0;
            status = 4'd0;
        end
    end       
endmodule
