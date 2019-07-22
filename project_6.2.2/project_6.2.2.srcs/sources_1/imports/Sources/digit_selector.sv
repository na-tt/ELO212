`timescale 1ns / 1ps

module digit_selector(
    input logic [6:0] CA7,
    input logic [6:0] CA6,
    input logic [6:0] CA5,
    input logic [6:0] CA4,
    input logic [6:0] CA3,
    input logic [6:0] CA2,
    input logic [6:0] CA1,
    input logic [6:0] CA0,
    input logic [2:0] counter_selector,
    output logic [6:0] CA_select,
    output logic [7:0] AN_select
    );
    
    always_comb begin
        case(counter_selector)
            4'd0:    CA_select = CA0; 
            4'd1:    CA_select = CA1; 
            4'd2:    CA_select = CA2; 
            4'd3:    CA_select = CA3; 
            4'd4:    CA_select = CA4; 
            4'd5:    CA_select = CA5; 
            4'd6:    CA_select = CA6; 
            4'd7:    CA_select = CA7; 
            default: CA_select = CA0; 
        endcase
        case (counter_selector)
            4'd0:   AN_select = ~8'b00000001;  // its easier to think that 1's activate anodes
            4'd1:   AN_select = ~8'b00000010;  // yet,it is the oposite due to the pnp transistors between 3.3v and the anodes
            4'd2:   AN_select = ~8'b00000100;  // bitwise negations are used to make it more readable
            4'd3:   AN_select = ~8'b00001000;
            4'd4:   AN_select = ~8'b00010000;
            4'd5:   AN_select = ~8'b00100000;
            4'd6:   AN_select = ~8'b01000000;
            4'd7:   AN_select = ~8'b10000000;
            default:AN_select = ~8'b00000000;
        endcase          
   end
endmodule