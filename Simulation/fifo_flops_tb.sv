`timescale 1ns / 1ps


module fifo_flops_tb();

    parameter depth = 16;
    parameter bits = 8;

    reg clk;
    reg push;
    reg pop;
    reg rst;
    reg [bits-1:0] Din;
    wire full;
    wire empty;
    wire [bits-1:0] Dout;
    
    

    fifo_flops #(.depth(depth), .bits(bits)) fifo_flops_DUT
    (
        .clk    (clk),
        .push   (push),
        .pop    (pop),
        .rst    (rst),
        .Din    (Din),
        .full   (full),
        .empty  (empty),
        .Dout   (Dout)
    );
    
    
    
    initial begin
        clk = 0;
        rst = 1'b1;
        push = 1'b0;
        pop = 1'b0;
        Din = 8'b00;
        #100;
    end
    
    always #50 clk = ~clk;
    always@(posedge clk) begin
        prueba();
    end
    
    int ciclo = 0;
    int dato = 0;
    
    task prueba();
        if (full == 1) begin
            ciclo = 3;
        end
        
        case(ciclo)
            0:begin
                rst = 1'b0;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 1;
            end
            
            1:begin
                rst = 1'b1;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 2;
            end
            
            2:begin
                rst = 1'b1;
                push = ~push;
                pop = 1'b0;
                Din = dato;
                
                if (push==1)begin
                    $display("at $g pushed data: %g count %g", $time,Din,fifo_flops_DUT.count);
                    dato = dato + 1;
                end
                
                if (dato==8) ciclo = 3;
            end
                
            3:begin
                rst = 1'b1;
                push = 1'b0;
                pop = ~pop;
                Din = dato;
                
                if (push==1)begin
                    $display("at $g pushed data: %g count %g", $time,Din,fifo_flops_DUT.count);
                    
                end
                
            end
                
                
            
            
        endcase
    endtask

endmodule
