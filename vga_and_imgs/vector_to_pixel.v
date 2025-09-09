module vector_to_pixels (
    input wire clk,
    input wire reset,
    input wire [47:0] vec_48,   // vetor binarizado
    input wire [9:0] x,         // coordenada atual do VGA
    input wire [9:0] y,         // coordenada atual do VGA
    output reg [7:0] color_out  // cor do pixel
);

    // Cada bloco tem 20x20 pixels
    wire [2:0] block_x = x / 20;   // qual coluna de bloco (0..7)
    wire [2:0] block_y = y / 20;   // qual linha de bloco (0..5)
    wire [5:0] block_index = block_y * 8 + block_x; // 0..47

    always @(*) begin
        if (x < 160 && y < 120) begin
            if (vec_48[block_index])
                color_out = 8'b111_111_11; // branco (RRRGGGBB)
            else
                color_out = 8'b000_000_00; // preto
        end else begin
            color_out = 8'b000_000_00;     // fora da área → preto
        end
    end

endmodule



