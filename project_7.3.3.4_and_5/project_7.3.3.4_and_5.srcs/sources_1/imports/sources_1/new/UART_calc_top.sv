`timescale 1ns / 1ps

module UART_calc_top(
    input clk_100M,reset_n,uart_rx,
    output [7:0] Anodos,
    output [6:0] Catodos,
    output LED16_G,LED16_R,DP,uart_tx,tap_rx,tap_tx,
    output [3:0] leds
    );
    //tapping
    assign tap_rx = uart_rx;
    assign tap_tx = uart_tx;
    
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
	logic tx_start,trigger_TX_result;
	logic [7:0] tx_data;
	
	uart_basic uart_basic_inst0(.clk(clk_100M),.reset(reset),.rx(uart_rx),  
                                .rx_data(rx_data),.rx_ready(rx_ready), // hasta aqui es recepcion
                                .tx_data(tx_data),.tx_start(tx_start), // desde aqui es envio
                                .tx(uart_tx),.tx_busy());      	
    
    logic [15:0] operando1,operando2,result;
    logic [1:0] ALU_ctrl,display_ctrl;
    UART_RX_CTRL_MOD UART_RX_CTRL_MOD_inst0(.clk(clk_100M),.reset(reset),.rx_ready(rx_ready),.rx_data(rx_data),
                                            .state_peek(leds),.trigger_TX_result(trigger_TX_result),
                                            .operando1(operando1),.operando2(operando2),
                                            .ALU_ctrl(ALU_ctrl),.display_ctrl(display_ctrl));
   
   TX_control TX_control_inst0(.clock(clk_100M),.reset(reset),.PB(trigger_TX_result),.send16(1'b1),.dataIn16(result),
                               .tx_data(tx_data),.tx_start(tx_start),.busy());
   
   
   
                
   logic over_under;                                         
   ALU_display_controller display_controller(.clk(clk_100M),.reset(reset),.operando1(operando1),.operando2(operando2),
                                             .ALU_ctrl(ALU_ctrl),.display_ctrl(display_ctrl),
                                             .Anodos(Anodos),.Catodos(Catodos),.over_under(over_under),
                                             .result(result));
   
   assign LED16_G = (&display_ctrl)&&(~over_under); 
   assign LED16_R = (&display_ctrl)&&(over_under);      // (&display_ctrl) pues el 2'b11 es para mostrar result                                 
    
    
    
endmodule
