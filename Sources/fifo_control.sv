// Módulo: fifo_control
// Descripción: Este módulo controla el contador de elementos en un FIFO.
//              El módulo toma como entradas las señales de reloj (clk_i), reinicio (rst_i),
//              operación de inserción (push) y operación de extracción (pop). El módulo
//              genera la señal de salida "count" que representa la cantidad actual de elementos
//              en el FIFO. El contador se actualiza en función de las operaciones de inserción
//              y extracción.
// Parámetros:
//   - depth: Profundidad máxima del FIFO (por defecto 16 elementos)
// Puertos:
//   - clk_i: Señal de reloj de entrada.
//   - rst_i: Señal de reinicio de entrada (activo en flanco negativo).
//   - push: Señal de operación de inserción en el FIFO.
//   - pop: Señal de operación de extracción del FIFO.
//   - count: Salida que indica la cantidad actual de elementos en el FIFO.

module fifo_control #(parameter depth = 16)
    (
        input clk_i,
        input rst_i,
        input push,
        input pop,
        
        output reg [$clog2(depth):0] count
    );
    
    // Definición de los estados posibles del módulo
    typedef enum
    {
        no_push_no_pop,
        only_pop,
        only_push,
        push_pop
    } state_t;
    
    // Procesamiento asincrónico para actualizar el contador "count"
    always_ff @(posedge clk_i, negedge rst_i)
        if (!rst_i)
            count <= 0; // En caso de reinicio, el contador se restablece a cero.
        else begin
            unique case ({push, pop})
                no_push_no_pop: count <= count; // No hay operaciones de inserción ni extracción, no cambia el contador.
                
                only_pop: begin
                    if (count == 0) begin
                        count <= 0; // Si el contador es cero, permanece igual.
                    end
                    else begin
                        count = count - 1; // Si hay una operación de extracción, disminuye el contador.
                    end
                end
                
                only_push: begin
                    if (count == depth) begin
                        count <= count; // Si el contador ya alcanzó la profundidad máxima, permanece igual.
                    end
                    else begin
                        count = count + 1; // Si hay una operación de inserción, aumenta el contador.
                    end
                end
                
                push_pop: count <= count; // Si hay tanto operación de inserción como extracción, el contador no cambia.
            endcase
        end
endmodule
