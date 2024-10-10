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
			bus <= bus+1;
			a <= ~zero;
			nowBus <= bus;
			case(bus+1)
				16'd1: nowA <= 0;
				16'd2: nowA <= 0;
				16'd3: nowA <= 0;
				16'd4: nowA <= 2;
				16'd5: nowA <= 1;
				default: nowA <= 0;
			endcase
		end
		else if(nowA == 0) begin
			nowBus <= nowBus-1;
			nowA <= 0;
			a <= 0;
		end
		else begin
			nowBus <= nowBus-1;
			nowA <= nowA-1;
			a <= ~zero;
		end
	end
	
	always begin
		#5 clk = ~clk;
	end
endmodule
