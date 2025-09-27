`timescale 1ns/1ps

module tb_replicacao;

    reg clk = 0;
    reg [4:0] SW = 0;
    reg [7:0] rom [0:15];       // ROM 4x4 = 16 pixels
    reg [3:0] rom_addr = 0;
    wire [7:0] out_pixel;
    wire done;

    // Clock 10ns
    always #5 clk = ~clk;

    // Inicializa ROM de teste
    initial begin
        rom[0]=0;  rom[1]=1;  rom[2]=2;  rom[3]=3;
        rom[4]=4;  rom[5]=5;  rom[6]=6;  rom[7]=7;
        rom[8]=8;  rom[9]=9;  rom[10]=10; rom[11]=11;
        rom[12]=12; rom[13]=13; rom[14]=14; rom[15]=15;
    end

    // Sinal de entrada do pixel
    wire [7:0] in_pixel = rom[rom_addr];

    // Instancia o módulo escolha_algoritmo (somente replicação)
    escolha_algoritmo alg_inst (
        .clk(clk),
        .in_pixel(in_pixel),
        .SW(SW),
        .out_pixel(out_pixel),
        .done(done)
    );

    // Contador de endereço ROM: avança quando pixel replicado é consumido
    reg [3:0] linha = 0;
    reg [1:0] duplicado = 0;

    always @(posedge clk) begin
        if (!done) begin
            // Passa para próximo pixel apenas quando replicação 2x horizontal foi gerada
            if (duplicado == 1) begin
                duplicado <= 0;
                if (rom_addr % 4 == 3) begin
                    // Fim da linha, duplica linha para vertical
                    if (linha == 1) begin
                        linha <= 0;
                        rom_addr <= rom_addr + 1;
                    end else begin
                        linha <= linha + 1;
                    end
                end else begin
                    rom_addr <= rom_addr + 1;
                end
            end else begin
                duplicado <= duplicado + 1;
            end
        end
    end

    // Monitorar saída da replicação
    always @(posedge clk) begin
        if (out_pixel !== 8'bx)
            $display("Out pixel: %0d", out_pixel);
    end

    // Inicialização da simulação
    initial begin
        SW = 5'b00001; // SW[0]=1 ativa replicação
        #1000 $finish; // tempo suficiente para processar todos os pixels
    end

endmodule
