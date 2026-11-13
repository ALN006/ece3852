module cross_river(
    input logic clk,
    input logic reset,
    input logic move_w, move_g, move_c,
    output logic bank_m, bank_w, bank_g, bank_c
);
    always_ff @(posedge clk) begin 
        if (reset) begin
            bank_m <= 1'b0;
            bank_w <= 1'b0;
            bank_g <= 1'b0;
            bank_c <= 1'b0;
        end else begin
            bank_w <= (move_w) ? ~bank_w : bank_w;
            bank_g <= (move_g) ? ~bank_g : bank_g;
            bank_c <= (move_c) ? ~bank_c : bank_c;
            bank_m <= ~bank_m;
        end 
    end 

    `ifdef FORMAL
        logic f_past_valid = 1'b0;
        always_ff @(posedge clk) f_past_valid <= 1'b1;

        always begin
            if (!f_past_valid)
                assume (reset == 1'b1);
            else
                assume (reset == 1'b0);
        end

        always @(posedge clk) begin
            if (!reset) begin
                // rules of the game
                if (bank_w == bank_g) assume (bank_m == bank_w);
                if (bank_g == bank_c) assume (bank_m == bank_g);
                assume(move_w + move_g + move_c <= 1); 

                cover({bank_m, bank_w, bank_g, bank_c} == 4'b1111);
            end
        end
    `endif 
endmodule
