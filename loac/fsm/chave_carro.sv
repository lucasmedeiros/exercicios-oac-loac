/**
*
* Questão: Chave do carro
*
* Os carros contemporâneos possuem um dispositivo de segurança que identifica o código presente na chave utilizada para ligá-los.
* Caso o código da chave não seja o mesmo que está codificado no computador de bordo, o carro não liga. Isso é feito, grosso modo,
* com um chip na chave que responde ao computador de bordo, informando o seu código, quando solicitado. Este chip é, na verdade,
* um circuito sequencial. Construa este circuito sequencial, considerando uma chave codificada com o código de 4 bits “1011”. O
* circuito sequencial possui um sinal de entrada a e um sinal de saída r. O sinal a vale “1” quando o código está sendo requisitado
* pelo computador de bordo do carro. Quando isto ocorrer, o circuito sequencial envia o código (“1011”, no caso) pela saída r de
* maneira serial (i.e., um bit por clock/estado), começando pelo bit menos significativo (LSB).
*
*
* Aluno: Lucas de Medeiros Nunes Fernandes
* Matrícula: 117110210
*/

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

  parameter INICIO = 0, ESTADO_A = 1, ESTADO_B = 2, ESTADO_C = 3, ESTADO_D = 4;
  logic[2:0] estado_atual;
  logic reset, entrada, ok;
  always_comb begin
    reset <= SWI[0];
    entrada <= SWI[1];
    estado_atual = INICIO;
    ok = 0;
  end

  always_ff @(posedge clk_2 or posedge reset) begin
    if (reset) begin
      estado_atual = INICIO;
      ok = 0;
    end
    else begin
      unique case (estado_atual)
        INICIO: begin
          if (entrada == 1) begin
            estado_atual = ESTADO_A;
          end
          else estado_atual = INICIO;
        end
        ESTADO_A: begin
          if (entrada == 0) begin
            estado_atual = ESTADO_B;
          end
          else estado_atual = INICIO;
        end
        ESTADO_B: begin
          if (entrada == 1) begin
            estado_atual = ESTADO_C;
          end
          else estado_atual = INICIO;
        end
        ESTADO_C: begin
          if (entrada == 1) begin
            estado_atual = ESTADO_D;
            ok = 1;
          end
          else estado_atual = INICIO;
        end
        ESTADO_D: begin
          if (entrada == 0) begin
            estado_atual = INICIO;
            ok = 0;
          end
        end
      endcase
    end
  end

  always_comb begin
    LED[7] <= clk_2;
    LED[0] <= ok;
    
    unique case(estado_atual)
      INICIO: SEG <= 8'b00111111;
      ESTADO_A: SEG <= 8'b01110111;
      ESTADO_B: SEG <= 8'b01111100;
      ESTADO_C: SEG <= 8'b00111001;
      ESTADO_D: SEG <= 8'b01011110;
    endcase
  end

endmodule

