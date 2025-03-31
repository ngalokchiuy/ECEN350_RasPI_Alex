`timescale 1ns / 1ps

module SignExtender(BusImm, In26, Ctrl, movz, lsl); 
  output reg [63:0] BusImm; //64 bit output
  input [25:0] In26; //26 bit 
  input [1:0] Ctrl; // 2-bit control
  input movz; //1-bit input control
  input [1:0] lsl; // multiples of 16

  reg extBit; //internal wire for extra bits
  reg [63:0] unshifted_imm;
  wire [2:0] final_sign_op = {movz, Ctrl};
  
  always@(*)
     case(final_sign_op) // select based on W
                3'b100: begin
                    unshifted_imm = {48'b0, In26[20:5]}; //64 - 16
                    BusImm = {unshifted_imm << (16*lsl)};
                end
                3'b000: begin // I - type (ADD SUB)
                    //extBit = In26[21];
                    BusImm = {52'b0, In26[21:10]}; //64 - 12
                end
                3'b001: begin // D-type (LDUR STUR)
                     extBit = In26[20];
                     BusImm = {{55{extBit}}, In26[20:12]}; //64 - 9
                end
                3'b010: begin  // B 
                    extBit = In26[25];
                    BusImm = {{38{extBit}}, In26};; //64 - 26
                end
                3'b011: begin  // CBZ
                    extBit = In26[23]; 
                    BusImm = {{45{extBit}}, In26[23:5]}; //64 - 19
                end
            endcase
endmodule