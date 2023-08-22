`timescale 1ns / 1ps


module mux_parametrizable_tb();

    parameter depth = 16;
    parameter bits = 8;
    reg [$clog2(depth):0] mux_sel_i;
    reg [bits-1:0] mux_data_i [depth-1:0];
    reg [bits-1:0] mux_data_o;
    
    

    mux_parametrizable #(.depth(depth), .bits(bits)) mux_par_DUT
    (
        .mux_sel_i  (mux_sel_i),
        .mux_data_i (mux_data_i), 
        .mux_data_o (mux_data_o)
    );
    
    initial begin
        mux_data_i[0] = 8'h00;
        mux_data_i[1] = 8'h11;
        mux_data_i[2] = 8'h22;
        mux_data_i[3] = 8'h33;
        mux_data_i[4] = 8'h44;
        mux_data_i[5] = 8'h55;
        mux_data_i[6] = 8'h66;
        mux_data_i[7] = 8'h77;
        mux_data_i[8] = 8'h88;
        mux_data_i[9] = 8'h99;
        mux_data_i[10] = 8'hAA;
        mux_data_i[11] = 8'hBB;
        mux_data_i[12] = 8'hCC;
        mux_data_i[13] = 8'hDD;
        mux_data_i[14] = 8'hEE;
        mux_data_i[15] = 8'hFF;
        
        #5;
        mux_sel_i = 4'h0;
        
        #5;
        mux_sel_i = 4'h1;
        
        #5;
        mux_sel_i = 4'h2;
        
        #5;
        mux_sel_i = 4'h3;
        
        #5;
        mux_sel_i = 4'h4;
        
        #5;
        mux_sel_i = 4'h5;
        
        #5;
        mux_sel_i = 4'h6;
        
        #5;
        mux_sel_i = 4'h7;
        
        #5;
        mux_sel_i = 4'h8;
        
        #5;
        mux_sel_i = 4'h9;
        
        #5;
        mux_sel_i = 4'hA;
        
        #5;
        mux_sel_i = 4'hB;
        
        #5;
        mux_sel_i = 4'hC;
        
        #5;
        mux_sel_i = 4'hD;
        
        #5;
        mux_sel_i = 4'hE;
        
        #5;
        mux_sel_i = 4'hF;   
        #5;
        $finish;
    end


endmodule
