`timescale 1ns / 1ps

module display_alu_dec(

    input A7,A6,A5,A4,A3,A2,A1,A0,B7,B6,B5,B4,B3,B2,B1,B0,
    input CLK100MHZ,BTNU,BTND,BTNR,BTNL,
    output CA,CB,CC,CD,CE,CF,CG,AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0,DP,
    output LED7,LED6,LED5,LED4,LED3,LED2,LED1,LED0
    );
    
    assign DP = 1'b1; // esto garantiza que el punto decimal este apagado
    logic dummy = 0;  // reset dummy
    logic debclk;     // reloj para los debouncers
    logic BTNU_sync, BTND_sync, BTNR_sync, BTNL_sync; // botones debounceados
    
    clock_divider #(20000 ) clk100(.clk_in(CLK100MHZ),.reset(dummy),.clk_out(debclk)); // genera un reloj para debouncer
    
    
    PB_Debouncer_counter debUP(.clk(debclk),.rst(dummy),.PB(BTNU),.PB_pressed_status(BTNU_sync),.PB_pressed_pulse(),.PB_released_pulse());              
    PB_Debouncer_counter debDOWN(.clk(debclk),.rst(dummy),.PB(BTND),.PB_pressed_status(BTND_sync),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter debRIGHT(.clk(debclk),.rst(dummy),.PB(BTNR),.PB_pressed_status(BTNR_sync),.PB_pressed_pulse(),.PB_released_pulse());
    PB_Debouncer_counter debLEFT(.clk(debclk),.rst(dummy),.PB(BTNL),.PB_pressed_status(BTNL_sync),.PB_pressed_pulse(),.PB_released_pulse());
    
    logic [7:0] A,B,result;
    logic [3:0] opcode,status;
    assign A = {A7,A6,A5,A4,A3,A2,A1,A0};  //se asignan los switches 
    assign B = {B7,B6,B5,B4,B3,B2,B1,B0};
    assign opcode = {BTNU_sync,BTND_sync,BTNR_sync,BTNL_sync}; // se asignan los botones debounceados
    
    ALU alu(.A(A),.B(B),.opcode(opcode),.result(result),.status(status)); // instancia de ALU
    
    logic [6:0] CA6,CA5,CA4,CA2,CA1,CA0; //estos displays se usaran
    logic [6:0] CA3 = 7'b1111111,CA7 = 7'b1111111; // esto se usara para apagar displays , basta usar solo 4.
    logic [7:0] leds;
    assign leds = {LED7,LED6,LED5,LED4,LED3,LED2,LED1,LED0};
    logic [6:0] result_digit2,result_digit1,result_digit0; // estos retienen valores
    logic [6:0] A_digit0,A_digit1,A_digit2,B_digit0,B_digit1,B_digit2;
    logic [3:0] A_BCD2,A_BCD1,A_BCD0,B_BCD2,B_BCD1,B_BCD0,result_BCD2,result_BCD1,result_BCD0;
    
    bin8bit_to_3decBCD decA(.binary(A),.BCD2(A_BCD2),.BCD1(A_BCD1),.BCD0(A_BCD0));
    bin8bit_to_3decBCD decB(.binary(B),.BCD2(B_BCD2),.BCD1(B_BCD1),.BCD0(B_BCD0));
    bin8bit_to_3decBCD dec_result(.binary(result),.BCD2(result_BCD2),.BCD1(result_BCD1),.BCD0(result_BCD0));
    
    
    BCD_to_sevenSeg BCDr0(.BCD_in(result_BCD0),.sevenSeg(result_digit0));
    BCD_to_sevenSeg BCDr1(.BCD_in(result_BCD1),.sevenSeg(result_digit1));
    BCD_to_sevenSeg BCDr2(.BCD_in(result_BCD2),.sevenSeg(result_digit2));
    BCD_to_sevenSeg BCDA0(.BCD_in(A_BCD0),.sevenSeg(A_digit0));
    BCD_to_sevenSeg BCDA1(.BCD_in(A_BCD1),.sevenSeg(A_digit1));
    BCD_to_sevenSeg BCDA2(.BCD_in(A_BCD2),.sevenSeg(A_digit2));
    BCD_to_sevenSeg BCDB0(.BCD_in(B_BCD0),.sevenSeg(B_digit0));
    BCD_to_sevenSeg BCDB1(.BCD_in(B_BCD1),.sevenSeg(B_digit1));
    BCD_to_sevenSeg BCDB2(.BCD_in(B_BCD2),.sevenSeg(B_digit2));
    
    TDM tdm(.clk_in(CLK100MHZ),.reset(dummy),.CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .AN7(AN7),.AN6(AN6),.AN5(AN5),.AN4(AN4),.AN3(AN3),.AN2(AN2),.AN1(AN1),.AN0(AN0),
        .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));
    
    
    always_comb begin
    
        if (status==4'b1000 || status==4'b0100) begin
        
            CA0 = result_digit0;
            CA1 = result_digit1;
            CA2 = result_digit2;
            CA4 = ~7'd0;
            CA5 = ~7'd0;
            CA6 = ~7'd0;
            leds = 8'd0; end
            
        else if (status==4'b0010 || status==4'b0001) begin
        
            CA0 = ~7'd0;
            CA1 = ~7'd0;
            CA2 = ~7'd0;
            CA4 = ~7'd0;
            CA5 = ~7'd0;
            CA6 = ~7'd0;
            leds = result; end
        else begin
        
            CA0 = B_digit0;
            CA1 = B_digit1;
            CA2 = B_digit2;
            CA4 = A_digit0;
            CA5 = A_digit1;
            CA6 = A_digit2;
            leds = 8'd0; end      
       end
              
endmodule