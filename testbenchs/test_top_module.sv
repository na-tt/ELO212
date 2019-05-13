`timescale 1ns / 1ps

module test_top_module();

    logic   clk, reset, fib, onoff;
    logic [6:0] sevenSeg;
        
    top_module DUT(.clk(clk), .reset(reset), .fib(fib)
    , .onoff(onoff), .sevenSeg(sevenSeg));
    
    always #5 clk = ~clk; //generacion señal de reloj
    
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
    end
    
endmodule

