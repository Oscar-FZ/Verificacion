// Descripción: Este módulo implementa un FIFO utilizando flip-flops asíncronos.
//              El FIFO tiene un tamaño de profundidad configurable (depth) y ancho
//              de datos configurable (bits). El módulo acepta señales de reloj (clk),
//              operaciones de inserción (push) y extracción (pop), y una señal de
//              reinicio (rst). Además, proporciona señales de estado "full" y "empty".
//              Utiliza flip-flops asíncronos para almacenar los datos en el FIFO y un
//              módulo "fifo_control" para llevar el conteo de los elementos en el FIFO.
// Parámetros:
//   - depth: Profundidad del FIFO (por defecto 16 elementos).
//   - bits: Ancho de datos del FIFO (por defecto 32 bits).
// Puertos:
//   - clk: Señal de reloj de entrada.
//   - push: Señal de operación de inserción en el FIFO.
//   - pop: Señal de operación de extracción del FIFO.
//   - rst: Señal de reinicio de entrada (activo en flanco negativo).
//   - Din: Datos de entrada al FIFO.
//   - full: Salida que indica si el FIFO está lleno.
//   - empty: Salida que indica si el FIFO está vacío.
//   - Dout: Datos de salida del FIFO.

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
    
    // Conexiones de los flip-flops asíncronos
    wire [bits-1:0] q [depth-1:0];
    
    // Señal de conteo de elementos en el FIFO
    wire [$clog2(depth):0] count;
    
    // Generar flip-flops asíncronos
    genvar i;
    generate
        for (i = 0; i < depth; i = i + 1) begin 
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
    
    // Módulo para controlar el contador de elementos en el FIFO
    fifo_control #(.depth()) FIFO_CONT
    (
        .clk_i  (clk),
        .rst_i  (rst),
        .push   (push),
        .pop    (pop),
        .count  (count)
    );
    
    // Módulo multiplexor parametrizable para obtener el dato de salida
    mux_parametrizable #(.depth(depth), .bits(bits)) MUS_PAR
    (
        .mux_sel_i  (count),
        .mux_data_i (q), 
        .mux_data_o (Dout)
    );
    
    // Asignación de señales de estado "empty" y "full"
    assign empty = (count == 0) ? 1'b1 : 1'b0; // El FIFO está vacío si el contador es cero.
    assign full = (count == depth) ? 1'b1 : 1'b0; // El FIFO está lleno si el contador es igual a la profundidad.
    
endmodule
