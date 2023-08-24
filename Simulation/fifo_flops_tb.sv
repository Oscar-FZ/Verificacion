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
    
    
    // Configuración inicial del sistema
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
            // Si el FIFO está lleno, vamos al ciclo 3 para manejarlo
            ciclo = 2;
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
                // Se esta llenando la FIFO
                rst = 1'b1;
                push = ~push;
                pop = 1'b0;
                Din = dato;
                
                if (push==1)begin
                    // Realizamos un push y mostramos el dato y el contador
                    $display("at $g pushed data: %g count %g", $time,Din,fifo_flops_DUT.count);
                    dato = dato + 1;
                end
                // Cuando el FIFO está lleno, vamos al ciclo 3
                if (dato==8) ciclo = 3;
            end

            
            3:begin
                //Vaciamos la FIFO
                rst = 1'b1;
                push = 1'b0;
                pop = ~pop;
                Din = dato;
                
                if (push==1)begin
                    $display("at $g pushed data: %g count %g", $time,Din,fifo_flops_DUT.count);
                    
                end
                if (dato==0) ciclo = 4;
            end

            
            4:begin
                // Volvemos a la configuración inicial
                rst = 1'b0;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 6;
            end
            
            5:begin
                // Operaciones de push y pop al mismo tiempo
                rst = 1'b1;
                push = ~push;
                pop = ~pop;
                Din = dato;
                
                if (push == 1) begin
                    // Realizamos un push y mostramos el dato y el contador
                    $display("at $g pushed data: %g count %g", $time, Din, fifo_flops_DUT.count);
                    dato = dato + 1;
                end
                
                if (pop == 1) begin
                    // Realizamos un pop y mostramos el dato y el contador
                    $display("at $g popping data: %g count %g", $time, Dout, fifo_flops_DUT.count);
                end
                
                if (dato == 4) begin
                    // Cuando el FIFO está medio lleno, vamos al ciclo 6
                    ciclo = 7;
                    $display("FIFO is half-full");
                end
            end
            
            
            6:begin
                // Activamos el reset nuevamente
                rst = 1'b1;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 9;
            end
            
            8:begin
                // Intentamos hacer un push cuando el FIFO ya está lleno
                rst = 1'b1;
                push = 1'b1;
                pop = 1'b0;
                Din = dato;
                
                if (push == 1) begin
                    // Realizamos un push y mostramos el dato y el contador
                    $display("at $g pushed data: %g count %g", $time, Din, fifo_flops_DUT.count);
                    dato = dato + 1;
                end
                
                if (full == 1) begin
                    // Cuando el FIFO está lleno, vamos al ciclo 9
                    ciclo = 10;
                    $display("FIFO is full");
                end
            end
            
            9:begin
                // El FIFO está lleno, volvemos a la configuración inicial
                rst = 1'b0;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 11;
            end
            
            10:begin
                // Volvemos a la configuración inicial
                rst = 1'b1;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 12;
            end
            
            11:begin
                // Continuamos las operaciones de push y pop
                rst = 1'b1;
                push = ~push;
                pop = 1'b0;
                Din = dato;
                
                if (push == 1) begin
                    // Realizamos un push y mostramos el dato y el contador
                    $display("at $g pushed data: %g count %g", $time, Din, fifo_flops_DUT.count);
                    dato = dato + 1;
                end
            end
        endcase
    endtask

endmodule
