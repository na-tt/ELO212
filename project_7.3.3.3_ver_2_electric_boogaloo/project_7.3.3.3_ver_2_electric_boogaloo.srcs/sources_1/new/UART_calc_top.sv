`timescale 1ns / 1ps

module UART_calc_top(
    input clk_100M,reset_n,uart_rx,
    output [7:0] Anodos,
    output [6:0] Catodos,
    output LED16_G,LED16_R,DP
    );
    
    assign DP = ~0;
    logic rx_ready;
    logic [7:0] rx_data;
    
    // sincronizador (doble flopping)
    logic [1:0]    reset_sr;
	logic reset;
	assign reset = reset_sr[1];
	
	always_ff @(posedge clk_100M)
		reset_sr <= {reset_sr[0], ~reset_n};
	// fin sincronizador
	
	uart_basic uart_basic_inst0(.clk(clk_100M),.reset(reset),.rx(uart_rx),  
                                .rx_data(rx_data),.rx_ready(rx_ready));      // solo estamos usando el receptor de uart basic	
    
    logic [15:0] operando1,operando2;
    logic [1:0] ALU_ctrl,display_ctrl;
    UART_RX_CTRL_MOD UART_RX_CTRL_MOD_inst0(.clk(clk_100M),.reset(reset),.rx_ready(rx_ready),.rx_data(rx_data),
                                            .state_peek(),.trigger_TX_result(),
                                            .operando1(operando1),.operando2(operando2),
                                            .ALU_ctrl(ALU_ctrl),.display_ctrl(display_ctrl));
                
   logic over_under;                                         
   ALU_display_controller display_controller(.clk(clk_100M),.reset(reset),.operando1(operando1),.operando2(operando2),
                                             .ALU_ctrl(ALU_ctrl),.display_ctrl(display_ctrl),
                                             .Anodos(Anodos),.Catodos(Catodos),.over_under(over_under));
   
   assign LED16_G = (&display_ctrl)&&(~over_under); 
   assign LED16_R = (&display_ctrl)&&(over_under);      // (&display_ctrl) pues el 2'b11 es para mostrar result                                 
    
    
    
endmodule
