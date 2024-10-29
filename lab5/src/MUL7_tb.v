module MUL7_tb();
    reg              clk, rst;
    reg     [31 : 0] src;
    reg              src_valid;
    wire             ready, res, res_valid;

    MUL7 mul7(
        .clk(clk),
        .rst(rst),
        .src(src),
        .src_valid(src_valid),
        .ready(ready),
        .res(res),
        .res_valid(res_valid)
    );

    initial begin
        clk = 0;
        rst = 0;
        src_valid = 0;
        
        #10
        src = 32'd7000;
        src_valid = 1;
        
        #10
        src_valid = 0;
        
        #340
        src = 32'd7001;
        src_valid = 1;
        
        #10
        src_valid = 0;
        
        #340
        rst = 1;
        
        #20
        rst = 0;
        src = 32'd77777;
        src_valid = 1;
        
        #20
        src_valid = 0;
        
        
        $finish;
    end
    always #5 clk = ~clk;
endmodule
