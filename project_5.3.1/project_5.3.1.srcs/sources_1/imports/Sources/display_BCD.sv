`timescale 1ns / 1ps

module display_BCD(
    input  a0,a1,a2,a3,onoff,CLK100MHZ,
    output  DP,AN0,AN1,AN2,AN3,AN4,AN5,AN6,AN7,CA,CB,CC,CD,CE,CF,CG
    );
    
    logic [3:0] BCD = {a3_sync,a2_sync,a1_sync,a0_sync};
    logic [6:0] sevenSeg;
    logic DPR;
    logic a3_sync,a2_sync,a1_sync,a0_sync;
    
    always_ff @(posedge CLK100MHZ) begin
        a3_sync <= a3;
        a2_sync <= a2;
        a1_sync <= a1;
        a0_sync <= a0;
     end
         
    
    BCD_to_sevenSeg convertidor( 
        .BCD_in(BCD),.sevenSeg(sevenSeg)); 
        
    fib_rec reconocedor(
        .BCD_in(BCD) , .fib(DPR));
        
        
    assign   {CA,CB,CC,CD,CE,CF,CG} = sevenSeg ;
    assign     AN0 = ~onoff;   
    assign     DP = ~DPR;
    assign     {AN7,AN6,AN5,AN4,AN3,AN2,AN1} = 7'b1111111;
    
    
endmodule
