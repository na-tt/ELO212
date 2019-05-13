`timescale 1ns / 1ps

module top_divider(

    input CLK100MHZ,
    output P1,P2,P3

    );
    
    logic reset = 1'b0;
    
    clock_divider #(5000000) f10hz(
    .clk_in(CLK100MHZ),.reset(reset),.clk_out(P1));
    
    clock_divider #(1666667) f30hz(
    .clk_in(CLK100MHZ),.reset(reset),.clk_out(P2));
    
    clock_divider #(100000) f500hz(
    .clk_in(CLK100MHZ),.reset(reset),.clk_out(P3));
    
    
endmodule
