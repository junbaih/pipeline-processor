`timescale 1ns / 1ps

module IDEXERegFile#(
    parameter INS_ADDRESS = 9,
    parameter DATA_W = 32
   )
   (
   // Inputs 
   input logic clk, //clock
   input logic  rst,//synchronous reset; if it is asserted (rst=1), all registers are reseted to 0
   input logic [DATA_W-1:0] regData1In,regData2In,immIn,
   input logic [4:0] regSrc1In,regSrc2In,regDstIn,
   input logic [2:0] funct3In,
   input logic [6:0] funct7In,
   input logic [INS_ADDRESS-1:0] PCin,
   input logic [1:0] ALUopIn,
   input logic ALUsrcIn,MemWrtEnIn,MemRdEnIn,BranchIn,JUMPIn,JALRIn,RegWrtEnIn,
   input logic [2:0] RegWrtSrcIn,
   output logic [DATA_W-1:0] regData1Out,regData2Out,immOut,
   output logic [4:0] regSrc1Out,regSrc2Out,regDstOut,
   output logic [2:0] funct3Out,
   output logic [7:0] funct7Out,
   output logic [INS_ADDRESS-1:0] PCout,
   output logic [1:0]ALUopOut,
   output logic ALUsrcOut,MemWrtEnOut,MemRdEnOut,BranchOut,JUMPOut,JALROut,RegWrtEnOut, 
   output logic [2:0] RegWrtSrcOut
    
   );
   logic [DATA_W-1:0] sRegdata1,sRegdata2,simm;
   logic [4:0] sRegsrc1,sRegsrc2,sRegdst;
   logic [2:0] sfunct3;
   logic [6:0] sfunct7;
   logic [INS_ADDRESS-1:0] sPC;
   logic [1:0] sALUop;
   logic sALUsrc,sMemWrtEn,sMemRdEn,sBranch,sJUMP,sJALR,sRegWrtEn;
   logic [2:0] sRegWrtSrc;
    always @(negedge clk) begin
        if(rst==1'b1) begin
            sALUsrc<=0;
            sMemWrtEn<=0;
            sMemRdEn<=0;
            sBranch<=0;
            sJUMP<=0;
            sJALR<=0;
            sRegWrtEn<=0;
            end
        else begin
            sPC<=PCin;
            sRegdata1<=regData1In;
            sRegdata2<=regData2In;
            simm<=immIn;
            sRegsrc1<=regSrc1In;
            sRegsrc2<=regSrc2In;
            sRegdst<=regDstIn;
            sfunct3<=funct3In;
            sfunct7<=funct7In;
            sALUop<=ALUopIn;
            sALUsrc<=ALUsrcIn;
                        sMemWrtEn<=MemWrtEnIn;
                        sMemRdEn<=MemRdEnIn;
                        sBranch<=BranchIn;
                        sJUMP<=JUMPIn;
                        sJALR<=JALRIn;
                        sRegWrtEn<=RegWrtEnIn;
                        sRegWrtSrc<=RegWrtSrcIn;
            end
    end
    
    always @(posedge clk) begin
            if(rst==1'b1) begin
                ALUsrcOut<=0;
                MemWrtEnOut<=0;
                MemRdEnOut<=0;
                BranchOut<=0;
                JUMPOut<=0;
                JALROut<=0;
                RegWrtEnOut<=0;
                end
            else begin
                PCout<=sPC;
                regData1Out<=sRegdata1;
                regData2Out<=sRegdata2;
                immOut<=simm;
                regSrc1Out<=sRegsrc1;
                regSrc2Out<=sRegsrc2;
                regDstOut<=sRegdst;
                funct3Out<=sfunct3;
                funct7Out<=sfunct7;
                ALUopOut<=sALUop;
                ALUsrcOut<=sALUsrc;
                            MemWrtEnOut<=sMemWrtEn;
                            MemRdEnOut<=sMemRdEn;
                            BranchOut<=sBranch;
                            JUMPOut<=sJUMP;
                            JALROut<=sJALR;
                            RegWrtEnOut<=sRegWrtEn;
                            RegWrtSrcOut<=sRegWrtSrc;
                end
        end
        
  /*  
 assign regData1Out = sRegdata1;
 assign regData2Out = sRegdata2;
 assign immOut = simm;
 assign regSrc1Out = sRegsrc1;
 assign regSrc2Out = sRegsrc2;
 assign regDstOut =sRegdst;
 assign funct3Out = sfunct3;
 assign funct7Out = sfunct7;
 assign PCout = sPC;
 assign RegWrtSrcOut = sRegWrtSrc;
 assign   ALUsrcOut = sALUsrc;
 assign ALUopOut =sALUop;
 assign MemWrtEnOut = sMemWrtEn;
 assign MemRdEnOut = sMemRdEn;
 assign BranchOut = sBranch;
 assign JUMPOut = sJUMP;
 assign JALROut = sJALR;
 assign RegWrtEnOut = sRegWrtEn;
*/
endmodule