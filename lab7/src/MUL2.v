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
    wire [WIDTH-1 : 0]     multiplicand;       // 被乘数寄存器
    wire [2*WIDTH : 0]     product;            // 乘积寄存器

    localparam IDLE = 2'b00;            // 空闲状态。这个周期寄存器保持原值不变。当 start 为 1 时跳转到 INIT。
    localparam INIT = 2'b01;            // 初始化。下个周期跳转到 CALC
    localparam CALC = 2'b10;            // 计算中。计算完成时跳转到 DONE
    localparam DONE = 2'b11;            // 计算完成。下个周期跳转到 IDLE
    reg [1:0] current_state, next_state;

    reg we, set, shift;
	integer shift_times;
    wire [WIDTH-1 : 0] next_product;
    Register #(.WIDTH(WIDTH)) reg_multiplicand(
        .clk(clk), .rst(rst || current_state == IDLE), .we(we),
        .din(a), .dout(multiplicand)
    );
    ShiftReg #(.MODE(1), .WIDTH(2*WIDTH+1)) reg_product(
        .clk(clk), .rst(rst || current_state == IDLE),
        .set(set), .en(shift),
        .din(current_state == INIT ? {0, b} : {next_product, }),
		.dout(product)
    );
    
    Adder8 adder(
        .a(product), .b(multiplicand),
        .ci(0),
        .s(next_product[2*WIDTH-1 : 0]),
		.co(next_product[2*WIDTH])
    );

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
            set = 1;
            shift = 0;
            we = 1;
			shift_times = WIDTH;
            next_state = CALC;
        end
        else if(current_state == DONE) begin
            we = 0;
            shift = 0;
            set = 0;
            res = product;
            next_state = IDLE;
        end
        else begin // CALC
            if(product[0]) begin
//                next_product = product + multiplicand;
                we = 1;
            end
            else begin
                we = 0;
            end
            
            shift = 1;
            set = 0;
			shift_times = shift_times - 1;
            
            if(shift_times == 0) begin
                next_state = DONE;
            end
        end
    end

    always @(*) begin
        finish = (current_state == DONE);
    end

endmodule
