`timescale 1ns / 1ps

module double_dabble_testbench();

logic clk,reset,start,add3_0_peek;
logic [3:0] BCD4,BCD3,BCD2,BCD1,BCD0;
logic [15:0] binary;
logic [35:0] scratch_peek;

double_dabble_16bit dut(.clk(clk),.reset(reset),.start(start),.binary(binary),.BCD4(BCD4),.BCD3(BCD3),.BCD2(BCD2),.BCD1(BCD1),.BCD0(BCD0),.scratch_peek(scratch_peek),.add3_0_peek(add3_0_peek));

always #1 clk = ~clk;
initial begin
    clk=1;
    reset=1;
    binary = 16'd12573;
    start = 1;
    #3 reset= 0;
    #2 start = 0;
    end

endmodule
