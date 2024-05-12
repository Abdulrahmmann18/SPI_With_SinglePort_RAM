module parallel_to_serial 
(
	input wire 		 clk,
	input wire		 rst_n,
	input wire [7:0] parallel_in,
	input wire 		 tx_valid,
	input wire 		 SS_n,
	output reg 		 serial_out
);

	// parallel to serial conversion
	/* **************************************************** */
	reg [3:0] tx_counter;
	reg [7:0] temp_reg;
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			// reset
			serial_out <= 1'b0;
			tx_counter <= 4'b0; 
			temp_reg   <= 8'b0;
		end
		else if (tx_valid) begin
			temp_reg <= parallel_in;
			tx_counter <= 4'b0;
		end
		else if (~SS_n) begin
			if (tx_counter != 4'd8) begin
				serial_out <= temp_reg[7-tx_counter];  // transmit from MSB first
				tx_counter <= tx_counter + 1;
			end
			else
				tx_counter <= 4'b0;
		end
		else begin
			tx_counter <= 4'b0;
		end	

	end
endmodule
	/* **************************************************** */