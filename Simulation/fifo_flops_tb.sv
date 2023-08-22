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
            // Si el FIFO está lleno, vamos al ciclo 3 para manejarlo
            ciclo = 3;
        end
        
        case(ciclo)
            0:begin
                // Configuración inicial del sistema
                rst = 1'b0;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 1;
            end
            
            1:begin
                // Activamos el reset para limpiar el FIFO
                rst = 1'b1;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 2;
            end
            
            2:begin
                // Alternamos entre push y no-push
                rst = 1'b1;
                push = ~push;
                pop = 1'b0;
                Din = dato;
                
                if (push == 1) begin
                    // Realizamos un push y mostramos el dato y el contador
                    $display("at $g pushed data: %g count %g", $time, Din, fifo_flops_DUT.count);
                    dato = dato + 1;
                end
                
                if (dato == 16) begin
                    // Cuando el FIFO está lleno, vamos al ciclo 3
                    ciclo = 3;
                    $display("FIFO is full");
                end
            end
            
            3:begin
                // Llenado del FIFO completado, volvemos a la configuración inicial
                rst = 1'b0;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 4;
            end
            
            4:begin
                // Activamos el pop para extraer un dato del FIFO
                pop = 1'b1;
                $display("at $g popping data: %g count %g", $time, Dout, fifo_flops_DUT.count);
                ciclo = 5;
            end
            
            5:begin
                // Volvemos a la configuración inicial
                rst = 1'b0;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 6;
            end
            
            6:begin
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
                
                if (dato == 8) begin
                    // Cuando el FIFO está medio lleno, vamos al ciclo 7
                    ciclo = 7;
                    $display("FIFO is half-full");
                end
            end
            
            7:begin
                // El FIFO está medio lleno, volvemos a la configuración inicial
                rst = 1'b0;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 8;
            end
            
            8:begin
                // Activamos el reset nuevamente
                rst = 1'b1;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 9;
            end
            
            9:begin
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
                    // Cuando el FIFO está lleno, vamos al ciclo 10
                    ciclo = 10;
                    $display("FIFO is full");
                end
            end
            
            10:begin
                // El FIFO está lleno, volvemos a la configuración inicial
                rst = 1'b0;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 11;
            end
            
            11:begin
                // Volvemos a la configuración inicial
                rst = 1'b1;
                push = 1'b0;
                pop = 1'b0;
                Din = 8'b00;
                ciclo = 12;
            end
            
            12:begin
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
