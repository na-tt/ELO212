`timescale 1ns / 1ps

module Display_ALU(

    input A7,A6,A5,A4,A3,A2,A1,A0,B7,B6,B5,B4,B3,B2,B1,B0,
    input CLK100MHZ,BTNU,BTND,BTNR,BTNL,
    output CA,CB,CC,CD,CE,CF,CG,AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0,
    output LED7,LED6,LED5,LED4,LED3,LED2,LED1,LED0
    );
    
    logic dummy = 0;  // reset dummy
    logic debclk;
    logic BTNU_sync, BTND_sync, BTNR_sync, BTNL_sync; // botones debounceados
    
    clock_divider #(20000 ) clk100(.clk_in(CLK100MHZ),.reset(dummy),.clk_out(debclk)); // genera un reloj para debouncer
    
    PB_Debouncer_counter debUP(.clk(debclk),.rst(dummy),.PB(BTNU),.PB_pressed_status(BTNU_sync),.PB_pressed_pulse(),.PB_released_pulse);              
    PB_Debouncer_counter debDOWN(.clk(debclk),.rst(dummy),.PB(BTND),.PB_pressed_status(BTND_sync),.PB_pressed_pulse(),.PB_released_pulse);
    PB_Debouncer_counter debRIGHT(.clk(debclk),.rst(dummy),.PB(BTNR),.PB_pressed_status(BTNR_sync),.PB_pressed_pulse(),.PB_released_pulse);
    PB_Debouncer_counter debLEFT(.clk(debclk),.rst(dummy),.PB(BTNL),.PB_pressed_status(BTNL_sync),.PB_pressed_pulse(),.PB_released_pulse);
    
    logic [7:0] A,B,result;
    logic [3:0] opcode,status;
    assign A = {A7,A6,A5,A4,A3,A2,A1,A0};
    assign B = {B7,B6,B5,B4,B3,B2,B1,B0};
    assign opcode = {BTNU_sync,BTND_sync,BTNR_sync,BTNL_sync};
    
    ALU alu(.A(A),.B(B),.opcode(opcode),.result(result),.status(status));
    
    logic [6:0] CA1,CA0;
    logic [6:0] CAx = ~7'b0000000; // esto se usara para apagar displays , basta usar solo dos.
  
    
    
    
    
    
    
    
    
    
    
   
   
   
endmodule
