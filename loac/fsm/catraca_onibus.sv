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

  // Declaração dos estados
  parameter TRAVADA = 0, LIBERADA = 1;
  logic[2:0] estado_atual;

  // Declaração das entradas
  logic[1:0] carrega1, carrega2;
  logic[3:0] dinheiro1, dinheiro2;
  logic reset, passe1, passe2;

  // Declaração das saídas
  logic catraca;
  logic[6:0] conta;

  // Definição das entradas
  always_comb begin
    estado_atual <= TRAVADA;
    reset <= SWI[6];
    passe1 <= SWI[0];
    passe2 <= SWI[1];
    carrega1 <= SWI[3:2];
    carrega2 <= SWI[5:4];
    dinheiro1 <= 0;
    dinheiro2 <= 0;
    conta <= 0;
    catraca <= 0;
  end

  always_ff @(posedge clk_2 or posedge reset) begin
    if (reset) begin
      estado_atual = TRAVADA;
      conta = 0;
      catraca = 0;
      dinheiro1 = 0;
      dinheiro2 = 0;
    end
    else begin
      unique case(estado_atual)
        TRAVADA: begin
          if ((passe1 && !passe2) || (!passe1 && passe2)) begin
            if (passe1) begin
              if (dinheiro1 > 0) begin
                if (carrega1 == 0) begin
                  catraca = 1;
                  estado_atual = LIBERADA;
                  dinheiro1 = dinheiro1 - 1;
                end
                else begin
                  dinheiro1 = dinheiro1 + carrega1;
                  if (dinheiro1 > 5) begin
                    dinheiro1 = 5;
                  end
                end
              end
              else begin
                if (carrega1 > 0) begin
                  dinheiro1 = dinheiro1 + carrega1;
                  if (dinheiro1 > 5) begin
                    dinheiro1 = 5;
                  end
                end
              end
            end
            if (passe2) begin
              if (dinheiro2 > 0) begin
                if (carrega2 == 0) begin
                  catraca = 1;
                  estado_atual = LIBERADA;
                  dinheiro2 = dinheiro2 - 1;
                end
                else begin
                  dinheiro2 = dinheiro2 + carrega2;
                  if (dinheiro2 > 5) begin
                    dinheiro2 = 5;
                  end
                end
              end
              else begin
                if (carrega2 > 0) begin
                  dinheiro2 = dinheiro2 + carrega2;
                  if (dinheiro2 > 5) begin
                    dinheiro2 = 5;
                  end
                end
              end
            end
          end
          else begin
            catraca = 0;
            conta = 0;
          end
        end
        LIBERADA: begin
          catraca = 0;
          estado_atual = TRAVADA;
        end
      endcase
    end
  end

  // Saídas
  always_comb begin
    SEG[7] <= clk_2;

    LED[0] <= catraca;

    if (passe1 && !passe2) begin
      unique case(dinheiro1)
        0: SEG[6:0] <= 7'b0111111;
        1: SEG[6:0] <= 7'b0000110;
        2: SEG[6:0] <= 7'b1011011;
        3: SEG[6:0] <= 7'b1001111;
        4: SEG[6:0] <= 7'b1100110;
        5: SEG[6:0] <= 7'b1101101;
      endcase
    end
    else if (!passe1 && passe2) begin
      unique case(dinheiro2)
        0: SEG[6:0] <= 7'b0111111;
        1: SEG[6:0] <= 7'b0000110;
        2: SEG[6:0] <= 7'b1011011;
        3: SEG[6:0] <= 7'b1001111;
        4: SEG[6:0] <= 7'b1100110;
        5: SEG[6:0] <= 7'b1101101;
      endcase
    end
    else SEG[6:0] <= 7'b0000000;
  end

endmodule

