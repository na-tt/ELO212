`timescale 1ns / 1ps

module test_RX_CTRL_top(
    input clk_100M,reset_n,uart_rx,
    output [3:0] leds,
    output check_clk,check_uart_rx,check_state_lsb
    );
    
    logic rx_ready;
    logic [7:0] rx_data;
    logic [3:0] state_peek;
    
    // sincronizador (doble flopping)
    logic [1:0]    reset_sr;
	logic reset;
	assign reset = reset_sr[1];
	
	always_ff @(posedge clk_100M)
		reset_sr <= {reset_sr[0], ~reset_n};
    
    
    
    
    
    uart_basic uart_basic_inst0(.clk(clk_100M),.reset(reset),.rx(uart_rx),  
                                .rx_data(rx_data),.rx_ready(rx_ready));      // solo estamos usando el receptor de uart basic
    
    UART_RX_CTRL UART_RX_CTRL_inst0(.clk(clk_100M),.reset(reset),.rx_ready(rx_ready),.rx_data(rx_data),
                                    .state_peek(state_peek)); // las salidas que van a la alu y TX_control no nos interesan 
   
   assign check_clk = clk_100M;
   assign check_uart_rx = uart_rx;
   assign check_state_lsb = state_peek[0];
   assign leds = state_peek; 
endmodule
