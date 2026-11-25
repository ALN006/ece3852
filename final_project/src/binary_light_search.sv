module binary_light_search
    import our_logic_pkg::*;
    #(  parameter   dist_t              unit_radius         = (1 << DIST_WIDTH - 1); // this first parameter is like precision control
        parameter   angle_t             lower_bound_angle   = '0,
        parameter   angle_t             upper_bound_angle   = PI,
        localparam  integer             cycles              = $clog2(upper_bound.angle) ) (
        input       logic               clk,
        input       cart_2d_coord_t     target,
        input       logic               req,
        input       logic               reset,
        output      logic               done,
        output      angle_t             angle
    );
    angle_t                 curr_lower;
    polar_2d_coord_t        curr;
    angle_t                 curr_upper;
    logic [cycles - 1 : 0 ] cycle;
    cart_2d_coord_t         light_unit_vector;
    assign curr.radius          = unit_radius;
    assign light_unit_vector    = polar_to_cart(curr);
    assign angle                = curr.angle;
    always_ff @(posedge clk) begin 
        curr.angle <= ((curr_upper + curr_lower) >> 1);
        if (reset == 1'b1) begin 
            {cycle} = '0;
            curr_lower <= lower_bound_angle;
            curr_upper <= upper_bound_angle;
        end else begin 
            if (done == 1'b1) begin 
                if (req == 1'b1) begin 
                    cycle[cycles - 1] <= 1'b1;
                    done <= 1'b0;
                end
            end else begin
                cycle <= { 1'b0, cycle[ cycles - 1 : 1 ] };
                if (cycle[0] == 1'b1) done <= 1'b1; // is this not redundant with the line 42-44?
                if (det_2d(light_unit_vector, target) > '0) begin 
                    curr_upper <= curr.angle;
                end else begin 
                    curr_lower <= curr.angle;
                end
                if (cycle[0] == 1'b1) begin 
                    done <= 1'b1;
                end
            end
        end
    end 
endmodule
