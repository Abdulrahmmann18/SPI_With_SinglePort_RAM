module RAM #(parameter MEM_DEPTH = 256, ADDR_SIZE = 8)
(
	input wire 		 clk,
	input wire 		 rst_n,
	input wire [9:0] din,
	input wire 		 rx_valid,
	output reg 		 tx_valid,
	output reg [7:0] dout
);
	
	
	reg [ADDR_SIZE-1:0] wr_add, rd_add;
	reg [7:0] mem [MEM_DEPTH-1:0];
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			dout <= 'b0;
			tx_valid <= 1'b0;
		end
		else if (rx_valid) begin
			case (din[9:8])
				2'b00 : wr_add <= din[7:0];
				2'b01 : mem[wr_add] <= din[7:0];
				2'b10 : rd_add <= din[7:0];
				2'b11 : begin dout <= mem[rd_add]; tx_valid <= 1; end
			endcase
		end
		else begin
			tx_valid <= 1'b0;
		end
	end


endmodule