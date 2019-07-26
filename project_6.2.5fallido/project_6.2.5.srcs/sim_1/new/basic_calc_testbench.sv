`timescale 1ns / 1ps

module basic_calc_testbench();
logic clk,reset,next,show;
logic [1:0] FSM_state;
logic [15:0] bits,result;

basic_calc #(16) dut(.clk(clk),.reset(reset),.next(next),.bits(bits),.show(show),.FSM_state(FSM_state),.result(result));

always #5 clk = ~clk;
always #15 next = ~next;

initial begin 
    clk = 0;
    reset = 1;
    next = 0;
    bits = 16'd123;
    #10 reset = 0;
    end
    



endmodule
