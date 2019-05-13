`timescale 1ns / 1ps

module TDM(
    
    input CLK100MHZ,
    input logic [6:0] CA7,
    input logic [6:0] CA6,
    input logic [6:0] CA5,
    input logic [6:0] CA4,
    input logic [6:0] CA3,
    input logic [6:0] CA2,
    input logic [6:0] CA1,
    input logic [6:0] CA0,
    output AN0,AN1,AN2,AN3,AN4,AN5,AN6,AN7,CA,CB,CC,CD,CE,CF,CG
   );
   logic reset =1'b0;
   logic f500;
   logic [2:0] count;
   logic [3:0] CA_select;
   logic [6:0] AN_select;
   
    clock_divider #(100000) clk500(.clk_in(CLK100MHZ),.reset(reset),.clk_out(f500));  //reloj de 500hz para display
    nbit_counter #(3) counter(.clk(f500),.reset(reset),.count(count));  // contador de 0 a 7 para seleccionar los 7 segmentos.
    
    digit_selector selector(
        .CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .counter_selector(count),.CA_select(CA_select),.AN_select(AN_select));       // selecciona un anodo y que numero debe estar mostrando
        
    assign {AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0} = AN_select; 
    
    assign {CA,CB,CC,CD,CE,CF,CG} = CA_select;
    
    
endmodule
