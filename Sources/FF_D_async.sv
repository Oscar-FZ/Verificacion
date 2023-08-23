// Descripción: Este módulo implementa una sola FF (Flip-Flop) asíncrona de datos.
//              El FF se sincroniza al flanco positivo del reloj (clk_i) y se restablece
//              al flanco negativo de la señal de reinicio (rst_i).
// Parámetros:
//   - WIDTH: Ancho del dato del flip-flop (por defecto 4 bits)
// Puertos:
//   - clk_i: Señal de reloj de entrada.
//   - rst_i: Señal de reinicio de entrada (activo en flanco negativo).
//   - d_i: Datos de entrada al flip-flop.
//   - q_o: Datos de salida del flip-flop.
//===================================================================================

module FF_D_async #(parameter WIDTH = 4)
    (
        input clk_i,
        input rst_i,
        input [WIDTH-1:0] d_i,
        
        output reg [WIDTH-1:0] q_o
    );

    always @(posedge clk_i or negedge rst_i)
        if (!rst_i) begin
            // Si la señal de reinicio (rst_i) está activa (baja), se reinicia el flip-flop
            q_o <= 'hF; // Valor por defecto de la salida al reiniciar
        end
        else begin
            // En el flanco positivo del reloj, se actualiza el valor de salida (q_o) con el dato de entrada (d_i)
            q_o <= d_i;
        end

endmodule
