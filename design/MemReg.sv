`timescale 1ns / 1ps
module MemRegFile#(
    parameter INS_ADDRESS = 9,
    parameter DATA_W = 32
   )
   (
   // Inputs 
   input logic clk, //clock
   input logic  rst,//synchronous reset; if it is asserted (rst=1), all registers are reseted to 0
   input logic [DATA_W-1:0] MemWrtDataIn,MemWrtAddressIn,immIn,
   input logic [2:0] funct3In,
   input logic [6:0] funct7In,
   input logic [INS_ADDRESS-1:0] PCin,
   input logic MemWrtEnIn,MemRdEnIn,BranchIn,ZeroIn,JUMPIn,JALRIn,RegWrtEnIn,
   input logic [2:0] RegWrtSrcIn,
   input logic [4:0] RegDstIn,
   output logic [DATA_W-1:0] MemWrtDataOut,MemWrtAddressOut,immOut,
   output logic [2:0] funct3Out,
   output logic [6:0] funct7Out,
   output logic [INS_ADDRESS-1:0] PCout,
   output logic MemWrtEnOut,MemRdEnOut,BranchOut,ZeroOut,JUMPOut,JALROut,RegWrtEnOut, 
   output logic [2:0] RegWrtSrcOut,
   output logic [4:0] RegDstOut
   );
   logic [DATA_W-1:0] sMemWrtData,sMemWrtAddress,simm;
   logic [2:0] sfunct3;
   logic [6:0] sfunct7;
   logic [4:0] sRegDst;
   logic [INS_ADDRESS-1:0] sPC;
   logic sMemWrtEn,sMemRdEn,sBranch,sZero,sJUMP,sJALR,sRegWrtEn;
   logic [2:0] sRegWrtSrc;
    always @(posedge clk) begin
        if(rst==1'b1) begin
            sMemWrtEn<=0;
            sMemRdEn<=0;
            sBranch<=0;
            sZero<=0;
            sJUMP<=0;
            sJALR<=0;
            sRegWrtEn<=0;
            end
        else begin
            sPC<=PCin;
            sMemWrtData<=MemWrtDataIn;
            sMemWrtAddress<=MemWrtAddressIn;
            simm<=immIn;
            sfunct3<=funct3In;
            sfunct7<=funct7In;
            sRegDst<=RegDstIn;
                        sMemWrtEn<=MemWrtEnIn;
                        sMemRdEn<=MemRdEnIn;
                        sBranch<=BranchIn;
                        sZero<=ZeroIn;
                        sJUMP<=JUMPIn;
                        sJALR<=JALRIn;
                        sRegWrtEn<=RegWrtEnIn;
                        sRegWrtSrc<=RegWrtSrcIn;
            end
    end
    /*
    always @(posedge clk) begin
            if(rst==1'b1) begin
                MemWrtEnOut<=0;
                MemRdEnOut<=0;
                BranchOut<=0;
                ZeroOut<=0;
                JUMPOut<=0;
                JALROut<=0;
                RegWrtEnOut<=0;
                end
            else begin
                PCout<=sPC;
                MemWrtDataOut<=sMemWrtData;
                MemWrtAddressOut<=sMemWrtAddress;
                immOut<=simm;
                funct3Out<=sfunct3;
                funct7Out<=sfunct7;
                RegDstOut<=sRegDst;
                            MemWrtEnOut<=sMemWrtEn;
                            MemRdEnOut<=sMemRdEn;
                            BranchOut<=sBranch;
                            ZeroOut<=sZero;
                            JUMPOut<=sJUMP;
                            JALROut<=sJALR;
                            RegWrtEnOut<=sRegWrtEn;
                            RegWrtSrcOut<=sRegWrtSrc;
                end
        end
*/
   assign             PCout=sPC;
 assign MemWrtDataOut=sMemWrtData;
 assign MemWrtAddressOut=sMemWrtAddress;
 assign immOut=simm;
 assign funct3Out=sfunct3;
 assign funct7Out=sfunct7;
 assign RegDstOut=sRegDst;
 assign MemWrtEnOut=sMemWrtEn;
 assign MemRdEnOut=sMemRdEn;
 assign BranchOut=sBranch;
 assign ZeroOut=sZero;
 assign JUMPOut=sJUMP;
 assign JALROut=sJALR;
 assign            RegWrtEnOut=sRegWrtEn;
 assign            RegWrtSrcOut=sRegWrtSrc;
endmodule