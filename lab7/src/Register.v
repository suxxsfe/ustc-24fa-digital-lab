module Register #(
    parameter                   WIDTH           = 32
) (
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rst,

    input                   [WIDTH-1: 0]        din,
    input                   [ 0 : 0]            we,     // 写使能信号
    output      reg         [WIDTH-1: 0]        dout
);

    always @(posedge clk) begin
        if(rst) begin
            dout <= 0;
        end
        else if(we) begin
            dout <= din;
        end
    end

endmodule
