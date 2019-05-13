`timescale 1ns / 1ps

module test_fib_rec();
    
    logic [3:0] BCD_in;
    logic fib;
    
    fib_rec DUT(
        .BCD_in(BCD_in),
        .fib(fib));
        
    initial begin         
        BCD_in = 4'b0000;
        #3               
        BCD_in = 4'b0001;
        #3
        BCD_in = 4'b0110;
        #3
        BCD_in = 4'b1001;
        #3
        BCD_in = 4'b1110; 
    end   
endmodule
        