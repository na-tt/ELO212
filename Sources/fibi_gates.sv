`timescale 1ns / 1ps

module fibi_gates(
    input logic a,b,c,d, // se definen los cuatro bits de entrada
    output logic DP      // Decimal Point
    );
    
    assign DP = ((~a && ~c)||(~b && ~c)|| (~b && ~d));     
endmodule
