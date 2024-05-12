module serial_to_parallel 
(
	input wire 		  clk,
	input wire 		  rst_n,
	input wire 		  Enable,
	input wire 		  serial_in,
	output reg [9:0]  parallel_data,
	output reg 	  	  data_valid
);

	reg [3:0] counter;
	reg [9:0] temp_reg;

	// serial to parallel conversion 
	/* **************************************************** */
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			// reset
			temp_reg <= 10'b0;
			counter  <= 4'b0; 
			parallel_data <= 10'b0;
		end
		else if (Enable) begin
			if (counter != 4'd10) begin
				temp_reg <= {temp_reg[9:0], serial_in} ;
				counter  <= counter + 1;
				data_valid <= 1'b0;
			end
			else begin
				parallel_data <= temp_reg;
				data_valid <= 1'b1;
				counter <= 4'b0;
			end	
		end
		else begin
			data_valid <= 1'b0;
		end
	end
	/* **************************************************** */


endmodule