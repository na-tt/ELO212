`timescale 1ns / 1ps

module basic_calc #(parameter n =16)(
    input logic clk,reset,next,
    input logic [n-1:0] bits,
    output logic [n-1:0] result,
    output logic [1:0] FSM_state,
    output logic show
    );
    
    logic enA,enB,enO;
    logic [n-1:0] A,B;
    logic [1:0] opco;
    
    calc_control_FSM #(n) FSM(.clk(clk),.reset(reset),.next(next),.show(show),.enA(enA),.enB(enB),.enO(enO),.FSM_state(FSM_state));
    
    reg_bank #(n) regA(.clk(clk),.enable(enA),.reset(reset),.bits(bits),.registry(A));
    reg_bank #(n) regB(.clk(clk),.enable(enB),.reset(reset),.bits(bits),.registry(B));
    reg_bank #(2) regO(.clk(clk),.enable(enO),.reset(reset),.bits(bits[1:0]),.registry(opco));
    
    logic [3:0] opcode;
    assign opcode = {~opco[1]&~opco[0],~opco[1]&opco[0],opco[1]&~opco[0],opco[1]&opco[0]}; // 2 bits switches a 4 bits one hot
    
    ALU #(n) alu(.A(A),.B(B),.opcode(opcode),.result(result),.status());
    
    
    
endmodule
