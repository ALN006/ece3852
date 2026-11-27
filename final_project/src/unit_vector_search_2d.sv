// TODO: so this whole radius passing thing is kinda stupid, in an ideal world what we call UNIT_RADIUS here should be SIN(PI/2) always
// TODO: in an ideal world SIN(PI/2) should fit as a dist_t so we dont have to worry about ts again
module unit_vector_search_2d // NOTE: it is neccessary to assert reset to find a new direction
    import geometry_pkg::*;
    #(  parameter   dist_t              UNIT_RADIUS         = (1 << DIST_WIDTH - 1), // this first parameter is like precision control
        parameter   angle_t             LOWER_BOUND_ANGLE   = '0,
        parameter   angle_t             UPPER_BOUND_ANGLE   = PI    )(
        input       logic               clk,
        input       cart_2d_coord_t     target,
        input       logic               reset,
        output      polar_2d_coord_t    unit_vector
    );
    angle_t                 lower;
    polar_2d_coord_t        mid;
    angle_t                 upper;
    cart_2d_coord_t         unit_vector_cart;
    assign mid             = '{
        radius: UNIT_RADIUS,
        theta: ((lower + upper) >> 1)
    };
    assign unit_vector_cart = polar_to_cart_2d(mid);
    assign unit_vector      = mid;
    always_ff @(posedge clk) begin 
        if (reset == 1'b1) begin 
            lower <= LOWER_BOUND_ANGLE;
            upper <= UPPER_BOUND_ANGLE;
        end else begin 
            if (det_2d(unit_vector_cart, target) > '0) begin 
                lower <= mid.theta;
            end else begin 
                upper <= mid.theta;
            end
        end
    end 
endmodule
