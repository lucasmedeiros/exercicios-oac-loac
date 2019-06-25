parameter NINSTR_BITS = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NINSTR_BITS-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  parameter DESLIGADO = 0, PAINEL_SOLAR = 1, REDE_ELETRICA = 2;
  logic [1:0] estado_atual;
  logic[2:0] contador_segundos;
  logic reset, sol;
  logic painel, rede, alternador;

  always_comb begin
    estado_atual = DESLIGADO;
    reset <= SWI[0];
    sol <= SWI[1];
    painel = 0;
    rede = 0;
    contador_segundos = 0;
    alternador = 0;
  end

  always_ff @(posedge clk_2 or posedge reset) begin
    if (reset) begin
      estado_atual = DESLIGADO;
      contador_segundos = 0;
      painel = 0;
      rede = 0;
      alternador = 0;
    end
    else begin
      unique case(estado_atual)
        DESLIGADO: begin
          if (sol) begin
            estado_atual = PAINEL_SOLAR;
            painel = 1;
          end
          else begin
            contador_segundos = contador_segundos + 1;
            if (contador_segundos > 3) begin
              contador_segundos = 4;
              estado_atual = REDE_ELETRICA;
              rede = 1;
            end
          end
        end
        PAINEL_SOLAR: begin
          contador_segundos = 0;
          if (sol) begin
            painel = alternador;
            alternador = alternador + 1;
          end
          else begin
            estado_atual = DESLIGADO;
            painel = 0;
          end
        end
        REDE_ELETRICA: begin
          contador_segundos = 0;
          if (sol) begin
            estado_atual = PAINEL_SOLAR;
            painel = 1;
            rede = 0;
          end
        end
      endcase
    end
  end

  always_comb begin
    LED[7] <= clk_2;
    LED[0] <= painel;
    LED[1] <= rede;

    LED[6:4] <= contador_segundos;

    unique case (estado_atual)
        DESLIGADO: SEG <= 8'b00111111;
        PAINEL_SOLAR: SEG <= 8'b00000110;
        REDE_ELETRICA: SEG <= 8'b01011011;
    endcase
  end

endmodule

