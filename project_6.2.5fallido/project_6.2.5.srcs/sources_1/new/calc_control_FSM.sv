`timescale 1ns / 1ps

module calc_control_FSM #(parameter n = 16)(
    input logic clk,reset,next,
    output logic show,enA,enB,enO,
    output logic [1:0] FSM_state
    );
    typedef enum logic [1:0] {Wait_OP1,Wait_OP2,Wait_operation,Show_result} statetype;
    statetype state, next_state;
    
    // FSM state register
    always_ff @(posedge clk)
        if (reset) state <= Wait_OP1;
        else state <= next_state;
    // next state logic
    always_comb begin
        next_state = Wait_OP1; //default
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
        show = 0;
        {enA,enB,enO} = 0;
        FSM_state = state;
        case (state)
            Wait_OP1:       enA = 1;
                            
            Wait_OP2:       enB = 1;
                            
            Wait_operation: enO = 1;
                            
            Show_result:    show =1;
        endcase end 
endmodule
