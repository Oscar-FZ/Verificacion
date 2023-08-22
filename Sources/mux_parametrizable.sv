`timescale 1ns / 1ps

module mux_parametrizable #(parameter depth = 16, parameter bits = 8)
    (
        input [$clog2(depth):0] mux_sel_i,
        input [bits-1:0] mux_data_i [depth-1:0],
        
        output reg [bits-1:0] mux_data_o
    );
    
    reg [bits-1:0] aux_mux [depth-1:0];        
    reg [bits-1:0] aux_mux_or [depth-2:0];
    
    genvar i;
    generate 
        for (i = 0; i<depth; i = i+1) begin
            assign aux_mux[i] = (mux_sel_i == i + 1) ? mux_data_i[i] : {bits{1'b0}};
        end
    endgenerate
    
    generate
        for (i = 0; i<depth-2; i = i+1) begin
            assign aux_mux_or[i] = aux_mux[i] | aux_mux_or[i+1];
        end
    endgenerate
    
    always@(*)begin
        aux_mux_or[depth-2] = aux_mux[depth-1] | aux_mux[depth-2];
        mux_data_o = aux_mux_or[0];
    end
endmodule
