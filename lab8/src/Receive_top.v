module Receive_top(
    input                   [ 0 : 0]        clk,
    input                   [ 0 : 0]        btn,

    output                  [ 3 : 0]        seg_data,
    output                  [ 2 : 0]        seg_an,

    input                   [ 0 : 0]        uart_din
);

wire [ 7 : 0]   din_data;
wire [ 0 : 0]   din_vld;
reg  [31 : 0]   output_data;
wire rst = btn;

Receive receive (
    .clk        (clk),
    .rst        (rst),
    .din        (uart_din),
    .din_vld    (din_vld),
    .din_data   (din_data)
);

Segment segment (
    .clk            (clk),
    .rst            (rst),
    .output_data    (output_data),
    .seg_data       (seg_data),
    .seg_an         (seg_an)
);

always @(posedge clk) begin
    if (rst)
        output_data <= 32'B0;
    else if (din_vld)
        output_data <= {output_data[23:0], din_data};
end
endmodule
