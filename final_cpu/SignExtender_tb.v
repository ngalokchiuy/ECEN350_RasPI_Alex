`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 08:48:09 AM
// Design Name: 
// Module Name: SignExtender_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define STRLEN 15
module SignExtender_tb;

	task passTest;
		input [63:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %d should be %d", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask
	
	// Inputs
	reg [25:0] in;
	reg [1:0] Ctrl; // control input
	reg [7:0] passed;

	// Outputs
	wire [63:0] out;
	reg [63:0] expected_out;

	// Instantiate the Unit Under Test (UUT)
	SignExtender uut (
		.In26(in),
		.Ctrl(Ctrl),
		.BusImm(out)
	);

	initial begin
		// Initialize Inputs
		in = 0;
		in[4] = 4'b1111;
		passed = 0;

		// Add stimulus here
		//I -type
		// pos, add/sub
		#90; in = 26'h111A55; in[21] = 1'b0 ; Ctrl = 2'b00 ; expected_out = {52'b0, in[21:10]}; // set expected value
		#10; passTest(out, expected_out, "pos I", passed); 
		//neg, add/sub
		#90; in = 26'h111A55; in[21] = 1'b1 ; Ctrl = 2'b00 ; expected_out = {52'b0, in[21:10]}; // set expected value
		#10; passTest(out, expected_out, "neg I", passed);
		
		//D -type
		// pos
		#90; in = 26'h111A55; in[20] = 1'b0 ; Ctrl = 2'b01 ; expected_out = {{55{in[20]}}, in[20:12]}; // set expected value
		#10; passTest(out, expected_out, "pos D", passed); 
		//neg
		#90; in = 26'h111A55; in[20] = 1'b1 ; Ctrl = 2'b01 ; expected_out = {{55{in[20]}}, in[20:12]}; // set expected value
		#10; passTest(out, expected_out, "neg D", passed);
		
				//B-type
		// pos
		#90; in = 26'h111A55; in[25] = 1'b0 ; Ctrl = 2'b10 ; expected_out = {{38{in[25]}}, in}; // set expected value
		#10; passTest(out, expected_out, "pos B", passed); 
		//neg
		#90; in = 26'h111A55; in[25] = 1'b1 ; Ctrl = 2'b10 ; expected_out = {{38{in[25]}}, in}; // set expected value
		#10; passTest(out, expected_out, "neg B", passed);
		
				//CB -type
		// pos
		#90; in = 26'h111A55; in[23] = 1'b0 ; Ctrl = 2'b11 ; expected_out = {{45{in[23]}}, in[23:5]}; // set expected value
		#10; passTest(out, expected_out, "pos CB", passed); 
		//neg
		#90; in = 26'h111A55; in[23] = 1'b1 ; Ctrl = 2'b11 ; expected_out = {{45{in[23]}}, in[23:5]}; // set expected value
		#10; passTest(out, expected_out, "neg CB", passed);
	
		
		allPassed(passed, 8);

	end
      
endmodule