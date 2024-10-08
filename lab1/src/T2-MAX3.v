module MAX3(
    input       [7:0]         num1, num2, num3,
    output reg  [7:0]         max
);

always @(*) begin
    if(num1 >= num2 && num1 >= num3) begin
        max = num1;
    end
    else if(num2 >= num1 && num2 >= num3) begin
        max = num2;
    end
    else begin
        max = num3;
    end
end

endmodule
