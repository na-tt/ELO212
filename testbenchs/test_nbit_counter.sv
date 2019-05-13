`timescale 1ns / 1ps

module test_nbit_counter();

    logic   clk,reset;
    logic [2:0] count;
    
    nbit_counter DUT(.clk(clk), .reset(reset), .count(count));
    
    always #5 clk = ~clk; //generacion señal de reloj
    
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
    end
    
endmodule
