`timescale 1ns / 1ps

module UART_RX_CTRL_testbench();

logic clk,reset,rx_ready,trigger_TX_result;
logic [7:0] rx_data;
logic [3:0] ALU_ctrl,state_peek;
logic [15:0] operando1,operando2;

UART_RX_CTRL DUT(.clk(clk),.reset(reset),.rx_ready(rx_ready),.rx_data(rx_data),
                 .operando1(operando1),.operando2(operando2),.ALU_ctrl(ALU_ctrl),.state_peek(state_peek),.trigger_TX_result(trigger_TX_result));
                 
initial begin
    clk=0;
    reset=1;
    rx_ready=0;
    rx_data = 8'hFA;
    #2;
    reset=0;
end

always #1 clk = ~clk;

always begin
         #3 rx_ready = ~rx_ready;
         #3 rx_ready = ~rx_ready;
         end
       
             

endmodule
