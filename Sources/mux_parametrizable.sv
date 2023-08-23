// Módulo: mux_parametrizable
// Descripción: Este módulo implementa un multiplexor parametrizable con una profundidad
//              y ancho de datos configurables. El módulo toma como entrada una señal
//              de selección (mux_sel_i) que indica el índice del dato de entrada a
//              seleccionar, y un conjunto de datos de entrada (mux_data_i) de longitud
//              depth. El módulo proporciona una señal de salida (mux_data_o) que es el
//              dato de entrada seleccionado.
// Parámetros:
//   - depth: Profundidad del multiplexor (por defecto 16 entradas).
//   - bits: Ancho de datos del multiplexor (por defecto 8 bits).
// Puertos:
//   - mux_sel_i: Señal de selección de entrada.
//   - mux_data_i: Conjunto de datos de entrada.
//   - mux_data_o: Dato de salida seleccionado.

module mux_parametrizable #(parameter depth = 16, parameter bits = 8)
    (
        input [$clog2(depth):0] mux_sel_i,
        input [bits-1:0] mux_data_i [depth-1:0],
        
        output reg [bits-1:0] mux_data_o
    );
    
    // Registros auxiliares para el multiplexor
    reg [bits-1:0] aux_mux [depth-1:0];        
    reg [bits-1:0] aux_mux_or [depth-2:0];
    
    // Generar lógica del multiplexor
    genvar i;
    generate 
        for (i = 0; i < depth; i = i + 1) begin
            assign aux_mux[i] = (mux_sel_i == i + 1) ? mux_data_i[i] : {bits{1'b0}}; // Seleccionar el dato correcto o ceros.
        end
    endgenerate
    
    generate
        for (i = 0; i < depth-2; i = i + 1) begin
            assign aux_mux_or[i] = aux_mux[i] | aux_mux_or[i+1]; // Realizar la operación OR para los datos seleccionados.
        end
    endgenerate
    
    // Asignar el dato seleccionado a la salida
    always @(*) begin
        aux_mux_or[depth-2] = aux_mux[depth-1] | aux_mux[depth-2]; // Calcular el último OR intermedio.
        mux_data_o = aux_mux_or[0]; // La salida es el resultado del primer OR intermedio.
    end
endmodule

