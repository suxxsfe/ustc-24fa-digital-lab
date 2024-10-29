module MUL7(
    input                               clk,            // 时钟信号
    input                               rst,            // 复位信号，使状态机回到初始态
    input               [31 : 0]        src,            // 输入数据
    input                               src_valid,      // 表明输入结果是否有效
    output                              ready,          // 表明是否正在检测
    output                              res,            // 输出结果
    output                              res_valid       // 表明输出结果是否有效
);

    reg [5:0] currentPos, nextPos;
    reg [2:0] currentState, nextState;
    
    parameter RESET_STATE = 3'b000, RESET_POS = 6'b10_0000;
    parameter [3*7-1:0] TRANS0 = {3'd5, 3'd3, 3'd1, 3'd6, 3'd4, 3'd2, 3'd0};
    parameter [3*7-1:0] TRANS1 = {3'd6, 3'd4, 3'd2, 3'd0, 3'd5, 3'd3, 3'd1};
    
    initial begin
        currentPos <= RESET_POS;
        currentState <= RESET_STATE;
    end
    
    always @(posedge clk) begin
        if(rst) begin
            currentState <= RESET_STATE;
            currentPos <= RESET_POS;
        end
        else begin
            currentState <= nextState;
            currentPos <= nextPos;
        end
    end
    
    always @(*) begin
        nextPos = currentPos;
        nextState = currentState;
        
        if(currentPos == 0 && src_valid) begin
            currentPos = RESET_POS;
            currentState = RESET_STATE;
        end
        
        if((currentPos != RESET_POS && currentPos != 0) || src_valid) begin
            nextPos = currentPos - 1;
            if(src[currentPos - 1]) begin
                nextState = {TRANS1[currentState * 3 + 2], TRANS1[currentState * 3 + 1],
                             TRANS1[currentState * 3]};
            end
            else begin
                nextState = {TRANS0[currentState * 3 + 2], TRANS0[currentState * 3 + 1],
                             TRANS0[currentState * 3]};
            end
        end
    end 
    
    assign ready = currentPos == 0 || currentPos == RESET_POS;
    assign res_valid = currentPos == 0;
    assign res = currentState == 0;

endmodule
