`timescale 1ns / 1ps

module fifo_control #(parameter depth = 16)
    (
        input clk_i,
        input rst_i,
        input push,
        input pop,
        
        output reg [$clog2(depth):0] count
    );
    
    typedef enum
        {
        no_push_no_pop,
        only_pop,
        only_push,
        push_pop
        } state_t;
        
    
        
    always_ff @(posedge clk_i, negedge rst_i)
        if (!rst_i)
            count <= 0;
        else begin
            unique case ({push,pop}) 
                no_push_no_pop: count <= count;
                
                only_pop: begin
                    if (count == 0) begin
                        count <= 0;
                    end
                    
                    else begin
                        count = count - 1;
                    end
                end
                
                only_push: begin
                    if (count == depth) begin
                        count <= count;
                    end
                    
                    else begin
                        count = count + 1;
                    end
                end
                
                push_pop: count <= count;
            endcase
        end
            
               
endmodule
