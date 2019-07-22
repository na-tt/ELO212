`timescale 1ns / 1ps

module display_ALU16(

    input CLK100MHZ,BTNL,BTNC,BTNR,BTND,BTNU,SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,
    input SW8,SW9,SW10,SW11,SW12,SW13,SW14,SW15,
    output CA,CB,CC,CD,CE,CG,CF,DP,AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0

    );
    assign DP = ~0;
    logic debclk,BTNL_deb,BTNC_deb,BTNR_deb,BTNU_deb,BTND_deb;
    
    clock_divider #(20000 ) clk100(.clk_in(CLK100MHZ),.reset(0),.clk_out(debclk)); // genera un reloj para debouncer de 100hz
    
    PB_Debouncer_counter debLeft(.clk(debclk),.rst(0),.PB(BTNL),.PB_pressed_status(BTNL_deb),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter debCenter(.clk(debclk),.rst(0),.PB(BTNC),.PB_pressed_status(BTNC_deb),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter debRight(.clk(debclk),.rst(0),.PB(BTNR),.PB_pressed_status(BTNR_deb),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter debUp(.clk(debclk),.rst(0),.PB(BTNU),.PB_pressed_status(BTNU_deb),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter debDown(.clk(debclk),.rst(0),.PB(BTND),.PB_pressed_status(BTND_deb),.PB_pressed_pulse(),.PB_released_pulse());
    
    logic [15:0] bits = {SW15,SW14,SW13,SW12,SW11,SW10,SW9,SW8,SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0};
    logic [15:0] A,B;
    
    n_retentor2 #(16) retentor(.bits(bits),.clk(debclk),.reset(BTND_deb),
                                .enable1(BTNL_deb),.enable2(BTNR_deb),.registry1(A),.registry2(B));
                                
   logic [15:0] result,result_reg;
                                
   ALU #(16) ALU16(.A(A),.B(B),.opcode(4'b1000),.result(result),.status()); // esta ALU solo suma
   reg_bank #(16) bank(.clk(debclk),.enable(BTNC_deb),.reset(BTND_deb),.bits(result),.registry(result_reg));
                                
                                
   logic [6:0] CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0;
   logic [6:0] CA7i,CA6i,CA5i,CA4i,CA3i,CA2i,CA1i,CA0i; // intermediarios A y B
   logic [6:0] CA3r,CA2r,CA1r,CA0r; // intermediarios result_reg
   
   BCD_to_sevenSeg BCDA3(.BCD_in(A[15:12]),.sevenSeg(CA7i));
   BCD_to_sevenSeg BCDA2(.BCD_in(A[11:8]),.sevenSeg(CA6i));
   BCD_to_sevenSeg BCDA1(.BCD_in(A[7:4]),.sevenSeg(CA5i));
   BCD_to_sevenSeg BCDA0(.BCD_in(A[3:0]),.sevenSeg(CA4i));
   
   BCD_to_sevenSeg BCDB3(.BCD_in(B[15:12]),.sevenSeg(CA3i));
   BCD_to_sevenSeg BCDB2(.BCD_in(B[11:8]),.sevenSeg(CA2i));
   BCD_to_sevenSeg BCDB1(.BCD_in(B[7:4]),.sevenSeg(CA1i));
   BCD_to_sevenSeg BCDB0(.BCD_in(B[3:0]),.sevenSeg(CA0i));
   
   BCD_to_sevenSeg BCDr3(.BCD_in(result_reg[15:12]),.sevenSeg(CA3r));
   BCD_to_sevenSeg BCDr2(.BCD_in(result_reg[11:8]),.sevenSeg(CA2r));
   BCD_to_sevenSeg BCDr1(.BCD_in(result_reg[7:4]),.sevenSeg(CA1r));
   BCD_to_sevenSeg BCDr0(.BCD_in(result_reg[3:0]),.sevenSeg(CA0r));
   
   always_ff @(posedge debclk) begin
   
        if(BTNU_deb) 
            {CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0} <= {CA7i,CA6i,CA5i,CA4i,CA3i,CA2i,CA1i,CA0i};
        else begin
            {CA7,CA6,CA5,CA4} <= ~28'd0; // se apagan los displays de la izquierda
            {CA3,CA2,CA1,CA0} <= {CA3r,CA2r,CA1r,CA0r}; end
        end
            
    
    
   
   
   TDM tdm(.clk_in(CLK100MHZ),.reset(0),.CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .AN7(AN7),.AN6(AN6),.AN5(AN5),.AN4(AN4),.AN3(AN3),.AN2(AN2),.AN1(AN1),.AN0(AN0),
        .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));
 
endmodule
