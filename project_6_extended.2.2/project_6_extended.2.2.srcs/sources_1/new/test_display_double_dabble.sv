`timescale 1ns / 1ps

module test_display_double_dabble(
    input CLK100MHZ,BTNC,CPU_RESETN,BTNR,BTNL,BTNU,
    input [15:0] SW,
    output CA,CB,CC,CD,CE,CG,CF,DP,AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0
    );
    
    assign DP =1;
    
    logic CPU_reset,BTNC_pressed,BTNL_deb,BTNR_deb,BTNU_deb;
    
    PB_Debouncer_counter #(100000) debCPU(.clk(CLK100MHZ),.rst(0),.PB(~CPU_RESETN),.PB_pressed_status(CPU_reset),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter #(100000) debCenter(.clk(CLK100MHZ),.rst(0),.PB(BTNC),.PB_pressed_status(),.PB_pressed_pulse(BTNC_pressed),.PB_released_pulse());
    PB_Debouncer_counter #(100000) debLeft(.clk(CLK100MHZ),.rst(0),.PB(BTNL),.PB_pressed_status(BTNL_deb),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter #(100000) debRight(.clk(CLK100MHZ),.rst(0),.PB(BTNR),.PB_pressed_status(BTNR_deb),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter #(100000) debUP(.clk(CLK100MHZ),.rst(0),.PB(BTNU),.PB_pressed_status(BTNU_deb),.PB_pressed_pulse(),.PB_released_pulse());
   
 
    logic [15:0] A,B;
    
    n_retentor2 #(16) retentor(.bits(SW),.clk(CLK100MHZ),.reset(CPU_reset),
                                .enable1(BTNL_deb),.enable2(BTNR_deb),.registry1(A),.registry2(B));
                                
    logic [15:0] result,result_reg;
                                
    ALU #(16) ALU16(.A(A),.B(B),.opcode(4'b1000),.result(result),.status()); // esta ALU solo suma
    reg_bank #(16) bank(.clk(CLK100MHZ),.enable(BTNU_deb),.reset(CPU_reset),.bits(result),.registry(result_reg));
                                
    
    
    logic [3:0] BCD4,BCD3,BCD2,BCD1,BCD0;
    
    
    
    Binary_to_BCD #(16,5) DD(.i_Clock(CLK100MHZ),.i_Binary(result_reg),.i_Start(BTNC_pressed),
                             .o_BCD({BCD4,BCD3,BCD2,BCD1,BCD0}),.o_DV());   
                            
    logic [6:0] CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0;
    assign {CA7,CA6,CA5} = ~21'd0;
                           
    BCD_to_sevenSeg BCD_to7_4(.BCD_in(BCD4),.sevenSeg(CA4));
    BCD_to_sevenSeg BCD_to7_3(.BCD_in(BCD3),.sevenSeg(CA3));
    BCD_to_sevenSeg BCD_to7_2(.BCD_in(BCD2),.sevenSeg(CA2));
    BCD_to_sevenSeg BCD_to7_1(.BCD_in(BCD1),.sevenSeg(CA1));
    BCD_to_sevenSeg BCD_to7_0(.BCD_in(BCD0),.sevenSeg(CA0));
    
    TDM tdm(.clk_in(CLK100MHZ),.reset(0),.CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .AN7(AN7),.AN6(AN6),.AN5(AN5),.AN4(AN4),.AN3(AN3),.AN2(AN2),.AN1(AN1),.AN0(AN0),
        .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));
        
    
    
                            
    
    
endmodule
