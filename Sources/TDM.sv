`timescale 1ns / 1ps

module TDM(
    
    input logic clk_in, reset,
    input logic [6:0] CA7, // estas entradas son los 7seg que queremos ver en cada display
    input logic [6:0] CA6, // cada una es un bus que contiene CA,CB,CC,CD,CE,CF,CG 
    input logic [6:0] CA5,
    input logic [6:0] CA4,
    input logic [6:0] CA3,
    input logic [6:0] CA2,
    input logic [6:0] CA1,
    input logic [6:0] CA0,
    output logic AN0,AN1,AN2,AN3,AN4,AN5,AN6,AN7,CA,CB,CC,CD,CE,CF,CG
   );
   logic clk_int;
   logic [2:0] count; // contando de 0 a 7 seleccionamos displays
   logic [6:0] CA_select; // estos son los 7seg actualmente seleccionados
   logic [7:0] AN_select; // enciende el anodo seleccionado y apaga los demas
   
   clock_divider #(100000) divider(.clk_in(clk_in),.reset(1'b0),.clk_out(clk_int)); //divide 100mhz a 500 hz
   
    nbit_counter #(3) counter(.clk(clk_int),.reset(reset),.count(count));  // contador de 0 a 7 para seleccionar los 7 segmentos y anodos.
    
    digit_selector selector(
        .CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .counter_selector(count),.CA_select(CA_select),.AN_select(AN_select));       // selecciona un anodo y que seg debe estar mostrando
        
    assign {AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0} = AN_select; 
    
    assign {CA,CB,CC,CD,CE,CF,CG} = CA_select;
    
    
endmodule
