`timescale 1ns / 1ps

module HazardDetectUnit#(
        ADDRESS_W = 5)
        (
        input logic [ADDRESS_W-1:0] IfRS1,IfRS2,IdEXERd,
        input logic IdEXEMemRdEn,
        output logic stall
        );
        always_comb begin
        if (IdEXEMemRdEn && ((IdEXERd == IfRS1) || (IdEXERd == IfRS2)))
            stall = 1'b1;
        else
            stall = 1'b0;
        end
endmodule 