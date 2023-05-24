// The FSM from the prelab
module fsm(
	input 
		clk,
		start,
		reset,
		load_mem,
	output reg
		done,
	output reg [10:0]
		clock_count);

	reg [10:0] clock_count_c;
	reg done_c;
	reg state, state_c;
	parameter IDLE = 0;
	parameter RUN = 1;
	
	always@(*) begin
		if(reset) begin
			clock_count_c = 12'b0;
			done_c = 1'b0;
			state_c = IDLE;
		end else begin
			if(state == IDLE) begin
				if(start) begin
					done_c = 1'b0;
					clock_count_c = 12'b0;
					state_c = RUN;
				end else begin
					done_c = done;
					clock_count_c = clock_count;
					state_c = IDLE;
				end
			end else begin
				if(clock_count <= `STOP_COUNT) begin
					done_c = 1'b0;
					clock_count_c = clock_count + 12'b1;
					state_c = RUN;
				end else begin
					done_c = 1'b1;
					clock_count_c = clock_count;
					state_c = IDLE;
				end
			end
		end
	end

	always@(posedge clk) begin
		clock_count <= clock_count_c;
		done <= done_c;
		state <= state_c;
	end
endmodule