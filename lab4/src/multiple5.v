module multiple5(
    input           [7:0]          num,
    output                         ismultiple5
);

wire [3:0] sum1, sum2, sum;
wire [1:0] sumh;
wire cout;

adder2bit addSum1(// sum1 = [1:0]+[5:4]
    .a(num[1:0]),
    .b(num[5:4]),
    .out(sum1[1:0]),
    .Cout(sum1[2])
);
adder2bit addSum2(// sum2 = [3:2]+[7:6]
    .a(num[3:2]),
    .b(num[7:6]),
    .out(sum2[1:0]),
    .Cout(sum2[2])
);

adder2bit addLow(// sum = sum1 - sum2 (2 low bit)
    .a(sum1[1:0]),
    .b(~sum2[1:0]),
    .out(sum[1:0]),
    .Cout(cout)
);

adder2bit addHigh1(// sum = sum1 - sum2 + cout (2 high bit)
    .a({0, cout}),
    .b({0, sum1[2]}),
    .out(sumh[1:0])
);
adder2bit addHigh2(
    .a(sumh[1:0]),
    .b({1, ~sum2[2]}),
    .out(sum[3:2])
);

// sum + 1 = sum1 - sum2

//-1, 4, -6
//assign ismultiple5 = (sum == 4'b1111 || sum == 4'b0100 || sum == 4'b1010);

wire [1:0] ans;

// if sum[3] = 0, positive, sum+=1
// ans + 1 = sum[3:2] - sum[1:0]
// assuming sum is 1' complement code
adder2bit getAnswer(
    .a(sum[3] ? sum[3:2] :
                {sum[2] & sum[1] & sum[0] , sum[2]^(sum[1] & sum[0])}),
    .b(sum[3] ? ~sum[1:0] : ~{sum[1]^sum[0], ~sum[0]}),
    .out(ans[1:0])
);
assign ismultiple5 = (ans == 2'b11);

endmodule
