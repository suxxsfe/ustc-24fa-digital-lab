module T4_tb();
	reg clk, zero, a;
	reg [15:0] nowBus, nowA, bus;
	
	initial begin
		clk = 1;
		zero = 0;
		bus = 16'd0;
		nowBus = 16'd0;
		nowA = 16'd0;
		
		#130 zero = 1;
	end
	always @(posedge clk) begin
		if(nowBus == 0) begin
			bus = bus+1;
			a = 1;
			nowBus = bus;
			case(bus)
				16'd1: nowA = 1;
				16'd2: nowA = 1;
				16'd3: nowA = 1;
				16'd4: nowA = 3;
				16'd5: nowA = 2;
				default: nowA = 1;
			endcase
		end
		if(nowA == 0 || zero) begin
			a = 0;
		end
		nowBus = nowBus-1;
		nowA = nowA-1;
	end
	
	always begin
		#5 clk = ~clk;
	end
endmodule
