`timescale 1ns / 1ps

module NextPClogic_tb;
	//input
	reg [63:0] CurrentPC;
	reg [63:0] Immediate; // must be big enough for branch instruction
	reg Branch, ALUZero, Uncondbranch;
	// output
	wire [63:0] NextPC;
	
    NextPClogic uut(
        .NextPC(NextPC),
        .CurrentPC(CurrentPC),
        .SignExtImm64(Immediate),
        .Branch(Branch),
        .ALUZero(ALUZero), 
        .Uncondbranch(Uncondbranch));
        
    initial begin
        CurrentPC =  {64{1'b0}};
        
        // first test UNCOND BRANCH 4 --> PC should jump 16
        #10 {Immediate, Branch, ALUZero, Uncondbranch} = {64'h4, 1'b0, 1'b0, 1'b1}; 
        #90 $display("For Immediate = %d, Branch = %d, ALUZero = %d, and Uncondbranch = %d", Immediate, Branch, ALUZero, Uncondbranch);
        $display("Past PC = %d, New PC counter = %d", CurrentPC, NextPC);
        CurrentPC = NextPC;
        
        #10 {Immediate, Branch, ALUZero, Uncondbranch} = {64'h4, 1'b0, 1'b1, 1'b1}; 
        #90 $display("For Immediate = %d, Branch = %d, ALUZero = %d, and Uncondbranch = %d", Immediate, Branch, ALUZero, Uncondbranch);
        $display("Past PC = %d, New PC counter = %d", CurrentPC, NextPC);
        CurrentPC = NextPC;


        #10 {Immediate, Branch, ALUZero, Uncondbranch} = {64'h4, 1'b1, 1'b0, 1'b0}; 
        #90 $display("For Immediate = %d, Branch = %d, ALUZero = %d, and Uncondbranch = %d", Immediate, Branch, ALUZero, Uncondbranch);
        $display("Past PC = %d, New PC counter = %d", CurrentPC, NextPC);
        CurrentPC = NextPC;

        #10 {Immediate, Branch, ALUZero, Uncondbranch} = {64'h4, 1'b1, 1'b1, 1'b0}; 
        #90 $display("For Immediate = %d, Branch = %d, ALUZero = %d, and Uncondbranch = %d", Immediate, Branch, ALUZero, Uncondbranch);
        $display("Past PC = %d, New PC counter = %d", CurrentPC, NextPC);
        CurrentPC = NextPC;

        #10 {Immediate, Branch, ALUZero, Uncondbranch} = {64'h4, 1'b0, 1'b0, 1'b0}; 
        #90 $display("For Immediate = %d, Branch = %d, ALUZero = %d, and Uncondbranch = %d", Immediate, Branch, ALUZero, Uncondbranch);
        $display("Past PC = %d, New PC counter = %d", CurrentPC, NextPC);
        CurrentPC = NextPC;
        
        #10 {Immediate, Branch, ALUZero, Uncondbranch} = {64'h4, 1'b0, 1'b0, 1'b0}; 
        #90 $display("For Immediate = %d, Branch = %d, ALUZero = %d, and Uncondbranch = %d", Immediate, Branch, ALUZero, Uncondbranch);
        $display("Past PC = %d, New PC counter = %d", CurrentPC, NextPC);
        CurrentPC = NextPC;
        end
endmodule
