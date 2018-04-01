`timescale 1ns / 1ps
module WBRegFile#(
    parameter DM_ADDRESS = 9 ,
    parameter DATA_W = 32
   )
   (
   // Inputs 
   input logic clk, //clock
   input logic  rst,//synchronous reset; if it is asserted (rst=1), all registers are reseted to 0
   input logic [DATA_W-1:0] MemRdDataIn,MemALUresultIn,

   input logic RegWrtEnIn,
   input logic [2:0] RegWrtSrcIn,
   input logic [4:0] RegDstIn,
   input logic [DM_ADDRESS-1:0]PCin,
   input logic [DATA_W-1:0] immIn,
   output logic [DATA_W-1:0] MemRdDataOut,MemALUresultOut,

   output logic RegWrtEnOut, 
   output logic [2:0] RegWrtSrcOut,
   output logic [4:0] RegDstOut,
   output logic [DM_ADDRESS-1:0]PCOut,
   output logic [DATA_W-1:0] immOut
   );
   logic [DATA_W-1:0] sMemRdData,sMemALUresult,simm;
   logic [DM_ADDRESS-1:0] sPC;
   logic sRegWrtEn;
   logic [2:0] sRegWrtSrc;
   logic [4:0] sRegDst;
    always @(posedge clk) begin
        if(rst==1'b1) begin

            sRegWrtEn<=0;
            end
        else begin
            sMemRdData<=MemRdDataIn;
            sMemALUresult<=MemALUresultIn;
            sPC<=PCin;
                     simm<=immIn;
                        sRegWrtEn<=RegWrtEnIn;
                        sRegWrtSrc<=RegWrtSrcIn;
                        sRegDst<=RegDstIn;
            end
    end
    /*
    always @(posedge clk) begin
            if(rst==1'b1) begin
          
                RegWrtEnOut<=0;
                end
            else begin

                MemRdDataOut<=sMemRdData;
                MemALUresultOut<=sMemALUresult;
                PCOut<=sPC;
                          
          
                            RegWrtEnOut<=sRegWrtEn;
                            RegWrtSrcOut<=sRegWrtSrc;
                            RegDstOut<=sRegDst;
                end
        end
*/
assign   MemRdDataOut=sMemRdData;
    assign          MemALUresultOut=sMemALUresult;
     assign         PCOut=sPC;
                        
        assign immOut = simm;
   assign                       RegWrtEnOut=sRegWrtEn;
     assign                     RegWrtSrcOut=sRegWrtSrc;
       assign                   RegDstOut=sRegDst;
endmodule