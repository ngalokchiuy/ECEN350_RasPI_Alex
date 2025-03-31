`timescale 1ns / 1ps
`define OPCODE_ANDREG 11'b?0001010???
`define OPCODE_ORRREG 11'b?0101010???
`define OPCODE_ADDREG 11'b?0?01011???
`define OPCODE_SUBREG 11'b?1?01011???

`define OPCODE_ADDIMM 11'b?0?10001???
`define OPCODE_SUBIMM 11'b?1?10001???

`define OPCODE_MOVZ   11'b110100101??

`define OPCODE_B      11'b?00101?????
`define OPCODE_CBZ    11'b?011010????

`define OPCODE_LDUR   11'b??111000010
`define OPCODE_STUR   11'b??111000000


module control(
	       output reg 	reg2loc,
	       output reg 	alusrc,
	       output reg 	mem2reg,
	       output reg 	regwrite,
	       output reg 	memread,
	       output reg 	memwrite,
	       output reg 	branch,
	       output reg 	uncond_branch,
	       output reg [3:0] aluop,
	       output reg [1:0] signop,
	       input [10:0] 	opcode,
	       output reg movz,
	       output reg [1:0] lsl
	       );

   always @(*)
     begin
	casez (opcode)
            // r- type
          /* Add cases here for each instruction your processor supports */
          `OPCODE_ANDREG: begin
            {reg2loc,alusrc,mem2reg,regwrite}  = {1'b0,1'b0,1'b0,1'b1};
            {memread,memwrite,branch} = {1'b0,1'b0,1'b0};
            {uncond_branch,aluop,signop} = {1'b0,4'b0000, 2'bxx};
             movz = 1'b0;
            end
          `OPCODE_ORRREG: begin
            {reg2loc,alusrc,mem2reg,regwrite}  = {1'b0,1'b0,1'b0,1'b1};
            {memread,memwrite,branch} = {1'b0,1'b0,1'b0};
            {uncond_branch,aluop,signop} = {1'b0,4'b0001, 2'bxx};
             movz = 1'b0;
          end
          `OPCODE_ADDREG: begin
            {reg2loc,alusrc,mem2reg,regwrite}  = {1'b0,1'b0,1'b0,1'b1};
            {memread,memwrite,branch} = {1'b0,1'b0,1'b0};
            {uncond_branch,aluop,signop} = {1'b0,4'b0010, 2'bxx};
             movz = 1'b0;
          end
          `OPCODE_SUBREG: begin
            {reg2loc,alusrc,mem2reg,regwrite}  = {1'b0,1'b0,1'b0,1'b1};
            {memread,memwrite,branch} = {1'b0,1'b0,1'b0};
            {uncond_branch,aluop,signop} = {1'b0,4'b0110, 2'bxx};
             movz = 1'b0;
          end
          //I- type
          `OPCODE_ADDIMM: begin
            {reg2loc,alusrc,mem2reg,regwrite}  = {1'b0,1'b1,1'b0,1'b1};
            {memread,memwrite,branch} = {1'b0,1'b0,1'b0};
            {uncond_branch,aluop,signop} = {1'b0,4'b0010, 2'b00};
             movz = 1'b0;
          end
          `OPCODE_SUBIMM: begin
            {reg2loc,alusrc,mem2reg,regwrite}  = {1'b0,1'b1,1'b0,1'b1};
            {memread,memwrite,branch} = {1'b0,1'b0,1'b0};
            {uncond_branch,aluop,signop} = {1'b0,4'b0110, 2'b00};
            movz = 1'b0;
          end
          `OPCODE_MOVZ: begin
            {reg2loc,alusrc,mem2reg,regwrite}  = {1'b0,1'b1,1'b0,1'b1};
            {memread,memwrite,branch} = {1'b0,1'b0,1'b0};
            {uncond_branch,aluop,signop} = {1'b0,4'b0111, 2'b00 }; // pass input B, 0 extendopcode[1:0]
            // ADD EXTRA Signal
            movz = 1'b1;
            lsl = opcode[1:0]; // get shift bits
          end
          `OPCODE_B: begin
            {reg2loc,alusrc,mem2reg,regwrite}  = {1'bX,1'bX,1'bX,1'b0};
            {memread,memwrite,branch} = {1'b0,1'b0,1'b0};
            {uncond_branch,aluop,signop} = {1'b1,4'bxxxx, 2'b10};
             movz = 1'b0;
          end
          //CB - type
          `OPCODE_CBZ: begin
            {reg2loc,alusrc,mem2reg,regwrite}  = {1'b1,1'b0,1'bX,1'b0};
            {memread,memwrite,branch} = {1'b0,1'b0,1'b1};
            {uncond_branch,aluop,signop} = {1'b0,4'b0111, 2'b11};
             movz = 1'b0;
          end
          //D-type
          `OPCODE_LDUR: begin
            {reg2loc,alusrc,mem2reg,regwrite}  = {1'bX,1'b1,1'b1,1'b1};
            {memread,memwrite,branch} = {1'b1,1'b0,1'b0};
            {uncond_branch,aluop,signop} = {1'b0,4'b0010, 2'b01};
             movz = 1'b0;
          end
          `OPCODE_STUR: begin
            {reg2loc,alusrc,mem2reg,regwrite}  = {1'b1,1'b1,1'bX,1'b0};
            {memread,memwrite,branch} = {1'b0,1'b1,1'b0};
            {uncond_branch,aluop,signop} = {1'b0,4'b0010, 2'b01};
             movz = 1'b0;
          end
          
          default:
            begin
               reg2loc       = 1'bx;
               alusrc        = 1'bx;
               mem2reg       = 1'bx;
               regwrite      = 1'b0;
               memread       = 1'b0;
               memwrite      = 1'b0;
               branch        = 1'b0;
               uncond_branch = 1'b0;
               aluop         = 4'bxxxx;
               signop        = 2'bxx;
               movz = 1'b0;
               lsl = 2'b00;
            end
	endcase
     end

endmodule

