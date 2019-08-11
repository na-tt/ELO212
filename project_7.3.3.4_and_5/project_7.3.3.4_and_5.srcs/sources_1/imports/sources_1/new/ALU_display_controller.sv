`timescale 1ns / 1ps

module ALU_display_controller(
    input logic clk,reset,
    input logic [15:0] operando1,operando2,
    input logic [1:0] ALU_ctrl,display_ctrl,
    output logic [15:0] result,
    output logic [7:0] Anodos,
    output logic [6:0] Catodos,
    output logic over_under
    
    );
    
    logic [3:0] opcode;
    assign opcode = {~ALU_ctrl[1]&~ALU_ctrl[0],~ALU_ctrl[1]&ALU_ctrl[0],ALU_ctrl[1]&ALU_ctrl[0],ALU_ctrl[1]&~ALU_ctrl[0]}; // decod
    
    ALU #(16) alu(.A(operando1),.B(operando2),.opcode(opcode),.result(result),.status());
    
    always_comb begin // indicador under/over flow
        case (opcode)
            4'b1000:        if ((result <= operando1) | (result <= operando2)) over_under = 1'b1; //because the sum overflowed
                            else over_under = 1'b0;
            4'b0100:        if ((result >= operando1) | (result >= operando2)) over_under = 1'b1; //because the sum underflowed
                            else over_under = 1'b0;
            default:        over_under = 1'b0; // bitwise OR and AND have no concept of over/under flow so there is no errror
            endcase end
        
   logic [15:0] display;
   // se selecciona que numero mostrar
   always_comb begin
    case (display_ctrl)
        2'b01 :  display = operando1;
        2'b10 :  display = operando2;
        2'b11 :  display = result;
        default: display = 16'd0;
        endcase end
        
   logic trigger_conversion;
   logic [15:0] display_reg;
   
   always_ff @(posedge clk) 
    display_reg <= display;
  
   assign trigger_conversion = (display != display_reg); // estamos diciendo si display cambia, iniciar conversion
   
   logic [3:0] BCD4,BCD3,BCD2,BCD1,BCD0;
   Binary_to_BCD #(16,5) DDr(.i_Clock(clk),.i_Binary(display),.i_Start(trigger_conversion),
                             .o_BCD({BCD4,BCD3,BCD2,BCD1,BCD0}),.o_DV());
                             
   logic [6:0] CA7,CA6,CA5,CA4,CA3,CA2,CA1,CA0;                           
   BCD_to_sevenSeg BCD4_to_CA4(.BCD_in(BCD4),.sevenSeg(CA4));                         
   BCD_to_sevenSeg BCD3_to_CA3(.BCD_in(BCD3),.sevenSeg(CA3));
   BCD_to_sevenSeg BCD2_to_CA2(.BCD_in(BCD2),.sevenSeg(CA2));
   BCD_to_sevenSeg BCD1_to_CA1(.BCD_in(BCD1),.sevenSeg(CA1));
   BCD_to_sevenSeg BCD0_to_CA0(.BCD_in(BCD0),.sevenSeg(CA0));
   
   assign {CA7,CA6,CA5} = ~(21'd0); //apagados
   
   logic AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0,CA,CB,CC,CD,CE,CF,CG;
   
   TDM tdm(.clk_in(clk),.reset(0),.CA7(CA7),.CA6(CA6),.CA5(CA5),.CA4(CA4),.CA3(CA3),.CA2(CA2),.CA1(CA1),.CA0(CA0),
        .AN7(AN7),.AN6(AN6),.AN5(AN5),.AN4(AN4),.AN3(AN3),.AN2(AN2),.AN1(AN1),.AN0(AN0),
        .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));
        
   assign Anodos = {AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0};
   assign Catodos = {CG,CF,CE,CD,CC,CB,CA}; 
   
endmodule
