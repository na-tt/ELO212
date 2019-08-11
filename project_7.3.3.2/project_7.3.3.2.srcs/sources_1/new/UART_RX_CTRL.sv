`timescale 1ns / 1ps

module UART_RX_CTRL(
    input logic rx_ready,clk,reset,
    input logic [7:0] rx_data,
    output logic [15:0] operando1,operando2,
    output logic [3:0] ALU_ctrl,state_peek,
    output logic trigger_TX_result
    );
    
    // FSM states
    enum logic [3:0] {Wait_OP1_LSB,Store_OP1_LSB,Wait_OP1_MSB,Store_OP1_MSB,
                      Wait_OP2_LSB,Store_OP2_LSB,Wait_OP2_MSB,Store_OP2_MSB,
                      Wait_CMD,Store_CMD,Delay_1_cycle,Trigger_TX_result} state,state_next;
                      
    assign state_peek = state;
     
     // next state register                 
    always_ff @(posedge clk) begin
        if (reset) state <= Wait_OP1_LSB;
        else       state <= state_next;
        end
    
     // next state LOGIC   
    always_comb begin
        case(state)
            Wait_OP1_LSB :   state_next = (rx_ready) ? Store_OP1_LSB : Wait_OP1_LSB;
            
            Store_OP1_LSB:   state_next = Wait_OP1_MSB;
            
            Wait_OP1_MSB :   state_next = (rx_ready) ? Store_OP1_MSB : Wait_OP1_MSB; 
            
            Store_OP1_MSB:   state_next = Wait_OP2_LSB;
            
            Wait_OP2_LSB :   state_next = (rx_ready) ? Store_OP2_LSB : Wait_OP2_LSB;
            
            Store_OP2_LSB:   state_next = Wait_OP2_MSB;
            
            Wait_OP2_MSB :   state_next = (rx_ready) ? Store_OP2_MSB : Wait_OP2_MSB; 
            
            Store_OP2_MSB:   state_next = Wait_CMD;
            
            Wait_CMD     :   state_next = (rx_ready) ? Store_CMD     : Wait_CMD;
            
            Store_CMD    :   state_next = Delay_1_cycle;
            
            Delay_1_cycle:   state_next = Trigger_TX_result;
            
            Trigger_TX_result: state_next = Wait_OP1_LSB;
            
            default:    state_next = Wait_OP1_LSB ; 
            endcase end
            
    always_ff @(posedge clk) begin
        if (reset) begin
                   operando1 <= 'd0;
                   operando2 <= 'd0;
                   ALU_ctrl  <= 'd0;
                   end
        else begin
             case (state)
                Store_OP1_LSB:  operando1[7:0] <= rx_data;
                Store_OP1_MSB:  operando1[15:8]<= rx_data;
                Store_OP2_LSB:  operando2[7:0] <= rx_data;
                Store_OP2_MSB:  operando2[15:8]<= rx_data;
                Store_CMD    :  ALU_ctrl       <= rx_data[3:0];
                endcase end end
                
   assign trigger_TX_result = (state == Trigger_TX_result) ? 1'b1 : 1'b0 ; 
   
   
endmodule