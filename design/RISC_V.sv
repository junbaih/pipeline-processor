`timescale 1ns / 1ps

module riscv #(
    parameter DATA_W = 32)
    (input logic clk, reset, // clock and reset signals
    output logic [31:0] WB_Data// The ALU_Result
    );

logic [6:0] opcode;
logic ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,Branch,JALR,Jump,PCtoReg;
logic [1:0] PCregsrc;

logic [1:0] ALUop,IDALUopOut;
logic [6:0] Funct7;
logic [2:0] Funct3;
logic [3:0] Operation;   //original 3 bits

    Controller c(opcode, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,Branch, ALUop,JALR,Jump,PCtoReg,PCregsrc);
    
    ALUController ac(IDALUopOut, Funct7, Funct3, Operation);

    Datapath dp(clk, reset, RegWrite , MemtoReg, ALUSrc , MemWrite, MemRead,Branch, JALR,Jump,PCtoReg,PCregsrc,ALUop, Operation,opcode, Funct7, Funct3,IDALUopOut, WB_Data);
        
endmodule
