`timescale 1ns / 1ps

module group_display(
    input SW0,SW1,CLK100MHZ,
    output AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0,CA,CB,CC,CD,CE,CF,CG,DP
    );
    
    assign DP = 1;
    logic [6:0] CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0;
    logic [1:0] mode = {SW1,SW0}; 
    
    TDM tdm(.clk_in(CLK100MHZ),.reset(1'b0),.CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .AN7(AN7),.AN6(AN6),.AN5(AN5),.AN4(AN4),.AN3(AN3),.AN2(AN2),.AN1(AN1),.AN0(AN0),
        .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));
        
    always_comb begin            
        if (mode == 2'b01) begin
            CA7 = ~7'b1111110;  // O
            CA6 = ~7'b0001110;  // L
            CA5 = ~7'b0000110;  // i
            CA4 = ~7'b0011100;  // v
            CA3 = ~7'b1110111;  // A
            CA2 = ~7'b0000101;  // r
            CA1 = ~7'b1001111;  // E
            CA0 = ~7'b1011011;  // S
             end
             
        else if (mode == 2'b10) begin
            CA7 = ~7'b0000000;  // nada
            CA6 = ~7'b0000000;  // nada
            CA5 = ~7'b1100111;  // P
            CA4 = ~7'b1110111;  // A
            CA3 = ~7'b0010101;  // n
            CA2 = ~7'b1110111;  // A
            CA1 = ~7'b0000111;  // t
            CA0 = ~7'b0000111;  // t
             end
             
       else if (mode == 2'b11) begin
            CA7 = ~7'b0000000;  // nada
            CA6 = ~7'b1110011;  // Q
            CA5 = ~7'b0111110;  // U
            CA4 = ~7'b1001111;  // E
            CA3 = ~7'b0011100;  // v
            CA2 = ~7'b1001111;  // E
            CA1 = ~7'b0111101;  // d
            CA0 = ~7'b1111110;  // O
            end   
            
       else begin
            CA7 = ~7'b0000000;  // nada
            CA6 = ~7'b0000000;  // nada
            CA5 = ~7'b1001111;  // E
            CA4 = ~7'b0001110;  // L
            CA3 = ~7'b1111110;  // O
            CA2 = ~7'b1101101;  // 2
            CA1 = ~7'b0110000;  // 1
            CA0 = ~7'b1101101;  // 2
            end
    
    end
    
endmodule
