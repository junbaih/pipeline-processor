`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Datapath
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

module Datapath #(
    parameter PC_W = 9, // Program Counter
    parameter INS_W = 32, // Instruction Width
    parameter RF_ADDRESS = 5, // Register File Address
    parameter DATA_W = 32, // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter ALU_CC_W = 4 // ALU Control Code Width, original = 4
    )(
    input logic clk , reset , // global clock
                              // reset , sets the PC to zero
    RegWrite , MemtoReg ,     // Register file writing enable   // Memory or ALU MUX
    ALUsrc , MemWrite ,       // Register file or Immediate MUX // Memroy Writing Enable
    MemRead, Branch , 
     JALR,Jump,PCtoReg,
    input logic [1:0] PCregSrc,              // Memroy Reading Enable  //Branch CC signal
    input logic [1:0] CCALUopIn,
    input logic [ ALU_CC_W -1:0] ALU_CC, // ALU Control Code ( input of the ALU )
    output logic [6:0] opcode,
    output logic [6:0] Funct7,
    output logic [2:0] Funct3,
    output logic [1:0] IDALUopOut,
    output logic [DATA_W-1:0] WB_Data //ALU_Result
    );

logic [PC_W-1:0] PC, PCPlus4, PCPlusN,PCPlusF,PCF,PCJ,PCstl;  // PCPlusF = mux(PCPlus4,PCPlusN)  PCF = mux(PCPlusF,JumpPC)
logic [INS_W-1:0] Instr;
logic [DATA_W-1:0] Result,DataWrtReg,PCResult,PCf,PCr,PCPN,jReg;
logic [DATA_W-1:0] Reg1, Reg2;
logic [DATA_W-1:0] ReadData,tempReadData;
logic [DATA_W-1:0] SrcB, ALUResult;
logic [DATA_W-1:0] ExtImm;
logic Zero,cZero;
logic Brcc;
////IDEXE declare
logic IDALUsrcIn,IDMemWrtEnIn,IDMemRdEnIn,IDBranchIn,IDJUMPIn,IDJALRIn,IDRegWrtEnIn;
logic [2:0] funct3out;
logic [6:0] funct7out;   
logic [DATA_W-1:0] IDregData1Out,IDregData2Out,IDimmOut;
logic [4:0] IDregSrc1Out,IDregSrc2Out,IDregDstOut;
logic [PC_W-1:0] IDPCout;
//logic [3:0] IDALUopOut;
logic IDALUsrcOut,IDMemWrtEnOut,IDMemRdEnOut,IDBranchOut,IDJUMPOut,IDJALROut,IDRegWrtEnOut; 
logic [2:0] IDRegWrtSrcOut;
//////////////////EXEMEM declare
logic [DATA_W-1:0] MemWrtDataOut,MemWrtAddressOut,MemImmOut;
logic [2:0] Memfunct3Out;
logic [6:0] Memfunct7Out;
logic [4:0] MemRegDstOut;
logic [PC_W-1:0] MemPCout;
logic MMemWrtEnOut,MMemRdEnOut,MemBranchOut,MemZeroOut,MemJUMPOut,MemJALROut,MemRegWrtEnOut; 
logic [2:0] MemRegWrtSrcOut;


////////////WB REG declare
logic [DATA_W-1:0] WBMemRdDataOut,WBALUresultOut;

logic WBRegWrtEnOut;
logic [2:0] WBRegWrtSrcOut;
logic [4:0] WBRegDstOut;
logic [PC_W-1:0] WBPC;
logic [DATA_W-1:0] WBimm;
////////////////////////
logic stall;
// next PC
    adder #(9) pcadd (PC, 9'b100, PCPlus4);
   // mux2 #(9) pcstal (PCF,PC,stall,PCstl);
    always_comb  begin
    if(stall)
        PCstl = PC;
    else
        PCstl = PCF;
        //PCstl = PC+9'b100;
    end
    flopr #(9) pcreg(clk, reset, PCstl, PC);

 //Instruction memory
    instructionmemory instr_mem (PC, Instr);
    
   assign opcode = IfInstout[6:0];
    assign Funct7 = funct7out;
    assign Funct3 = funct3out;
   ////////////////////////////// IF
logic [PC_W-1:0] IfPCout ;  
logic [INS_W-1:0] IfInstout;
logic IFflash;
assign IFflash = reset | Jump|Brcc;
    IFRegFile IfReg(clk,IFflash,Instr,PC,IfInstout,IfPCout);
// //Register File
/*
    assign PCf = {23'b0,PCPlus4};
    mux2 #(32) pcsrc0(PCf,PCPN,PCregSrc[0],PCr); 
    mux2 #(32) pcsrc1(PCr,ExtImm,PCregSrc[1],PCResult);
    mux2 #(32) regwrtmux(DataWrtReg,PCResult,PCtoReg,Result);
*/
    always_comb begin
    Result = WBALUresultOut;
    case(WBRegWrtSrcOut)
    3'b100:
        Result = WBMemRdDataOut;
    3'b000:
        Result = WBALUresultOut;
    3'b011:
        Result = WBPC+3'b100 ;
    3'b001:
        Result = WBPC+WBimm;
    3'b010:
        Result = WBimm;
    default:
        Result = WBALUresultOut;
    endcase
    end
    RegFile rf(clk, reset, WBRegWrtEnOut, WBRegDstOut, IfInstout[19:15], IfInstout[24:20],
            Result,IfInstout[14:12],IfInstout[6:0], Reg1, Reg2);
            
 logic [1:0] fwbr1,fwbr2;
 logic [DATA_W-1:0] Breg1,Breg2;
      ///comparator 
      ForwardingUnit fwdBranch(IfInstout[19:15], IfInstout[24:20],IDregDstOut,MemRegDstOut,IDRegWrtEnOut,MemRegWrtEnOut,fwbr1,fwbr2);
          mux3 #(32) fwdbrmux1(Reg1,MemWrtAddressOut,ALUResult,fwbr1,Breg1);
           mux3 #(32) fwdbrmux2(Reg2,MemWrtAddressOut,ALUResult,fwbr2,Breg2);
      always_comb begin
        if(Branch) begin
            cZero = 1'b0;
            case(IfInstout[14:12])
            3'b000:
                cZero = (Breg1==Breg2);
            3'b001:               //BNE
                cZero = (Breg1!=Breg2);
            3'b100:
                cZero = ($signed(Breg1)<$signed(Breg2));
            3'b101:
                cZero = ($signed(Breg1)>=$signed(Breg2));
            3'b110:
                cZero = (Breg1<Breg2);
            3'b111:
                cZero = (Breg1>=Breg2);
            default:
                cZero = 1'b0;
        endcase
        end
      end
//////////////////         
HazardDetectUnit HazardUnit(IfInstout[19:15], IfInstout[24:20],IDregDstOut,IDMemRdEnOut,stall);
/*
logic [2:0] funct3out;
logic [6:0] funct7out;   
logic [DATA_W-1:0] IDregData1Out,IDregData2Out,IDimmOut;
logic [4:0] IDregSrc1Out,IDregSrc2Out,IDregDstOut;
logic [PC_W-1:0] IDPCout;
logic [3:0] IDALUopOut;
logic IDALUsrcOut,IDMemWrtEnOut,IDMemRdEnOut,IDBranchOut,IDJUMPOut,IDJALROut,IDRegWrtEnOut; 
logic [2:0] IDRegWrtSrcOut;*/
   always_comb begin
   if(stall) begin
        IDALUsrcIn = 1'b0;
        IDMemWrtEnIn = 1'b0;
        IDMemRdEnIn = 1'b0;
        IDBranchIn=1'b0;
        IDJUMPIn=1'b0;
        IDJALRIn=1'b0;
        IDRegWrtEnIn=1'b0;
   end
   else begin
   IDALUsrcIn = ALUsrc;
   IDMemWrtEnIn = MemWrite;
   IDMemRdEnIn = MemRead;
   IDBranchIn=Branch;
   IDJUMPIn=Jump;
   IDJALRIn=JALR;
   IDRegWrtEnIn=RegWrite;
   end
   end


   IDEXERegFile IdExeReg(clk,reset,Reg1,Reg2,ExtImm,IfInstout[19:15], IfInstout[24:20],IfInstout[11:7],IfInstout[14:12],IfInstout[31:25],
                IfPCout,CCALUopIn,IDALUsrcIn,IDMemWrtEnIn,IDMemRdEnIn,IDBranchIn,IDJUMPIn,IDJALRIn,IDRegWrtEnIn,{MemtoReg,PCregSrc}, IDregData1Out,IDregData2Out,
                IDimmOut,IDregSrc1Out,IDregSrc2Out,IDregDstOut,funct3out,funct7out,IDPCout,IDALUopOut,IDALUsrcOut,IDMemWrtEnOut,IDMemRdEnOut,IDBranchOut,IDJUMPOut,IDJALROut,
                IDRegWrtEnOut,IDRegWrtSrcOut);
   
    //Reg WB        
   // mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, DataWrtReg);  
   
    
    logic [31:0] tempv;     
    adder #(32) jpaddr (Reg1, ExtImm,tempv);
    
    assign jReg = {tempv[31:1],1'b0};
    mux2 #(9) jalpcsrc(PCPlusN,tempv[8:0],JALR,PCJ);
    
    
           
//// sign extend
    imm_Gen Ext_Imm (IfInstout,ExtImm);

//// ALU
logic [1:0] fwsrc1,fwsrc2;
logic [31:0] fwresult1,fwresult2;
    ForwardingUnit fwdUnit(IDregSrc1Out,IDregSrc2Out,MemRegDstOut,WBRegDstOut,MemRegWrtEnOut, WBRegWrtEnOut,fwsrc1,fwsrc2);
    mux3 #(32) fwdmux1(IDregData1Out,Result,MemWrtAddressOut,fwsrc1,fwresult1);
     mux3 #(32) fwdmux2(IDregData2Out,Result,MemWrtAddressOut,fwsrc2,fwresult2);
    mux2 #(32) srcbmux(fwresult2,  IDimmOut, IDALUsrcOut, SrcB);  /////// need to change
    alu alu_module(fwresult1, SrcB, ALU_CC, ALUResult,Zero);   //////////////need to change
    
    assign WB_Data = Result;
//////////////////////////EXEMemRegFile

MemRegFile MemRegF(clk,reset,IDregData2Out,ALUResult,IDimmOut,funct3out,funct7out,IDPCout,IDMemWrtEnOut,IDMemRdEnOut,IDBranchOut,Zero,IDJUMPOut,IDJALROut,
                IDRegWrtEnOut,IDRegWrtSrcOut,IDregDstOut,MemWrtDataOut,MemWrtAddressOut,MemImmOut,Memfunct3Out,Memfunct7Out,MemPCout,MMemWrtEnOut,MMemRdEnOut,MemBranchOut,
                MemZeroOut,MemJUMPOut,MemJALROut,MemRegWrtEnOut, MemRegWrtSrcOut,MemRegDstOut);


/// Branch control

    assign Brcc = cZero && Branch;
    //adder #(9) pcaddn (PC, ExtImm[8:0], PCPlusN);
    adder #(32) pcaddn ({23'b0,IfPCout}, ExtImm, PCPN);
    assign PCPlusN = PCPN[8:0];
    mux2 #(9) pcmux(PCPlus4,PCPlusN,Brcc,PCPlusF);
/// Jump control
    mux2 #(9) pcBorJ(PCPlusF,PCJ,Jump,PCF);
        
////// Data memory 
	datamemory data_mem (clk, MMemRdEnOut,MMemWrtEnOut, MemWrtAddressOut[DM_ADDRESS-1:0], MemWrtDataOut, tempReadData);
always_comb begin
    ReadData = tempReadData;
    case(Memfunct3Out)
	3'b000:
        ReadData = {tempReadData[31]?{24{1'b1}}:24'b0,tempReadData[7:0]};
    3'b001:
        ReadData = {tempReadData[31]?{16{1'b1}}:16'b0,tempReadData[15:0]};
    3'b010:
        ReadData = tempReadData;
    3'b100:
        ReadData = {24'b0,tempReadData[7:0]};
    3'b101:
        ReadData = {16'b0,tempReadData[15:0]};
    default:
        ReadData = tempReadData;
    endcase
end
///////////////////////// WB reg

WBRegFile WBreg(clk,reset,ReadData,MemWrtAddressOut,MemRegWrtEnOut, MemRegWrtSrcOut,MemRegDstOut,MemPCout,MemImmOut,WBMemRdDataOut,WBALUresultOut,
            WBRegWrtEnOut,WBRegWrtSrcOut,WBRegDstOut,WBPC,WBimm);
     
endmodule