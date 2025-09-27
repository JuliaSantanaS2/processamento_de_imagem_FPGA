/**********************************************************************************
* * Módulo: display
*
* Descrição: 
* Este módulo é um driver para seis displays de 7 segmentos. Ele exibe um texto
* estático pré-definido com base em duas entradas de seleção (`zoom_level_select`
* e `zoom_type_select`), que correspondem às chaves SW do sistema. Uma lógica
* combinacional determina qual texto exibir (por exemplo, "4 REPX", "8 VIN"),
* e uma função interna (`char_to_segments`) converte cada caractere ASCII do
* texto no padrão de 7 bits correspondente para acender os displays.
*
**********************************************************************************/
module display (
    input        clk,
    input        reset,
    input  [1:0] zoom_level_select,
    input  [3:0] zoom_type_select,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5
);

    reg [7:0] text_data [0:5];
    integer i;

    always @(*) begin
        for (i = 0; i < 6; i = i + 1) begin
            text_data[i] = " ";
        end

        case(zoom_level_select)
            2'b01:   text_data[0] = "4";
            2'b10:   text_data[0] = "8";
            default: text_data[0] = "2";
        endcase
        
        text_data[1] = " ";

        case(zoom_type_select)
            4'b0001: begin
                text_data[2] = "R"; text_data[3] = "E"; text_data[4] = "P"; text_data[5] = "X";
            end
            4'b0010: begin
                text_data[2] = "V"; text_data[3] = "I"; text_data[4] = "N";
            end
            4'b0100: begin
                text_data[2] = "V"; text_data[3] = "O"; text_data[4] = "U"; text_data[5] = "T";
            end
            4'b1000: begin
                text_data[2] = "M"; text_data[3] = "B"; text_data[4] = "C"; text_data[5] = "S";
            end
            default: begin
            end
        endcase
    end

    function [6:0] char_to_segments;
        input [7:0] char;
        begin
            case(char)
                "A": char_to_segments = 7'b0001000; "B": char_to_segments = 7'b0000011;
                "C": char_to_segments = 7'b1000110; "D": char_to_segments = 7'b0100001;
                "E": char_to_segments = 7'b0000110; "F": char_to_segments = 7'b0001110;
                "G": char_to_segments = 7'b1000010; "H": char_to_segments = 7'b0001011;
                "I": char_to_segments = 7'b1001111; "J": char_to_segments = 7'b1100001;
                "L": char_to_segments = 7'b1000111; "M": char_to_segments = 7'b1101010;
                "N": char_to_segments = 7'b1010100; "O": char_to_segments = 7'b1000000; 
                "P": char_to_segments = 7'b0001100; "R": char_to_segments = 7'b1011111;
                "S": char_to_segments = 7'b0010010; "T": char_to_segments = 7'b0000111;
                "U": char_to_segments = 7'b1000001; "V": char_to_segments = 7'b1100011;
                "X": char_to_segments = 7'b0001001; "Z": char_to_segments = 7'b0100100;
                
                "2": char_to_segments = 7'b0100100;
                "4": char_to_segments = 7'b0011001;
                "8": char_to_segments = 7'b0000000;

                " ": char_to_segments = 7'b1111111;
                default: char_to_segments = 7'b1111111;
            endcase
        end
    endfunction

    assign HEX5 = char_to_segments(text_data[0]);
    assign HEX4 = char_to_segments(text_data[1]);
    assign HEX3 = char_to_segments(text_data[2]);
    assign HEX2 = char_to_segments(text_data[3]);
    assign HEX1 = char_to_segments(text_data[4]);
    assign HEX0 = char_to_segments(text_data[5]);

endmodule