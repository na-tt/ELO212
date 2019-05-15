`timescale 1ns / 1ps

module bin8bit_to_3decBCD(
    input logic [7:0] binary,
    output logic [3:0] BCD0,BCD1,BCD2
    );
    
    always_comb begin
        BCD2 = binary/100;
        BCD1 = binary/10 - 10*(binary/100);
        BCD0 = binary%10;
    end
endmodule
