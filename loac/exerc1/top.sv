// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display

parameter NINSTR_BITS = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NINSTR_BITS-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin

  // QUESTAO 01
  LED[0] <= !SWI[7] & (!SWI[0] | !SWI[1] | !SWI[2]);
  LED[1] <= !SWI[7] & (!SWI[1] | !SWI[2]);

  // QUESTAO 02
  LED[6] <= !SWI[7] & (!SWI[3] & !SWI[4]);
  LED[7] <= !SWI[7] & (SWI[3] & SWI[4]);
  SEG[7] <= !SWI[7] & (!SWI[3] & SWI[4]);

  // QUESTAO 03
  SEG[0] <= SWI[7] & SWI[0] & (!SWI[1] | SWI[2]);

  // QUESTAO 04
  LED[2] <= SWI[7] & ((SWI[3] & SWI[4]) | (SWI[5] & SWI[6] & SWI[4]));

  end

endmodule
