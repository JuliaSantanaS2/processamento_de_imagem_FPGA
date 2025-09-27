/**********************************************************************************
* * Módulo: main
*
* Descrição: 
* Este é o módulo de topo que integra um sistema de processamento de imagens 
* em uma FPGA. Ele gerencia a leitura de uma imagem de uma ROM, o envio para 
* um coprocessador que aplica algoritmos de redimensionamento (zoom in/out) 
* selecionados por chaves (SW), o armazenamento da imagem processada em uma RAM
* e, por fim, a exibição do resultado em um monitor VGA. O módulo também 
* controla a geração de clocks, a lógica de reset e a interface com o usuário
* através de botões e displays de 7 segmentos.
*
**********************************************************************************/
module main (
    input  wire [9:2] SW,
    input  wire [1:0] boton,
    input  wire clk_50,
    output wire [9:0] LEDR,
    output wire hsync,
    output wire vsync,
    output wire [7:0] red,
    output wire [7:0] green,
    output wire [7:0] blue,
    output wire sync,
    output wire clk,
    output wire [6:0] hex0,
	 output wire [6:0] hex1,
	 output wire [6:0] hex2,
	 output wire [6:0] hex3,
	 output wire [6:0] hex4,
	 output wire [6:0] hex5,
    output wire blank
);

    assign LEDR = SW;
    reg clk_25_reg = 0;
    
    always @(posedge clk_50) begin
        clk_25_reg <= ~clk_25_reg;
    end
    
    reg [7:0] sw_prev = 0;         
    reg       auto_reset_flag = 0; 
    reg [3:0] reset_counter = 0;   
    
    wire sw_changed = (sw_prev != SW[8:2]);
    
    always @(posedge clk_25_reg) begin
        sw_prev <= SW[8:2]; 
        
        if (sw_changed) begin
            auto_reset_flag <= 1'b1;     
            reset_counter <= 4'd15;      
        end else if (reset_counter > 0) begin
            reset_counter <= reset_counter - 1;
            if (reset_counter == 1)
                auto_reset_flag <= 1'b0; 
        end
    end
    
    wire reset = SW[9] || auto_reset_flag;
    
    wire clock_100; 
    
    pll100_0002 pll100_inst (
        .refclk   (clk_50),    
        .rst      (1'b0),      
        .outclk_0 (clock_100), 
        .locked   (locked)     
    );

    wire [10:0] next_x;
    wire [10:0] next_y;
    
    reg [10:0] x_delayed;
    reg [10:0] y_delayed;

    always @(posedge clk_25_reg) begin
        x_delayed <= next_x;
        y_delayed <= next_y;
    end
    
    localparam IMG_WIDTH_PEQ8  = 20;
    localparam IMG_HEIGHT_PEQ8 = 15;
    localparam IMG_WIDTH_PEQ4  = 40;
    localparam IMG_HEIGHT_PEQ4 = 30;
    localparam IMG_WIDTH_PEQ   = 80;
    localparam IMG_HEIGHT_PEQ  = 60;
    localparam IMG_WIDTH_OR    = 160;
    localparam IMG_HEIGHT_OR   = 120;
    localparam IMG_WIDTH_GRA   = 320;
    localparam IMG_HEIGHT_GRA  = 240;      
    localparam IMG_WIDTH_GRA4  = 640;
    localparam IMG_HEIGHT_GRA4 = 480;
    localparam IMG_TOTAL_PIXELS_OR = IMG_WIDTH_OR * IMG_HEIGHT_OR;

    wire        processing_done;
    wire        coproc_pixel_in_ready;

    reg [18:0] rom_addr_counter = 0;
    always @(posedge clk_25_reg or posedge reset) begin
        if (reset) begin
            rom_addr_counter <= 0;
        end else if (boton[0] && !processing_done && rom_addr_counter < IMG_TOTAL_PIXELS_OR && coproc_pixel_in_ready) begin
            rom_addr_counter <= rom_addr_counter + 1;
        end
    end

    reg [18:0] ram_address_read;

    wire dentro_img_peq = (x_delayed < IMG_WIDTH_PEQ) && (y_delayed < IMG_HEIGHT_PEQ);
    wire [18:0] ram_addr_peq = dentro_img_peq ? (y_delayed * IMG_WIDTH_PEQ + x_delayed) : 19'd0;

    wire dentro_img_peq4 = (x_delayed < IMG_WIDTH_PEQ4) && (y_delayed < IMG_HEIGHT_PEQ4);
    wire [18:0] ram_addr_peq4 = dentro_img_peq4 ? (y_delayed * IMG_WIDTH_PEQ4 + x_delayed) : 19'd0;
    
    wire dentro_img_peq8 = (x_delayed < IMG_WIDTH_PEQ8) && (y_delayed < IMG_HEIGHT_PEQ8);
    wire [18:0] ram_addr_peq8 = dentro_img_peq8 ? (y_delayed * IMG_WIDTH_PEQ8 + x_delayed) : 19'd0;
    
    wire dentro_img_or_display = (x_delayed < IMG_WIDTH_OR) && (y_delayed < IMG_HEIGHT_OR);
    wire [18:0] ram_addr_or = dentro_img_or_display ? (y_delayed * IMG_WIDTH_OR + x_delayed) : 19'd0;
    
    wire dentro_img_gra = (x_delayed < IMG_WIDTH_GRA) && (y_delayed < IMG_HEIGHT_GRA);
    wire [18:0] ram_addr_gra = dentro_img_gra ? (y_delayed * IMG_WIDTH_GRA + x_delayed) : 19'd0;
    
    wire dentro_img_gra4 = (x_delayed < IMG_WIDTH_GRA4) && (y_delayed < IMG_HEIGHT_GRA4);
    wire [18:0] ram_addr_gra4 = dentro_img_gra4 ? (y_delayed * IMG_WIDTH_GRA4 + x_delayed) : 19'd0;

    wire [7:0] saida_rom;
    wire [18:0] address_rom;
    wire [7:0]  entrada_vga;
    
    wire modo_processamento_ativo = (SW[5:2] != 4'b0000);

    always @(*) begin
        case (SW[8:7]) 
            2'b01: begin 
                case (SW[5:2])
                    4'b0001:  ram_address_read = ram_addr_gra4;
              
                    default:  ram_address_read = ram_addr_or;
                endcase
            end
            
            2'b10: begin 
                case (SW[5:2])
                    4'b0001:  ram_address_read = ram_addr_gra4; 
                endcase
            end
            
            default: begin 
                case (SW[5:2])
                    4'b0001, 4'b0010:  ram_address_read = ram_addr_gra;
                    4'b0100, 4'b1000:  ram_address_read = ram_addr_peq;
                    default:           ram_address_read = ram_addr_or;
                endcase
            end
        endcase
    end
    
    assign address_rom = modo_processamento_ativo ? rom_addr_counter : ram_addr_or;
    assign entrada_vga = modo_processamento_ativo ? ram_q : saida_rom;
    
    imagem rom_inst_OR (
        .address(address_rom),
        .clock(clock_100),
        .q(saida_rom)
    );

    wire [7:0] pixel_coproc_out;
    wire       pixel_coproc_valid;
    coprocessador coprocessador_inst (
        .clk(clk_25_reg), 
        .resetn(~reset), 
        .start(boton[0]), 
        .largura_in(IMG_WIDTH_OR),
        .altura_in(IMG_HEIGHT_OR), 
        .SW(SW[5:2]), 
        .escala(SW[8:7]),
        .pixel_in(saida_rom),
        .pixel_out(pixel_coproc_out), 
        .pixel_out_valid(pixel_coproc_valid),
        .processing_done(processing_done), 
        .pixel_in_ready(coproc_pixel_in_ready)
    );

    reg  [18:0] pixel_write_count = 0;
    reg  process_done_latch = 0;
    always @(posedge clk_25_reg or posedge reset) begin
        if (reset) begin
            pixel_write_count  <= 0;
            process_done_latch <= 0;
        end else begin
            if (pixel_coproc_valid && !process_done_latch)
                pixel_write_count <= pixel_write_count + 1;
            if (processing_done)
                process_done_latch <= 1'b1; 
        end
    end

    wire [18:0] ram_address_write = pixel_write_count;
    wire [18:0] ram_address = process_done_latch ? ram_address_read : ram_address_write;
    wire        escrita     = pixel_coproc_valid && !process_done_latch;
    wire [7:0]  ram_q;
    ram_pri ram_inst (
        .address(ram_address),
        .clock(clock_100),
        .data(pixel_coproc_out),   
        .wren(escrita), 
        .q(ram_q)
    );
    
    display texto (
        .clk(clk_50),
        .reset(reset),
        .zoom_level_select(SW[5:2]),    
        .zoom_type_select(SW[8:7]),     
        .HEX0(out_hex0),
        .HEX1(out_hex1),
        .HEX2(out_hex2),
        .HEX3(out_hex3),
        .HEX4(out_hex4),
        .HEX5(out_hex5)
    );

    vga_module vga_inst (
        .clock(clk_25_reg), 
        .reset(reset), 
        .color_in(entrada_vga), 
        .next_x(next_x),
        .next_y(next_y), 
        .hsync(hsync), 
        .vsync(vsync), 
        .red(red), 
        .green(green),
        .blue(blue), 
        .sync(sync), 
        .clk(clk), 
        .blank(blank)
    );

endmodule