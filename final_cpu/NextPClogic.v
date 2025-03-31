`timescale 1ns / 1ps

module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 
       input [63:0] CurrentPC, SignExtImm64; 
       input Branch, ALUZero, Uncondbranch; 
       output [63:0] NextPC; 
       
       // MOVE AMOUNT LOGIC_________________________________
       // get intermediate signals
       wire [63:0] pc_plus_4;
       wire [63:0] pc_plus_branch;
       //update both but use mux to choose last
       assign pc_plus_4 = CurrentPC + 4;
       assign pc_plus_branch = CurrentPC + (4*SignExtImm64); // SHIFT LEFT BY 2!!!! aka * 2^4
      
       // BRANCH LOGIC______________________________________
       // check condition for conditional branch
       wire ALUZero_and_Branch;
       assign ALUZero_and_Branch = ALUZero & Branch;
       // if unconditional move anyways
       wire any_branch; // send to mux to see if we branch
       assign any_branch = Uncondbranch | ALUZero_and_Branch; // if either are true, branch
       
       // MUX ______________________________________________
       // final "MUX" to update NextPC from any_branch
       // if any_branch == 1, branch, if any_branch = 0, pc + 4
       assign NextPC = (any_branch ? pc_plus_branch : pc_plus_4 ); 
endmodule