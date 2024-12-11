module Check(
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rst,

    input                   [11 : 0]            input_number,
    input                   [11 : 0]            target_number,
    input                   [ 0 : 0]            start_check,

    output                  [ 5 : 0]            check_result
);

wire [3: 0] out1, out2, out3, ans1, ans2, ans3;
assign out1 = input_number[11: 8];
assign out2 = input_number[7: 4];
assign out3 = input_number[3: 0];
assign ans1 = target_number[11: 8];
assign ans2 = target_number[7: 4];
assign ans3 = target_number[3: 0];

wire [1: 0] correct_number, correct_pos;
assign correct_pos = (out1 == ans1) + (out2 == ans2) + (out3 == ans3);
assign correct_number = (out1 != ans1 && (out1 == ans2 || out1 == ans3)) +
                        (out2 != ans2 && (out2 == ans1 || out2 == ans3)) +
                        (out3 != ans3 && (out3 == ans1 || out3 == ans2));

wire [5: 0] result;
assign result[5] = correct_pos == 2'd3;
assign result[4] = correct_pos == 2'd2;
assign result[3] = correct_pos == 2'd1;
assign result[2] = correct_number == 2'd3;
assign result[1] = correct_number == 2'd2;
assign result[0] = correct_number == 2'd1;

assign check_result = start_check ? result : check_result;

endmodule

