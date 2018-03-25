`timescale 1ns / 1ps

module ForwardingUnit#(
        ADDRESS_W = 5)
        (
        input logic [ADDRESS_W-1:0] RS1,RS2,EXEMEMWA,MEMWBWA,
        input logic EXEMERegWrtEn,MEMWBRegWrtEn,
        output logic [1:0] fwdsrc1,fwdsrc2
        );
        always_comb begin
            if(EXEMERegWrtEn && (EXEMEMWA!=5'b0) && (RS1==EXEMEMWA))
                fwdsrc1=2'b10; 
            else if(MEMWBRegWrtEn && (MEMWBWA!=5'b0) && (RS1==MEMWBWA))
                fwdsrc1=2'b01;
           else fwdsrc1=2'b00;
            
            if(EXEMERegWrtEn && (EXEMEMWA!=5'b0) && (RS2==EXEMEMWA))
                fwdsrc2=2'b10;
            else if(MEMWBRegWrtEn && (MEMWBWA!=5'b0) && (RS2==MEMWBWA))
                fwdsrc2=2'b01;
            else fwdsrc2 = 2'b00;
            end

endmodule