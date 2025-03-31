`timescale 1ns / 1ps

module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
    output [63:0] BusA;
    output [63:0] BusB;
    input [63:0] BusW;
    input [4:0] RA, RB, RW; // must describe 32 64-bit  registers
    input RegWr; // single bit flag
    input Clk;
    reg [63:0] registers [31:0]; //64 bit wide, 32 registers
    // REG 31 MUST ALWAYS READ 0
    
    //assign #2 BusA =  registers[RA]; // 2 second delay for read
    assign #2 BusA = ((RA != 5'd31) ? registers[RA] : 64'b0);
    //assign #2 BusB = registers[RB];
    assign #2 BusB = ((RB != 5'd31) ? registers[RB] : 64'b0);
     
    always @ (negedge Clk) begin // assign on negative clock edge only
        registers[31] = 32'b0;
        if(RegWr & RW != 31) // cannot overwrite XZR
            registers[RW] <= #3 BusW; // 3 second write delay (HAPPENS AFTER READ)
    end
endmodule
