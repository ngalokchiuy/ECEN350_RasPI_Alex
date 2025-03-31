`timescale 1ns / 1ps
module singlecycle(
		   input 	     resetl,
		   input [63:0]      startpc,
		   output reg [63:0] currentpc,
		   output [63:0]     MemtoRegOut,  // this should be
						   // attached to the
						   // output of the
						   // MemtoReg Mux
		   input 	     CLK,
		   output [63:0] test // FOR TESTING VALUES
		   );

   // Next PC connections
   wire [63:0] 			     nextpc;       // The next PC, to be updated on clock cycle

   // Instruction Memory connections
   wire [31:0] 			     instruction;  // The current instruction

   // Parts of instruction
   wire [4:0] 			     rd;            // The destination register
   wire [4:0] 			     rm;            // Operand 1
   wire [4:0] 			     rn;            // Operand 2
   wire [10:0] 			     opcode;

   // Control wires
   wire 			     reg2loc;
   wire 			     alusrc;
   wire 			     mem2reg;
   wire 			     regwrite;
   wire 			     memread;
   wire 			     memwrite;
   wire 			     branch;
   wire 			     uncond_branch;
   wire [3:0] 			     aluctrl;
   wire [1:0] 			     signop;
   //add
   wire                 movz;
   wire [1:0]           lsl;

   // Register file connections
   wire [63:0] 			     regoutA;     // Output A
   wire [63:0] 			     regoutB;     // Output B

   // ALU connections
   wire [63:0] 			     aluout;
   wire 			     zero;

   // Sign Extender connections
   wire [63:0] 			     extimm;

   // PC update logic
   always @(negedge CLK)
     begin
        if (resetl)
          currentpc <= #3 nextpc;
        else
          currentpc <= #3 startpc;
     end

   // Parts of instruction
   assign rd = instruction[4:0];
   assign rm = instruction[9:5];
   // use reg2loc MUX
   assign rn = reg2loc ? instruction[4:0] : instruction[20:16];
   assign opcode = instruction[31:21];

   InstructionMemory imem(
			  .Data(instruction),
			  .Address(currentpc)
			  );

   control control(
		   .reg2loc(reg2loc),
		   .alusrc(alusrc),
		   .mem2reg(mem2reg),
		   .regwrite(regwrite),
		   .memread(memread),
		   .memwrite(memwrite),
		   .branch(branch),
		   .uncond_branch(uncond_branch),
		   .aluop(aluctrl),
		   .signop(signop),
		   .opcode(opcode),
		   .movz(movz),
		   .lsl(lsl)
		   );

   /*
    * Connect the remaining datapath elements below.
    * Do not forget any additional multiplexers that may be required.
    */
   // reg2 mux, in, rd, control = reg2loc (ALREADY CODED)
   
   // REG_FILE, in = RN (output from reg2loc Mux), rm [9:5] (read reg1), write_data, write_reg
   // control = reg_write
   // out = regoutA, regoutB
   RegisterFile my_reg_file(.BusA(regoutA), .BusB(regoutB), .BusW(MemtoRegOut),
                             .RA(rm), .RB(rn), .RW(instruction[4:0]), .RegWr(regwrite), .Clk(CLK));
                             // both RB and RW get rn, dictated by RegWr
   //assign test = {reg2loc, alusrc, mem2reg, regwrite, memread, memwrite, branch, uncond_branch, aluctrl, signop, opcode};
   assign test = extimm;
   
   // SIGN EXTEND, in = opcode[25:0], out = extimm
   SignExtender my_sign_ext(.BusImm(extimm), .In26(instruction[25:0]), .Ctrl(signop), .movz(movz), .lsl(lsl));
   
   // ALUsource MUX control = alusrc, in = regoutB, extimm
   wire [63:0] ALUSource;
   assign ALUSource = (alusrc ? extimm : regoutB);
   
   // ALU in = ALUsource out, regoutA, aluctrl, out = [63:0] aluout, zero
   ALU my_ALU(.BusW(aluout), .BusA(regoutA), .BusB(ALUSource), .ALUCtrl(aluctrl), .Zero(zero));
   
   // DATA MEMORY
   wire [63:0] mem_read_data; // sent to memtoreg mux
   DataMemory my_data_mem(.ReadData(mem_read_data) , .Address(aluout) , .WriteData(regoutB),
                            .MemoryRead(memread) , .MemoryWrite(memwrite) , .Clock(CLK));
   

   //MemToReg Mux, control = mem2reg, in = aluout, mem_read_data, out = write_data
   assign MemtoRegOut = (mem2reg ? mem_read_data : aluout);
   
   // Next pc logic, in = [63:0] extimm, [63:0] currentpc, branch, uncond_branch, ALU zero
   NextPClogic my_pc_logic(.NextPC(nextpc), .CurrentPC(currentpc), .SignExtImm64(extimm),
                            .Branch(branch), .ALUZero(zero), .Uncondbranch(uncond_branch));
   
   


endmodule

