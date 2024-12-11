module Control (
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rst,
    input                   [ 0 : 0]            btn,

    input                   [ 5 : 0]            check_result,
    output      reg         [ 0 : 0]            check_start,
    output      reg         [ 0 : 0]            timer_en,
    output      reg         [ 0 : 0]            timer_set,
    input                   [ 0 : 0]            timer_finish,

    output                  [ 1 : 0]            led_sel,
    output                  [ 1 : 0]            seg_sel
);


reg win, lost;

always @(posedge clk) begin
    timer_en <= 0;
    timer_set <= 0;
    check_start <= 0;
    
    if(rst) begin
        win <= 1;
        lost <= 1;
    end else if(win || lost) begin // game over
        if(btn) begin
            win <= 0;
            lost <= 0;
            timer_set <= 1;
        end
    end else begin // game running
        if(timer_finish) begin
            lost <= 1;
        end else if(check_result == 6'b100_000) begin
            win <= 1;
        end else begin
            timer_en <= 1;
            if(btn) begin
                check_start <= 1;
            end
        end
    end
end

assign led_sel = win ? 2'b01 : (lost ? 0 : 2'b10);
assign seg_sel = win ? 2'b01 : (lost ? 2'b10 : 0);

endmodule

