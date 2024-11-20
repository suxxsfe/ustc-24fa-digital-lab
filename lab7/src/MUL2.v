module MUL2 #(
    parameter                               WIDTH = 32
) (
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rst,
    input                   [ 0 : 0]            start,
    input                   [WIDTH-1 : 0]       a,
    input                   [WIDTH-1 : 0]       b,
    output      reg         [2*WIDTH-1:0]       res,
    output      reg         [ 0 : 0]            finish
);
    reg [WIDTH-1 : 0]     multiplicand;       // 被乘数寄存器
    reg [2*WIDTH : 0]     product;            // 乘积寄存器

    localparam IDLE = 2'b00;            // 空闲状态。这个周期寄存器保持原值不变。当 start 为 1 时跳转到 INIT。
    localparam INIT = 2'b01;            // 初始化。下个周期跳转到 CALC
    localparam CALC = 2'b10;            // 计算中。计算完成时跳转到 DONE
    localparam DONE = 2'b11;            // 计算完成。下个周期跳转到 IDLE
    reg [1:0] current_state, next_state;

    integer shift_times;
    wire [WIDTH : 0] next_product;
    
    Adder8 #(.WIDTH(WIDTH)) adder(
        .a(product[2*WIDTH-1 : WIDTH]), .b(multiplicand),
        .ci(0),
        .s(next_product[WIDTH-1 : 0]),
        .co(next_product[WIDTH])
    );
    
    always @(posedge clk) begin
        if(rst || current_state == IDLE) begin
            product <= 0;
            multiplicand <= 0;
        end
        if(current_state == INIT) begin
            product <= {{(WIDTH+1){1'b0}}, b};
            multiplicand <= a;
        end
        else if(current_state == CALC) begin
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
            shift_times = WIDTH;
            next_state = CALC;
        end
        else if(current_state == DONE) begin
            res = product;
            next_state = IDLE;
        end
        else begin // CALC
            if(shift_times == 0) begin
                next_state = DONE;
            end
            shift_times = shift_times - 1;
        end
    end

    always @(*) begin
        finish = (current_state == DONE);
    end

endmodule
