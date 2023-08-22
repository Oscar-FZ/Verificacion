`timescale 1ns / 1ps

module fifo_flops #(parameter depth = 16, parameter bits = 32)
    (
        input clk,
        input push,
        input pop,
        input rst,
        input [bits-1:0] Din,
        
        output reg full,
        output reg empty,
        output reg [bits-1:0] Dout
    );
    
    wire [bits-1:0] q [depth-1:0];
    wire [$clog2(depth):0] count;
    
    genvar i;
    generate
        for (i = 0; i<depth; i = i+1) begin 
            if (i == 0) begin
                FF_D_async #(bits) FF_REG (
                    .clk_i  (push),
                    .rst_i  (rst),
                    .d_i    (Din),
                    .q_o    (q[i])
                );
            end
            
            else begin
                FF_D_async #(bits) FF_REG (
                    .clk_i  (push),
                    .rst_i  (rst),
                    .d_i    (q[i-1]),
                    .q_o    (q[i])
                );
            end
            
        end
    endgenerate
    
    fifo_control #(.depth()) FIFO_CONT
    (
        .clk_i  (clk),
        .rst_i  (rst),
        .push   (push),
        .pop    (pop),
        .count  (count)
    );
    
    
    mux_parametrizable #(.depth(depth), .bits(bits)) MUS_PAR
    (
        .mux_sel_i  (count),
        .mux_data_i (q), 
        .mux_data_o (Dout)
    );
    
    assign empty = (count==0)?{1'b1}:{1'b0};
    assign full = (count == depth)?{1'b1}:{1'b0};
    
endmodule
