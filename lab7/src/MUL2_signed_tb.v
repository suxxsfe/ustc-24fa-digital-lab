module MUL2_signed_tb #(
    parameter WIDTH = 32
) ();
reg  [WIDTH-1:0]    a, b;
reg                 mul_signed;
reg                 rst, clk, start;
wire [2*WIDTH-1:0]  res;
wire                finish;
integer             seed;

initial begin
    clk = 0;
    seed = 2024; // 种子值
    forever begin
        #5 clk = ~clk;
    end
end

initial begin
    rst = 1;
    start = 0;
    #20;
    rst = 0;
    #20;
    repeat (5) begin
        a = $random(seed);          
        b = $random(seed + 1);      
        mul_signed = 0;
        start = 1;
        #20 start = 0;
        #380;
        
        mul_signed = 1;
        start = 1;
        #20 start = 0;
        #380;
    end
    $finish;
end

MUL2_signed #(.WIDTH(WIDTH)) mul(
    .clk        (clk),
    .rst        (rst),
    .start      (start),
    .mul_signed (mul_signed),
    .a          (a),
    .b          (b),
    .res        (res),
    .finish     (finish)
);

reg [2*WIDTH-1 : 0] correct, correct_signed;
always @(*) begin
    correct = {{WIDTH{1'b0}}, a} * b;
    correct_signed = $signed(a) * $signed(b);
end

endmodule
