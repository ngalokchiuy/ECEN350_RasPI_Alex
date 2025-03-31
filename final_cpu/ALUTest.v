`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:02:47 03/05/2009
// Design Name:   ALU
// Module Name:   E:/350/Lab8/ALU/ALUTest.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 32
module ALUTest_v;

	task passTest;
		input [64:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %x should be %x", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

	// Inputs
	reg [63:0] BusA;
	reg [63:0] BusB;
	reg [3:0] ALUCtrl;
	reg [7:0] passed;

	// Outputs
	wire [63:0] BusW;
	wire Zero;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.BusW(BusW), 
		.Zero(Zero), 
		.BusA(BusA), 
		.BusB(BusB), 
		.ALUCtrl(ALUCtrl)
	);

	initial begin
		// Initialize Inputs
		BusA = 0;
		BusB = 0;
		ALUCtrl = 0;
		passed = 0;

                // Here is one example test vector, testing the ADD instruction:
         //AND
		{BusA, BusB, ALUCtrl} = {64'h0, 64'h0, 4'b0000}; #40; passTest({Zero, BusW}, 65'h10000000000000000 , "AND 0x0,0x0", passed);
		{BusA, BusB, ALUCtrl} = {64'h10, 64'h10, 4'b0000}; #40; passTest({Zero, BusW}, 65'h00000000000000010 , "AND 0x10,0x10", passed);
		{BusA, BusB, ALUCtrl} = {64'h4500, 64'h500, 4'b0000}; #40; passTest({Zero, BusW}, 65'h00000000000000500 , "AND 0x4500,0x500", passed);
		//{BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'b0000}; #40; passTest({Zero, BusW}, {(BusA & BusB) == 0, BusA & BusB}, "AND 0x1234,0xABCD0000", passed);

	    {BusA, BusB, ALUCtrl} = {64'h0, 64'h0, 4'b0001}; #40; passTest({Zero, BusW}, 65'h10000000000000000 , "OR 0x0,0x0", passed);
		{BusA, BusB, ALUCtrl} = {64'h3000, 64'h3000, 4'b0001}; #40; passTest({Zero, BusW}, 65'h00000000000003000 , "OR 0x3000,0x3000", passed);
		{BusA, BusB, ALUCtrl} = {64'h1200, 64'h34, 4'b0001}; #40; passTest({Zero, BusW}, 65'h00000000000001234 , "OR 0x1200,0x34", passed);
		
		{BusA, BusB, ALUCtrl} = {64'h0, 64'h0, 4'b0010}; #40; passTest({Zero, BusW}, 65'h10000000000000000 , "ADD 0x0,0x0", passed);
		{BusA, BusB, ALUCtrl} = {64'h280, 64'h2008, 4'b0010}; #40; passTest({Zero, BusW}, 65'h00000000000002288 , "ADD 0x280,0x2008", passed);
		{BusA, BusB, ALUCtrl} = {64'h0, 64'h4FF3, 4'b0010}; #40; passTest({Zero, BusW}, 65'h00000000000004ff3 , "ADD 0x0,0x4ff3", passed);
		
		{BusA, BusB, ALUCtrl} = {64'h0, 64'h0, 4'b0110}; #40; passTest({Zero, BusW}, 65'h10000000000000000 , "SUB 0x0,0x0", passed);
		{BusA, BusB, ALUCtrl} = {64'h4321, 64'h4321, 4'b0110}; #40; passTest({Zero, BusW}, 65'h10000000000000000 , "SUB 0x4321,0x4321", passed);
		{BusA, BusB, ALUCtrl} = {64'h1234, 64'h34, 4'b0110}; #40; passTest({Zero, BusW}, 65'h00000000000001200 , "SUB 0x1234,0x34", passed);
		
		{BusA, BusB, ALUCtrl} = {64'h0, 64'h0, 4'b0111}; #40; passTest({Zero, BusW}, 65'h10000000000000000 , "PASS 0x0,0x0", passed);
		{BusA, BusB, ALUCtrl} = {64'h3333, 64'h0, 4'b0111}; #40; passTest({Zero, BusW}, 65'h10000000000000000 , "PASS 0x3333,0x0", passed);
		{BusA, BusB, ALUCtrl} = {64'h4321, 64'h1234, 4'b0111}; #40; passTest({Zero, BusW}, 65'h00000000000001234 , "PASS 0x4321,0x1234", passed);
		

		allPassed(passed, 15);
	end
      
endmodule

