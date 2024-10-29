module ALU_tb();
    
    reg [31:0] src0, src1;
    reg [11:0] sel;
    wire [31:0] res;
    
    ALU alu(
        .src0(src0),
        .src1(src1),
        .sel(sel),
        .res(res)
    );
    
    initial begin
        src0=32'hffff; src1=32'hfeff; sel=12'h001;
        repeat(11) begin
            #30 sel = sel << 1;
        end
        
        #90
        src0=32'h2222_ffff; src1=32'heeee_feff; sel=12'h001;
        repeat(11) begin
            #30 sel = sel << 1;
        end
        
        #90
        src0 = 32'hffff; src1 = 32'h1; sel = 12'h8;
        
        #30
        src0 = 32'h1; src1 = 32'h0; sel = 12'h8;
        
        #30
        src0 = 32'hffff; src1 = 32'hfffe; sel = 12'h8;
        
        #30
        src0 = 32'h0; src1 = 32'hffff; sel = 12'h8;
        
        #30
        src0 = 32'hffff_ffff; src1 = 32'hffff_fffe; sel = 12'h4;
    end

endmodule
