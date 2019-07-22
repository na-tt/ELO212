`timescale 1ns / 1ps

module reg_bank #(
    parameter n = 8
    )
    (
        input logic clk,enable,reset,
        input logic [n-1:0] bits,
        output logic [n-1:0] registry = 0
    );
    
    always_ff @(posedge clk) begin
        if (reset)
            registry <= 0;
        else if (enable)
            registry <= bits;
        end    
endmodule
