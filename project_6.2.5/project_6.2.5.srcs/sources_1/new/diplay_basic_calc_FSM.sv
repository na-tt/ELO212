`timescale 1ns / 1ps

module diplay_basic_calc_FSM(
    input CLK100MHZ,CPU_RESETN,BTNC,SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,
    input SW8,SW9,SW10,SW11,SW12,SW13,SW14,SW15,
    output CA,CB,CC,CD,CE,CG,CF,DP,AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0,LED1,LED0
    );
    assign DP = ~0;
    logic CPU_reset,BTNC_pressed;
    PB_Debouncer_counter #(100000) debCPU(.clk(CLK100MHZ),.rst(0),.PB(CPU_RESETN),.PB_pressed_status(CPU_reset),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter #(100000) debCenter(.clk(CLK100MHZ),.rst(0),.PB(BTNC),.PB_pressed_status(),.PB_pressed_pulse(BTNC_pressed),.PB_released_pulse());
    // at 100MHZ 100000 cicles (actually 2^17 = 131072) gives 1ms (actually 1.31ms) of input lag 
    
    logic [15:0] switches,result;
    logic show;
    assign switches = {SW15,SW14,SW13,SW12,SW11,SW10,SW9,SW8,SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0};
    
    basic_calc_FSM #(16) FSM(.clk(CLK100MHZ),.reset(CPU_reset),.next(BTNC_pressed),.bits(switches),.show(show),.result(result),.FSM_state({LED1,LED0}));
    
    logic [6:0] CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0;
    logic [6:0] CA3r,CA2r,CA1r,CA0r; // intermediarios result
   
    BCD_to_sevenSeg BCDr3(.BCD_in(result[15:12]),.sevenSeg(CA3r));
    BCD_to_sevenSeg BCDr2(.BCD_in(result[11:8]),.sevenSeg(CA2r));
    BCD_to_sevenSeg BCDr1(.BCD_in(result[7:4]),.sevenSeg(CA1r));
    BCD_to_sevenSeg BCDr0(.BCD_in(result[3:0]),.sevenSeg(CA0r));
   
    always_comb
        if (show) {CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0} <= {~28'd0,CA3r,CA2r,CA1r,CA0r};
        else      {CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0} <= {~56'd0};
        
    TDM tdm(.clk_in(CLK100MHZ),.reset(0),.CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .AN7(AN7),.AN6(AN6),.AN5(AN5),.AN4(AN4),.AN3(AN3),.AN2(AN2),.AN1(AN1),.AN0(AN0),
        .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));

endmodule
