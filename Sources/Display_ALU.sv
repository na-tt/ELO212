`timescale 1ns / 1ps

module Display_ALU(

    input A7,A6,A5,A4,A3,A2,A1,A0,B7,B6,B5,B4,B3,B2,B1,B0,
    input CLK100MHZ,BTNU,BTND,BTNR,BTNL,
    output CA,CB,CC,CD,CE,CF,CG,AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0,
    output LED7,LED6,LED5,LED4,LED3,LED2,LED1,LED0
    );
    
    logic dummy = 0;  // reset dummy
    logic debclk;
    logic BTNU_sync, BTND_sync, BTNR_sync, BTNL_sync;
    
    clock_divider #(20000 ) clk100(.clk_in(CLK100MHZ),.reset(dummy),.clk_out(debclk));
    
    
    PB_Debouncer_counter debUP(.clk(debclk),.reset(dummy),.PB(BTNU),.PB_pressed_status(BTNU_sync)
    
    
   
   
   
endmodule
