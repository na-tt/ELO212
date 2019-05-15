`timescale 1ns / 1ps

module button_counter8hex(

    input CLK100MHZ,BTNC,reset,
    output CA,CB,CC,CD,CE,CF,CG,DP,AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0

    );
        
    assign DP = 1;
    logic BTNC_sync,debclk;
    logic [31:0] count;
    
    clock_divider #(20000 ) clk100(.clk_in(CLK100MHZ),.reset(1'b0),.clk_out(debclk)); // genera un reloj para debouncer
    
    PB_Debouncer_counter debC(.clk(debclk),.rst(1'b0),.PB(BTNC),.PB_pressed_status(BTNC_sync),.PB_pressed_pulse(),.PB_released_pulse());
    
    nbit_counter #(32) cont32(.clk(BTNC_sync),.reset(reset),.count(count));
    
    logic [6:0] CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0;
    
    BCD_to_sevenSeg BCD0(.BCD_in(count[3:0]),.sevenSeg(CA0));
    BCD_to_sevenSeg BCD1(.BCD_in(count[7:4]),.sevenSeg(CA1));
    BCD_to_sevenSeg BCD2(.BCD_in(count[11:8]),.sevenSeg(CA2));
    BCD_to_sevenSeg BCD3(.BCD_in(count[15:12]),.sevenSeg(CA3));
    BCD_to_sevenSeg BCD4(.BCD_in(count[19:16]),.sevenSeg(CA4));
    BCD_to_sevenSeg BCD5(.BCD_in(count[23:20]),.sevenSeg(CA5));
    BCD_to_sevenSeg BCD6(.BCD_in(count[27:24]),.sevenSeg(CA6));
    BCD_to_sevenSeg BCD7(.BCD_in(count[31:28]),.sevenSeg(CA7));
    
    
    TDM tdm(.clk_in(CLK100MHZ),.reset(1'b0),.CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .AN7(AN7),.AN6(AN6),.AN5(AN5),.AN4(AN4),.AN3(AN3),.AN2(AN2),.AN1(AN1),.AN0(AN0),
        .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));
    
    
    
    
    
endmodule
