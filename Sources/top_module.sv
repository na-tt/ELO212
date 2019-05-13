`timescale 1ns / 1ps

module top_module(
    input logic     clk, reset,
    output logic    fib, onoff,
    output logic [6:0] sevenSeg
    );
    
    logic [3:0] count; // se define para asignar a la salida del contador
       
    counter_4bit contador(      //instancia del contador de 4 bits, nombrada "contador"
        .clk(clk), .reset(reset), .count(count));  // se le asignan las entradas y salida.
        
    BCD_to_sevenSeg convertidor(  //instacia del BCD a 7 seg nombrada "conversor"
        .BCD_in(count), .sevenSeg(sevenSeg)); // se asignan entrada y salida.
        
    fib_rec fibinario(      // instacia del reconocedor de fibinarios nombrado "fibinario"
         .BCD_in(count), .fib(fib)); // se asignan entrada y salida
         
         // aqui ya tenemos instanciados los 3 modulos y sus interconexiones
         //la salida onoff todavia no se a asignado, sera para activar/desactivar el display, es el switch.
endmodule
