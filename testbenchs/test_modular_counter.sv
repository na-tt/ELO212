`timescale 1ns / 1ps

module test_modular_counter#(parameter mod=13)();

    logic   clk,reset;
    logic [$clog2(mod)-1:0] count;
    
    modular_counter DUT(.clk(clk), .reset(reset), .count(count));
    
    always #5 clk = ~clk; //generacion señal de reloj
    
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
    end
endmodule

