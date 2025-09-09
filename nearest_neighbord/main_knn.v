`timescale 1 ns / 1 ps

module digitrec_top (
    input  wire        clk,       // clock do sistema
    input  wire        rst,       // reset síncrono
    input  wire        start,     // inicia reconhecimento
    output wire        done,      // finalizou reconhecimento
    output wire [3:0]  digit_out  // dígito reconhecido (0-9)
);

    // ------------------------
    // Conexão com ROM da imagem
    // ------------------------
    wire [47:0] test_image;

    // ROM com vetor 48 bits da imagem (1 palavra só)
    img_before u_img_rom (
        .address(1'b0),  // só tem 1 word
        .clock(clk),
        .q(test_image)
    );

    // ------------------------
    // Conexão com update_knn
    // ------------------------
    wire        update_done, update_idle, update_ready;
    wire [4:0]  min_dist_addr0, min_dist_addr1;
    wire        min_dist_ce0, min_dist_ce1;
    wire        min_dist_we0, min_dist_we1;
    wire [5:0]  min_dist_d0, min_dist_d1;
    wire [5:0]  min_dist_q0;
    wire [3:0]  min_dist_offset = 4'd0;  // offset fixo

    // Dataset ROM (treinamento)
    wire [47:0] train_inst;
    wire [14:0] train_addr;
    wire        train_ce;

    digitrec_trainingbkb u_train_rom (
        .reset(rst),
        .clk(clk),
        .address0(train_addr),
        .ce0(train_ce),
        .q0(train_inst)
    );

    // update_knn: calcula distâncias
    update_knn u_update (
        .ap_clk(clk),
        .ap_rst(rst),
        .ap_start(start),
        .ap_done(update_done),
        .ap_idle(update_idle),
        .ap_ready(update_ready),
        .test_inst_V(test_image),
        .train_inst_V(train_inst),
        .min_distances_V_address0(min_dist_addr0),
        .min_distances_V_ce0(min_dist_ce0),
        .min_distances_V_we0(min_dist_we0),
        .min_distances_V_d0(min_dist_d0),
        .min_distances_V_q0(min_dist_q0),
        .min_distances_V_address1(min_dist_addr1),
        .min_distances_V_ce1(min_dist_ce1),
        .min_distances_V_we1(min_dist_we1),
        .min_distances_V_d1(min_dist_d1),
        .min_distances_V_offset(min_dist_offset)
    );

    // ------------------------
    // Conexão com knn_vote
    // ------------------------
    wire        vote_done, vote_idle, vote_ready;
    wire [3:0]  vote_return;

    knn_vote u_vote (
        .ap_clk(clk),
        .ap_rst(rst),
        .ap_start(update_done),  // só começa quando update terminar
        .ap_done(vote_done),
        .ap_idle(vote_idle),
        .ap_ready(vote_ready),
        .knn_set_0_V_address0(min_dist_addr0[3:0]), // reduz p/ 4 bits
        .knn_set_0_V_ce0(min_dist_ce0),
        .knn_set_0_V_q0(min_dist_q0[4:0]),
        .ap_return(vote_return)
    );

    // ------------------------
    // Saída final
    // ------------------------
    assign done      = vote_done;
    assign digit_out = vote_return;


    wire [9:0] x, y;
wire [7:0] pixel_color;

vga_driver vga(
    .clock(clk25),
    .reset(rst),
    .color_in(pixel_color),
    .next_x(x),
    .next_y(y),
    .hsync(hsync),
    .vsync(vsync),
    .red(red),
    .green(green),
    .blue(blue),
    .sync(sync),
    .clk(clk_out),
    .blank(blank)
);

vector_to_pixels v2p(
    .clk(clk25),
    .reset(rst),
    .vec_48(my_vec48),  // resultado do processamento
    .x(x),
    .y(y),
    .color_out(pixel_color)
);


endmodule
