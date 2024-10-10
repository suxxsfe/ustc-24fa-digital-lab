module T3 #(
    parameter   MAX_VALUE = 8'd100,
	parameter	MIN_VALUE = 8'd0,
)(
    input                   clk,
    input                   rst,
	input 					enable,
    output                  out
);

reg [7:0] counter;
always @(posedge clk) begin
    if(rst || !enable) begin
        counter <= 0;
	end
    else begin
        if(counter >= MAX_VALUE || counter < MIN_VALUE) begin
            counter <= MIN_VALUE;
		end
        else begin
            counter <= counter + 8'b1;
		end
    end
end

assign out = (counter == MAX_VALUE);
endmodule
