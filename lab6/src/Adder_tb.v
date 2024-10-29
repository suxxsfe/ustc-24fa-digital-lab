module Adder_tb();
    reg [31:0] a, b;
    reg ci;
    wire [31:0] s;
    wire co;
    
    Adder adder(
        .a(a),
        .b(b),
        .ci(ci),
        .s(s),
        .co(co)
    );
    
    initial begin
        a = 32'hffff; b = 32'hffff; ci = 1'b1;
        #10;
        a = 32'h0f0f; b = 32'hf0f0; ci = 1'b1;
        #10;
        a = 32'h1234; b = 32'h4321; ci = 1'b0;
        #10
        a = 32'h2222_ffff; b = 32'heeee_ffff; ci = 1'b0;
    end
    
endmodule
