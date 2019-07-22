`timescale 1ns / 1ps

module display_reg(

    input CLK100MHZ,SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0,BTNC,BTND,
    output CA,CB,CC,CD,CE,CF,CG,AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0,DP

    );
    
    assign DP = ~0;
    logic debclk; // reloj para debouncer
    clock_divider #(20000 ) clk100(.clk_in(CLK100MHZ),.reset(0),.clk_out(debclk)); // genera un reloj para debouncer
    logic BTNC_deb;
    PB_Debouncer_counter debCenter(.clk(debclk),.rst(0),.PB(BTNC),.PB_pressed_status(BTNC_deb),.PB_pressed_pulse(),.PB_released_pulse());
    
    logic BTND_deb;
    PB_Debouncer_counter debDown(.clk(debclk),.rst(0),.PB(BTND),.PB_pressed_status(BTND_deb),.PB_pressed_pulse(),.PB_released_pulse());
    
    logic [7:0] stored_value;
    reg_bank bank(.bits({SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0}),.registry(stored_value),.clk(debclk),.enable(BTNC_deb),.reset(BTND_deb));
    
    logic [6:0] CA1,CA0;
    logic [6:0] CA2 = ~7'b0,CA3 = ~7'b0,CA4 = ~7'b0,CA5 = ~7'b0,CA6 = ~7'b0,CA7 = ~7'b0;
    
    BCD_to_sevenSeg BCD1(.BCD_in(stored_value[7:4]),.sevenSeg(CA1));
    BCD_to_sevenSeg BCD0(.BCD_in(stored_value[3:0]),.sevenSeg(CA0));
    
    TDM tdm(.clk_in(CLK100MHZ),.reset(0),.CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .AN7(AN7),.AN6(AN6),.AN5(AN5),.AN4(AN4),.AN3(AN3),.AN2(AN2),.AN1(AN1),.AN0(AN0),
        .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));
    
    
    
endmodule
