module RegFile(
    input                       clk,          // 时钟信号
    input           [4:0]       ra1,          // 读端口 1 地址
    input           [4:0]       ra2,          // 读端口 2 地址
    input           [4:0]       wa,           // 写端口地址
    input                       we,           // 写使能信号
    input           [31:0]      din,          // 写数据
    output          [31:0]      dout1,        // 读端口 1 数据输出
    output          [31:0]      dout2         // 读端口 2 数据输出
);

    reg [31:0] reg_file[31:0];

    initial begin
        reg_file[0] = 0;
    end

    assign dout1 = (we && wa && ra1 == wa) ? din: reg_file[ra1];
    assign dout2 = (we && wa && ra2 == wa) ? din: reg_file[ra2];

    always @(posedge clk) begin
        if(we && wa) begin
            reg_file[wa] <= din;
        end
    end

endmodule
