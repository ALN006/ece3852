// TODO : check if this module meets timing
module dot_product_combinational #(
    parameter   int DIMENSIONS      = 3,    // NOTE: must always be atleast 2 // TODO: consider enforcing this NOTE with an assertion
    parameter   int COORD_WIDTH     = 11,
    localparam  int RESULT_WIDTH    = 2*COORD_WIDTH + $clog2(DIMENSIONS)
) (
    input   logic signed [ COORD_WIDTH      - 1 : 0 ] vectors       [ 0 : 1 ] [ 0 : DIMENSIONS - 1 ],
    output  logic signed [ RESULT_WIDTH     - 1 : 0 ] dot_product
);
    logic signed [ 2*COORD_WIDTH - 1 : 0 ] component_products [ 0 : DIMENSIONS - 1 ];
    always_comb for ( int i = 0; i < DIMENSIONS; i++ ) begin
        component_products[i] = vectors[0][i] * vectors[1][i];
    end

    // NOTE: there is probably some more optimal reduction tree version of the bellow code but with just 3 dimensions (the first inteded use case) it kinda doesnt matter
    logic signed [ RESULT_WIDTH - 1 : 0 ] partial_sums [ 0 : DIMENSIONS - 1 ];
    always_comb begin 
        partial_sums[0] = RESULT_WIDTH'(component_products[0]);
        for ( int i = 1; i < DIMENSIONS; i++ ) begin
            partial_sums[i] = partial_sums[i-1] + RESULT_WIDTH'(component_products[i]);
        end
    end

    assign dot_product = partial_sums[DIMENSIONS - 1];

endmodule
