`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2026 11:24:43 AM
// Design Name: 
// Module Name: comparator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module comparator(




    );
endmodule

module comparator_dataflow(

    input a,b,
    output equal,       
    output greater,
    output less
    );
    
    assign equal = (a == b) ? 1'b1 : 1'b0;
    assign greater = (a > b) ? 1'b1 : 1'b0;
    assign less = (a < b) ? 1'b1 : 1'b0;

endmodule


module comparator_structural(

    input a,b,
    output equal, greater, less
    );
    
    wire nota, notb;
    wire a_and_b, nota_and_notb;
//    wire a_and_notb, nota_and_b;
    
    not (nota,a);
    not (notb,b);
    
    and (nota_and_notb, nota, notb);    //~a & ~b
    and (a_and_b, a, b);                // a & b
    or (equal, nota_and_notb, a_and_b);
    
    and (greater, a, notb);             // a & ~b
    and (less, nota, b);                // ~a & b    

endmodule


module comparator_behavioral(
    input a, b,
    output reg equal, greater, less
    );

    always @(a,b) begin
        equal = 0;
        greater = 0;
        less = 0;

        if (a == b)
            equal = 1;
        else if (a > b)
            greater = 1;
        else
            less = 1;
    end

endmodule



module comparator_Nbit #(
    parameter N = 8
)(
    input [N-1 : 0] a,b,
    output equal ,greater, less
);

    assign equal   = (a == b) ? 1'b1 : 1'b0;
    assign greater = (a > b)  ? 1'b1 : 1'b0;
    assign less    = (a < b)  ? 1'b1 : 1'b0;

endmodule



module comparator_test_top(
    input [3:0] a,b,
    output equal, greater, less
);

    comparator_Nbit #(.N(4)) C_4(
        .a(a),
        .b(b),
        .equal(equal),
        .greater(greater),
        .less(less)
        );
endmodule