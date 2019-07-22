`timescale 1ns / 1ps

module display_retentor(

    input CLK100MHZ,BTNL,BTNC,BTNR,SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,
    input SW8,SW9,SW10,SW11,SW12,SW13,SW14,SW15,
    output CA,CB,CC,CD,CE,CG,CF,DP,AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0

    );
    assign DP = ~0;
    logic debclk,BTNL_deb,BTNC_deb,BTNR_deb;
    
    clock_divider #(20000 ) clk100(.clk_in(CLK100MHZ),.reset(0),.clk_out(debclk)); // genera un reloj para debouncer de 100hz
    
    PB_Debouncer_counter debLeft(.clk(debclk),.rst(0),.PB(BTNL),.PB_pressed_status(BTNL_deb),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter debCenter(.clk(debclk),.rst(0),.PB(BTNC),.PB_pressed_status(BTNC_deb),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter debRight(.clk(debclk),.rst(0),.PB(BTNR),.PB_pressed_status(BTNR_deb),.PB_pressed_pulse(),.PB_released_pulse());
    
    logic [15:0] bits = {SW15,SW14,SW13,SW12,SW11,SW10,SW9,SW8,SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0};
    logic [15:0] A,B;
    
    n_retentor2 #(16) retentor(.bits(bits),.clk(debclk),.reset(BTNC_deb),
                                .enable1(BTNL_deb),.enable2(BTNR_deb),.registry1(A),.registry2(B));
                                
                                
   logic [6:0] CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0;
   
   BCD_to_sevenSeg BCDA3(.BCD_in(A[15:12]),.sevenSeg(CA7));
   BCD_to_sevenSeg BCDA2(.BCD_in(A[11:8]),.sevenSeg(CA6));
   BCD_to_sevenSeg BCDA1(.BCD_in(A[7:4]),.sevenSeg(CA5));
   BCD_to_sevenSeg BCDA0(.BCD_in(A[3:0]),.sevenSeg(CA4));
   
   BCD_to_sevenSeg BCDB3(.BCD_in(B[15:12]),.sevenSeg(CA3));
   BCD_to_sevenSeg BCDB2(.BCD_in(B[11:8]),.sevenSeg(CA2));
   BCD_to_sevenSeg BCDB1(.BCD_in(B[7:4]),.sevenSeg(CA1));
   BCD_to_sevenSeg BCDB0(.BCD_in(B[3:0]),.sevenSeg(CA0));
   
   TDM tdm(.clk_in(CLK100MHZ),.reset(0),.CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .AN7(AN7),.AN6(AN6),.AN5(AN5),.AN4(AN4),.AN3(AN3),.AN2(AN2),.AN1(AN1),.AN0(AN0),
        .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));
 
endmodule
