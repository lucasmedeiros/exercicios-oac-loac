/**
* 
* Questão: "Caixa Eletrônico"
* 
* Implemente o circuito de um caixa eletrônico. No reset, as
* saídas ficam em 0. Depois do usuário inserir o cartão no caixa,
* ele precisa colocar o código de acesso, formado pelos valores 1,
* 3 e 7. O usuário pode demorar quanto tempo quiser para
* iniciar a colocação do código e pode demorar o quanto tempo
* quiser de um valor para o próximo, mas precisa pelo menos
* demorar 1 ciclo de clock para cada valor. Depois do código
* estiver recebido corretamente, o dinheiro sai. A saída do
* dinheiro demora 1 ciclo de clock. Após três tentativas
* fracassadas de colocar o código correto, o cartão é destruído.
* Isso demora 1 ciclo de clock.
* ➔ Entradas: clock – 1 Hz, aparecendo em LED[7], reset –
* assíncrono em SWI[0], cartão – o usuário inseriu um cartão
* no caixa em SWI[1], código de acesso – valores de 0 à 7 em
* SWI[6:4]
* ➔ Saídas: dinheiro – saída de dinheiro em LED[0], destrói –
* destruição do cartão em LED[1]
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

  parameter INICIO = 0, INSERIU_CARTAO = 1, DIGITOU_1 = 2, DIGITOU_3 = 3,
            DIGITOU_7 = 4, OK = 5, DESTRUIU = 6;
  logic[2:0] estado_atual, codigo, contador;
  logic reset, cartao;
  logic dinheiro, destruiu;

  always_comb begin
    reset <= SWI[0];
    estado_atual = INICIO;
    codigo <= SWI[6:4];
    cartao = SWI[1];
    contador = 0;
    dinheiro = 0;
    destruiu = 0;
  end

  always_ff @(posedge clk_2 or posedge reset) begin
    if (reset) begin
      estado_atual = INICIO;
      contador = 0;
      dinheiro = 0;
      destruiu = 0;
    end
    else begin
      unique case(estado_atual)
        INICIO: begin
          if (contador >= 3) begin
            estado_atual = DESTRUIU;
          end
          else begin
            if (cartao) begin
              estado_atual = INSERIU_CARTAO;
            end
          end
        end
        INSERIU_CARTAO: begin
          if (contador >= 3) begin
            estado_atual = DESTRUIU;
          end
          else begin
            if (!cartao) begin
              estado_atual = INICIO;
            end
            else begin
              if (codigo != 0) begin
                if (codigo == 1) begin
                  estado_atual = DIGITOU_1;
                end
                else begin
                  contador = contador + 1;
                end
              end
            end
          end
        end
        DIGITOU_1: begin
          if (!cartao) begin
            estado_atual = INICIO;
          end
          else begin
            if (codigo != 1) begin
              if (codigo == 3) begin
                estado_atual = DIGITOU_3;
              end
              else begin
                contador = contador + 1;
                estado_atual = INSERIU_CARTAO;
              end
            end
          end
        end
        DIGITOU_3: begin
          if (!cartao) begin
            estado_atual = INICIO;
          end
          else begin
            if (codigo != 3) begin
              if (codigo == 7) begin
                estado_atual = DIGITOU_7;
              end
              else begin
                contador = contador + 1;
                estado_atual = INSERIU_CARTAO;
              end
            end
          end
        end
        DIGITOU_7: begin
          if (!cartao) begin
            estado_atual = INICIO;
          end
          else begin
            estado_atual = OK;
          end
        end
        OK: begin
          dinheiro = 1;
        end
        DESTRUIU: begin
          destruiu = 1;
        end
      endcase
    end
  end

  always_comb begin
    LED[7] <= clk_2;
    LED[0] <= dinheiro;
    LED[1] <= destruiu;

    unique case (estado_atual)
        INICIO: SEG <= 8'b00111111;
        INSERIU_CARTAO: SEG <= 8'b00000110;
        DIGITOU_1: SEG <= 8'b01011011;
        DIGITOU_3: SEG <= 8'b01001111;
        DIGITOU_7: SEG <= 8'b01100110;
        OK: SEG <= 8'b01101101;
        DESTRUIU: SEG <= 8'b01111101;
    endcase
  end

endmodule

