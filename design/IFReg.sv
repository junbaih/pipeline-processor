`timescale 1ns / 1ps

module IFRegFile#(
    parameter INS_ADDRESS = 9,
    parameter INS_W = 32
   )
   (
   // Inputs 
   input logic clk, //clock
   input logic  rst,//synchronous reset; if it is asserted (rst=1), all registers are reseted to 0
   input logic [INS_W-1:0] INSTin,
   input logic [INS_ADDRESS-1:0] PCin,
   output logic [INS_W-1:0] INSTout,
   output logic [INS_ADDRESS-1:0] PCout
    
   );
logic [INS_W-1:0] sINST;
logic [INS_ADDRESS-1:0] sPC;
    always @(posedge clk) begin
        if(rst==1'b1) begin
            sPC<=0;
            sINST<=0;
            end
        else begin
            sPC<=PCin;
            sINST<=INSTin;
            end
    end
    /*
    always_ff @(posedge clk) begin
         if(rst==1'b1) begin
            PCout<=0;
            INSTout<=0;
        end
    else begin
            PCout<=sPC;
            INSTout<=sINST;
        end       
    end
    */
assign PCout = sPC;
assign INSTout = sINST; 
endmodule