module replicação_pixel #(
    parameter LARGURA_IMAGEM = 4,
    parameter LARGURA_PIXEL  = 8,
    parameter LARGURA_MAXIMA = 320
)(
    input wire clk,
    input wire resetn,

    input wire pixel_in_valid,
    input wire [LARGURA_PIXEL-1:0] pixel_in,

    output reg pixel_out_valid,
    output reg [LARGURA_PIXEL-1:0] pixel_out
);

    // Verificação de parâmetros
    initial begin
        if (LARGURA_IMAGEM > LARGURA_MAXIMA) begin
            $display("Erro: LARGURA_IMAGEM (%0d) exceeds LARGURA_MAXIMA (%0d).", LARGURA_IMAGEM, LARGURA_MAXIMA);
            $finish;
        end
    end

    localparam LARGURA_SAIDA = LARGURA_IMAGEM * 2;
    
    // Definição dos estados da máquina de estados (FSM)
    localparam [1:0] S_RECEBENDO = 2'b00,
                     S_ESPERA    = 2'b01, // Estado de espera para garantir a escrita
                     S_ENVIANDO  = 2'b10;

    reg [1:0] estado;

    // Registrador para armazenar a linha de pixels
    reg [LARGURA_PIXEL-1:0] linha_expandida [0:LARGURA_SAIDA-1];

    // Contadores
    reg [$clog2(LARGURA_IMAGEM)-1:0] x_in_count;
    reg [$clog2(LARGURA_SAIDA)-1:0]  x_out_count;
    reg                             row_out_count;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            // Reset de todos os registradores e estado inicial
            estado <= S_RECEBENDO;
            x_in_count <= 0;
            x_out_count <= 0;
            row_out_count <= 0;
            pixel_out_valid <= 1'b0;
            pixel_out <= 0;
        end else begin
            // Lógica da máquina de estados
            case (estado)
                S_RECEBENDO: begin
                    pixel_out_valid <= 1'b0;
                    if (pixel_in_valid) begin
                        // Escreve o pixel duplicado na memória
                        linha_expandida[x_in_count * 2]     <= pixel_in;
                        linha_expandida[x_in_count * 2 + 1] <= pixel_in;

                        if (x_in_count == LARGURA_IMAGEM - 1) begin
                            x_in_count <= 0;
                            estado <= S_ESPERA; // Linha completa, vai para o estado de espera
                        end else begin
                            x_in_count <= x_in_count + 1;
                        end
                    end
                end

                S_ESPERA: begin
                    // Este estado dura 1 ciclo para garantir que a escrita finalizou
                    pixel_out_valid <= 1'b0;
                    estado <= S_ENVIANDO;
                end

                S_ENVIANDO: begin
                    pixel_out_valid <= 1'b1;
                    pixel_out <= linha_expandida[x_out_count];

                    if (x_out_count == LARGURA_SAIDA - 1) begin
                        x_out_count <= 0; // Fim da linha, reseta o contador de saída
                        if (row_out_count == 1'b1) begin
                            // Segunda linha enviada, volta a receber
                            row_out_count <= 1'b0;
                            estado <= S_RECEBENDO;
                        end else begin
                            // Primeira linha enviada, prepara para a segunda
                            row_out_count <= 1'b1;
                        end
                    end else begin
                        x_out_count <= x_out_count + 1;
                    end
                end

                default: begin
                    estado <= S_RECEBENDO;
                end
            endcase
        end
    end

endmodule
