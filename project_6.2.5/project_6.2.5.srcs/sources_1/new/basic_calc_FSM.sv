`timescale 1ns / 1ps

module basic_calc_FSM #(parameter n = 16)(
    input logic clk,reset,next,
    input logic [n-1:0] bits,
    output logic show,
    output logic [1:0] FSM_state,
    output logic [n-1:0] result
    );
    
    logic enA,enB,enO; // register enables controlled by FSM state
    logic [n-1:0] A,B; // ALU input registers
    logic [3:0] opco,opcode; // ALU opcode
    assign opco = {~bits[1]&~bits[0],~bits[1]&bits[0],bits[1]&~bits[0],bits[1]&bits[0]}; // 2 bits to one hot opcode conversion
    ALU #(n) alu(.A(A),.B(B),.opcode(opcode),.result(result),.status());
    reg_bank #(n) regA(.clk(clk),.reset(reset),.bits(bits),.enable(enA),.registry(A));
    reg_bank #(n) regB(.clk(clk),.reset(reset),.bits(bits),.enable(enB),.registry(B));
    reg_bank #(4) regO(.clk(clk),.reset(reset),.bits(opco),.enable(enO),.registry(opcode));
   

    typedef enum logic [1:0] {Wait_OP1,Wait_OP2,Wait_operation,Show_result} statetype;
    statetype state, next_state;
    
    // FSM state register
    always_ff @(posedge clk)
        if (reset) state <= Wait_OP1;
        else state <= next_state;
    // next state logic
    always_comb begin
        next_state = Wait_OP1; //default state
        case (state)
            Wait_OP1:       if (next) next_state = Wait_OP2;
                            else next_state = Wait_OP1;
                            
            Wait_OP2:       if (next) next_state = Wait_operation;
                            else next_state = Wait_OP2;
                            
            Wait_operation: if (next) next_state = Show_result;
                            else next_state = Wait_operation;
                            
            Show_result:    if (next) next_state = Wait_OP1;
                            else next_state = Show_result;
        endcase end
    // output logic 
    always_comb begin
        {enA,enB,enO,show} = 4'd0;   // all signals are low by default, only one is high depending on state
        FSM_state = state;           // indicates to the external world the current state of FSM
        case (state)
            Wait_OP1:       enA = 1; // only input A is allowed to be set during WAIT_OP1
                            
            Wait_OP2:       enB = 1; // only input B is allowed to be set during WAIT_OP2
                            
            Wait_operation: enO = 1; // only opcode is allowed to be set during WAIT_Ooperation
                            
            Show_result:    show =1; // indicates to the external world the result can be shown
        endcase end 
        
endmodule
