module SPI_Slave
(
	input wire 		  MOSI,
	input wire 		  SS_n,
	input wire 		  clk, rst_n,
	input wire 		  tx_valid,
	input wire  [7:0] tx_data,
	output wire 	  MISO,
	output wire 	  rx_valid,
	output wire [9:0] rx_data 
);
	// parameters for the states
	localparam IDLE    = 2'b00,
			   CHK_CMD = 2'b01, 
			   WRITE   = 2'b10,
			   READ    = 2'b11;
	
	
	// wires for current and next state
	reg [1:0] CS, NS;


	// state memory
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) 
			CS <= IDLE;	 
		else 
			CS <= NS;
	end

	
	
	wire Serial_To_Parallel_enable;
	assign Serial_To_Parallel_enable = ((CS == WRITE) || (CS == READ)) ? 1'b1 : 1'b0 ;
	// next state logic
	always @(*) begin
		NS = IDLE;
		case (CS)
			IDLE :
			begin
				if (SS_n) 
					NS = IDLE;
				else 
					NS = CHK_CMD;
			end

			CHK_CMD : 
			begin
				if (SS_n)
					NS = IDLE;
				else begin 
					if (~MOSI)
						NS = WRITE;				
					else 
						NS = READ;
				end  
			end

			WRITE :
			begin
				if (SS_n)
					NS = IDLE;
				else 
					NS = WRITE;
			end

			READ :
			begin
				if (SS_n)
					NS = IDLE;
				else 
					NS = READ;
			end
			
			default :
			begin
				NS = IDLE;
			end
		endcase
	end
	// serial to parallel conversion
	serial_to_parallel SER_TO_PAR
	(
		.clk(clk),
		.rst_n(rst_n),
		.Enable(Serial_To_Parallel_enable),
		.serial_in(MOSI),
		.parallel_data(rx_data),
		.data_valid(rx_valid)
	);	


	// parallel to seial conversion
	parallel_to_serial  PAR_TO_SER
	(
		.clk(clk),
		.rst_n(rst_n),
		.parallel_in(tx_data),
		.tx_valid(tx_valid),
		.SS_n(SS_n),
		.serial_out(MISO)
	);
endmodule