`timescale 1ns / 1ps

module test_BCD( ); // creacion modulo "dummy"
    logic [3:0] BCD_in; // definicion de conexiones virtuales
    logic [6:0] sevenSeg;
    
    BCD_to_sevenSeg DUT( //instancia del modulo a testear
        .BCD_in(BCD_in),
        .sevenSeg(sevenSeg));

    initial begin         //aca se asginan valores de prueba
        BCD_in = 4'b0000;
        #3               // retardo 3 unidades de la escala de tiempo
        BCD_in = 4'b0001;
        #3
        BCD_in = 4'b0110;
        #3
        BCD_in = 4'b1001;
        #3
        BCD_in = 4'b1110; 
    end   
endmodule
