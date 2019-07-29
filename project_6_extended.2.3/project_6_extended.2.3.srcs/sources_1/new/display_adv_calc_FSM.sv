`timescale 1ns / 1ps

module display_adv_calc_FSM(
    input CLK100MHZ,CPU_RESETN,BTNC,BTND,BTNU,
    input [15:0] SW,
    output CA,CB,CC,CD,CE,CG,CF,DP,AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0,LED1,LED0,LED16_G,LED16_R
    );
    assign DP = ~0;
    logic CPU_reset,BTNC_pressed,BTND_pressed,BTNU_pressed,BTNU_deb;
    PB_Debouncer_counter #(100000) debCPU(.clk(CLK100MHZ),.rst(0),.PB(~CPU_RESETN),.PB_pressed_status(CPU_reset),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter #(100000) debCenter(.clk(CLK100MHZ),.rst(0),.PB(BTNC),.PB_pressed_status(),.PB_pressed_pulse(BTNC_pressed),.PB_released_pulse());
    PB_Debouncer_counter #(100000) debDOWN(.clk(CLK100MHZ),.rst(0),.PB(BTND),.PB_pressed_status(),.PB_pressed_pulse(BTND_pressed),.PB_released_pulse());
    PB_Debouncer_counter #(100000) debUP(.clk(CLK100MHZ),.rst(0),.PB(BTNU),.PB_pressed_status(BTNU_deb),.PB_pressed_pulse(BTNU_pressed),.PB_released_pulse());
    // at 100MHZ 100000 cicles (actually 2^17 = 131072) gives 1ms (actually 1.31ms) of input lag 
    
    logic [15:0] result;
    logic show,error,display;
    
    advc_calc_FSM #(16) FSM(.clk(CLK100MHZ),.reset(CPU_reset),.next(BTNC_pressed),
                            .bits(SW),.show(show),.result(result),.FSM_state({LED1,LED0}),
                            .error(error),.display(display),.undo(BTND_pressed));
                            
    assign {LED16_G,LED16_R} = {~error&show,error&show};  
    
    logic [6:0] CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0;
    logic [6:0] CA3r_hex,CA2r_hex,CA1r_hex,CA0r_hex; // intermediarios result hexadecimal
    logic [6:0] CA4r_dec,CA3r_dec,CA2r_dec,CA1r_dec,CA0r_dec; //intermediarios result decimal
    logic [3:0] BCD4r,BCD3r,BCD2r,BCD1r,BCD0r;
    logic [6:0] CA3s_hex,CA2s_hex,CA1s_hex,CA0s_hex; // intermediarios SWITCHES hexadecimal 
    logic [6:0] CA4s_dec,CA3s_dec,CA2s_dec,CA1s_dec,CA0s_dec; // intermediarios SWITCHES decimal
    logic [3:0] BCD4s,BCD3s,BCD2s,BCD1s,BCD0s;
    
    BCD_to_sevenSeg BCDr3_hex(.BCD_in(result[15:12]),.sevenSeg(CA3r_hex));
    BCD_to_sevenSeg BCDr2_hex(.BCD_in(result[11:8]),.sevenSeg(CA2r_hex));
    BCD_to_sevenSeg BCDr1_hex(.BCD_in(result[7:4]),.sevenSeg(CA1r_hex));
    BCD_to_sevenSeg BCDr0_hex(.BCD_in(result[3:0]),.sevenSeg(CA0r_hex));
    
    BCD_to_sevenSeg BCDs3_hex(.BCD_in(SW[15:12]),.sevenSeg(CA3s_hex));
    BCD_to_sevenSeg BCDs2_hex(.BCD_in(SW[11:8]),.sevenSeg(CA2s_hex));
    BCD_to_sevenSeg BCDs1_hex(.BCD_in(SW[7:4]),.sevenSeg(CA1s_hex));
    BCD_to_sevenSeg BCDs0_hex(.BCD_in(SW[3:0]),.sevenSeg(CA0s_hex));
    
    Binary_to_BCD #(16,5) DDr(.i_Clock(CLK100MHZ),.i_Binary(result),.i_Start(BTNU_pressed),
                             .o_BCD({BCD4r,BCD3r,BCD2r,BCD1r,BCD0r}),.o_DV()); 
                             
    Binary_to_BCD #(16,5) DDs(.i_Clock(CLK100MHZ),.i_Binary(SW),.i_Start(BTNU_pressed),
                              .o_BCD({BCD4s,BCD3s,BCD2s,BCD1s,BCD0s}),.o_DV());
                             
    BCD_to_sevenSeg BCDr4_dec(.BCD_in(BCD4r),.sevenSeg(CA4r_dec));                         
    BCD_to_sevenSeg BCDr3_dec(.BCD_in(BCD3r),.sevenSeg(CA3r_dec));
    BCD_to_sevenSeg BCDr2_dec(.BCD_in(BCD2r),.sevenSeg(CA2r_dec));
    BCD_to_sevenSeg BCDr1_dec(.BCD_in(BCD1r),.sevenSeg(CA1r_dec));
    BCD_to_sevenSeg BCDr0_dec(.BCD_in(BCD0r),.sevenSeg(CA0r_dec));
    
    BCD_to_sevenSeg BCDs4_dec(.BCD_in(BCD4s),.sevenSeg(CA4s_dec));                         
    BCD_to_sevenSeg BCDs3_dec(.BCD_in(BCD3s),.sevenSeg(CA3s_dec));
    BCD_to_sevenSeg BCDs2_dec(.BCD_in(BCD2s),.sevenSeg(CA2s_dec));
    BCD_to_sevenSeg BCDs1_dec(.BCD_in(BCD1s),.sevenSeg(CA1s_dec));
    BCD_to_sevenSeg BCDs0_dec(.BCD_in(BCD0s),.sevenSeg(CA0s_dec));
    

    always_comb
        if (show)           if (BTNU_deb) {CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0} = {~21'd0,CA4r_dec,CA3r_dec,CA2r_dec,CA1r_dec,CA0r_dec};
                            else          {CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0} = {~28'd0,CA3r_hex,CA2r_hex,CA1r_hex,CA0r_hex};  
        else if (display)   if (BTNU_deb) {CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0} = {~21'd0,CA4s_dec,CA3s_dec,CA2s_dec,CA1s_dec,CA0s_dec};
                            else          {CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0} = {~28'd0,CA3s_hex,CA2s_hex,CA1s_hex,CA0s_hex};  
        else                              {CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0} = ~56'd0;  
        
    TDM tdm(.clk_in(CLK100MHZ),.reset(0),.CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .AN7(AN7),.AN6(AN6),.AN5(AN5),.AN4(AN4),.AN3(AN3),.AN2(AN2),.AN1(AN1),.AN0(AN0),
        .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));

endmodule
