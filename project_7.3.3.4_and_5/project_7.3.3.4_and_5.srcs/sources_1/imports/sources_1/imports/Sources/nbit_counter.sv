`timescale 1ns / 1ps

module nbit_counter#(
    parameter n = 3     //counter number of bits 
    )

(
    input logic clk,reset,
    output logic [n-1:0] count = 0

    );
    
    always_ff @(posedge clk) begin
        if (reset)
            count <= 0;
        else
            count <= count+1;
        end
        
endmodule
