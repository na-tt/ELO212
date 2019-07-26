`timescale 1ns / 1ps

module display_basic_calc(
    input logic CLK100MHZ,CPU_RESETN,BTNC,SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,
    input logic  SW8,SW9,SW10,SW11,SW12,SW13,SW14,SW15,
    output logic  CA,CB,CC,CD,CE,CG,CF,DP,AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0,LED1,LED0
    ,output logic JA1,JA2,JA3,JA7,JA8,JA9

    );
    assign DP = ~0;
    logic divclk,CPU_reset,next,show;
    logic [15:0] result;
    logic [1:0] leds;
    
    assign JA1 = divclk;
    assign {JA2,JA3} = leds;
    assign JA7 = next;  
    assign JA8 = CPU_reset;
    assign JA9 = show;
    
    clock_divider #(5000) clk10k(.clk_in(CLK100MHZ),.reset(0),.clk_out(divclk)); // genera un reloj para debouncer de 10khz
     
    PB_Debouncer_counter debCPU(.clk(divclk),.rst(0),.PB(CPU_RESETN),.PB_pressed_status(CPU_reset),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter debCenter(.clk(divclk),.rst(0),.PB(BTNC),.PB_pressed_status(),.PB_pressed_pulse(next),.PB_released_pulse());
    
    logic [15:0] bits;
    assign bits = {SW15,SW14,SW13,SW12,SW11,SW10,SW9,SW8,SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0};
    
    basic_calc calc(.clk(divclk),.reset(CPU_reset),.next(next),.bits(bits),.show(show),.result(result),.FSM_state(leds));
    assign {LED1,LED0} = leds;
    
    logic [6:0] CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0;
    logic [6:0] CA3r,CA2r,CA1r,CA0r; // intermediarios result
   
    BCD_to_sevenSeg BCDr3(.BCD_in(result[15:12]),.sevenSeg(CA3r));
    BCD_to_sevenSeg BCDr2(.BCD_in(result[11:8]),.sevenSeg(CA2r));
    BCD_to_sevenSeg BCDr1(.BCD_in(result[7:4]),.sevenSeg(CA1r));
    BCD_to_sevenSeg BCDr0(.BCD_in(result[3:0]),.sevenSeg(CA0r));
   
    always_comb
        if (show) {CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0} = {~28'd0,CA3r,CA2r,CA1r,CA0r};
        else      {CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0} = {~56'd0};
        
    TDM tdm(.clk_in(CLK100MHZ),.reset(0),.CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .AN7(AN7),.AN6(AN6),.AN5(AN5),.AN4(AN4),.AN3(AN3),.AN2(AN2),.AN1(AN1),.AN0(AN0),
        .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));
     
endmodule
