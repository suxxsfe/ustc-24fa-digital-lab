module MUL2_signed #(
    parameter                               WIDTH = 32
) (
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rst,
    input                   [ 0 : 0]            start,
    input                                       mul_signed,
    input                   [WIDTH-1 : 0]       a,
    input                   [WIDTH-1 : 0]       b,
    output                  [2*WIDTH-1:0]       res,
    output      reg         [ 0 : 0]            finish
);
    reg [WIDTH-1 : 0]     multiplicand;       // 被乘数寄存器
    reg [2*WIDTH : 0]     product;            // 乘积寄存器

    localparam IDLE = 2'b00;            // 空闲状态。这个周期寄存器保持原值不变。当 start 为 1 时跳转到 INIT。
    localparam INIT = 2'b01;            // 初始化。下个周期跳转到 CALC
    localparam CALC = 2'b10;            // 计算中。计算完成时跳转到 DONE
    localparam DONE = 2'b11;            // 计算完成。下个周期跳转到 IDLE
    reg [1:0] current_state, next_state;

    reg [$clog2(WIDTH) : 0] shift_times;
    wire [WIDTH : 0] next_product;
    
    Adder8 #(.WIDTH(WIDTH)) adder(
        .a(product[2*WIDTH-1 : WIDTH]), .b(multiplicand),
        .ci(0),
        .s(next_product[WIDTH-1 : 0]),
        .co(next_product[WIDTH])
    );
    
    wire [WIDTH-1 : 0] a_signed, b_signed;
    Adder8 #(.WIDTH(WIDTH)) adderA(
        .a(mul_signed && a[WIDTH-1] ? ~a : a),
        .b(0),
        .ci(mul_signed && a[WIDTH-1] ? 1 :0),
        .s(a_signed)
    );
    Adder8 #(.WIDTH(WIDTH)) adderB(
        .a(mul_signed && b[WIDTH-1] ? ~b : b),
        .b(0),
        .ci(mul_signed && b[WIDTH-1] ? 1 :0),
        .s(b_signed)
    );
    
    reg [2*WIDTH-1 : 0] res_unsigned;
    reg sign;
    Adder8 #(.WIDTH(2*WIDTH)) adderRes(
        .a(sign ? ~res_unsigned : res_unsigned),
        .b(0),
        .ci(sign ? 1 : 0),
        .s(res)
    );
    
    always @(posedge clk) begin
        if(rst || current_state == IDLE) begin
            product <= 0;
            multiplicand <= 0;
        end
        if(current_state == INIT) begin
            product <= {{(WIDTH+1){1'b0}}, b_signed};
            multiplicand <= a_signed;
            shift_times <= 0;
        end
        else if(current_state == CALC) begin
            shift_times <= shift_times+1;
            if(product[0]) begin
                product <= {1'b0, next_product, product[WIDTH-1 : 1]};
            end
            else begin
                product <= {1'b0, product[2*WIDTH : 1]};
            end
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end
    
    always @(*) begin
        next_state = current_state;
        if(current_state == IDLE) begin
            if(start) begin
                next_state = INIT;
            end
        end
        else if(current_state == INIT) begin
            next_state = CALC;
        end
        else if(current_state == DONE) begin
            sign = mul_signed && (a[WIDTH-1] ^ b[WIDTH-1]);
            res_unsigned = product;
            next_state = IDLE;
        end
        else begin // CALC
            if(shift_times == WIDTH-1) begin
                next_state = DONE;
            end
        end
    end

    always @(*) begin
        finish = (current_state == DONE);
    end

endmodule
