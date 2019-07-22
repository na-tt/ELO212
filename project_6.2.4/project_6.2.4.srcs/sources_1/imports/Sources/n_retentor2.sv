`timescale 1ns / 1ps

module n_retentor2 #( parameter n=8)(

    input logic [n-1:0] bits,
    input logic clk,enable1,enable2,reset,
    output logic [n-1:0] registry1,registry2
    );
    
    reg_bank #(n) bank1(.clk(clk),.enable(enable1),.reset(reset),.bits(bits),.registry(registry1));
    reg_bank #(n) bank2(.clk(clk),.enable(enable2),.reset(reset),.bits(bits),.registry(registry2));
    
    
endmodule
