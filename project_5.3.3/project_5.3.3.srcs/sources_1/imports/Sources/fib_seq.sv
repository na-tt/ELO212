`timescale 1ns / 1ps

module top_fib_seq(
    input  CLK100MHZ,onoff,reset,
    output  DP,AN0,AN1,AN2,AN3,AN4,AN5,AN6,AN7,CA,CB,CC,CD,CE,CF,CG
    );
    
    logic [6:0] sevenSeg;
    logic DPR;
    logic CLK1HZ;
    logic [3:0]counter_seq;
    logic dummyreset =1'b0;
    
    clock_divider #(50000000) clock(
        .clk_in(CLK100MHZ), .reset(dummyreset), .clk_out(CLK1HZ));
    
    nbit_counter #(4) contador(
        .clk(CLK1HZ), .reset(reset), .count(counter_seq));
    
    
    BCD_to_sevenSeg convertidor( 
        .BCD_in(counter_seq),.sevenSeg(sevenSeg)); 
            
    fib_rec reconocedor(
        .BCD_in(counter_seq) , .fib(DPR));
    
        
    assign   {CA,CB,CC,CD,CE,CF,CG} = sevenSeg ;
    assign     AN0 = ~onoff;   
    assign     DP = ~DPR;
    assign     AN1=1'b1,AN2=1'b1,AN3=1'b1,AN4=1'b1,AN5=1'b1,AN6=1'b1,AN7=1'b1;

endmodule
