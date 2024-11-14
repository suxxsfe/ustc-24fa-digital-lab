module ShiftReg #(
    parameter                   WIDTH           = 32,
    parameter                   MODE            = 0     // 为 0 代表左移，为 1 代表右移
)(
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rst,

    input                   [WIDTH-1: 0]        din,
    input                   [ 0 : 0]            set,    // 置位信号
    input                   [ 0 : 0]            en,     // 移位信号
    output      reg         [WIDTH-1: 0]        dout
);
    
    reg [WIDTH-1 : 0] num;
    always @(posedge clk) begin
        if(rst) begin
            num <= 0;
            dout <= 0;
        end
        else if(set) begin
            num <= din;
            dout <= din;
        end
        else if(en) begin
            dout <= MODE ? num >> 1 : num << 1;
            num <= MODE ? num >> 1 : num << 1;
        end
    end

endmodule
