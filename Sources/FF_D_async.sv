`timescale 1ns / 1ps

module FF_D_async #(parameter WIDTH = 4)
  	(
        input clk_i,
        input rst_i,
        input [WIDTH-1:0] d_i,
        
        output reg [WIDTH-1:0] q_o
    );

  always @(posedge clk_i or negedge rst_i)
        if (!rst_i) begin
            q_o <= 'hF;
        end

        else begin
            q_o <= d_i;
        end

    endmodule    