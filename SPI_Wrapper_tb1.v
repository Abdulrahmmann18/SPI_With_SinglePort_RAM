module SPI_Wrapper_tb1();

	
	//////////////////// signal declaration /////////////////////////
	reg clk, rst_n, MOSI, SS_n;
	wire MISO_DUT;
	/////////////////////////////////////////////////////////////////
	

	
	///////////////////// DUT instantiation /////////////////////////
	SPI_Wrapper DUT(clk, rst_n, SS_n, MOSI, MISO_DUT);
	/////////////////////////////////////////////////////////////////
	

	
	////////////////////// clk generation block ////////////////////
	initial begin
		clk = 0;
		forever
			#1 clk = ~clk;
	end
	/////////////////////////////////////////////////////////////////
	

	
	/////////////////////////// initial block ///////////////////////
	integer i;
	initial begin
		INITIALIZE_TASK();
		RST_TASK();
		OPERATION(3'b000, 8'h55); // rx_data = address of 55H (write address)
		@(negedge clk)
		OPERATION(3'b001, 8'hAA); // rx_data = data of AAH to be stored in address of 55H
		@(negedge clk)
		OPERATION(3'b110, 8'h55); // rx_data = address of 55H (read address)
		@(negedge clk)
		OPERATION(3'b111, 8'h55); // rx_data = dummy data , Tx_da = AAH
		@(negedge clk)
		CHECK_MISO_OUTPUT(8'hAA);
		#10
		$stop;
	end
	/////////////////////////////////////////////////////////////////
	

	
	////////////////////////////// TASKS ////////////////////////////
	 
	task RST_TASK;
		begin
			rst_n = 1'b0;
			@(negedge clk);
			@(negedge clk);
			rst_n = 1'b1;
		end
	endtask

	task INITIALIZE_TASK;
		begin
			MOSI = 1'b1;
			SS_n = 1'b1;
		end
	endtask

	task OPERATION;
		input [2:0] OperationBits;
		input [7:0] DATA;
		begin
			// start of communication
			SS_n = 0;
			@(negedge clk)
			MOSI = OperationBits[2]; // first bit on MOSI to determine the operation type (write or read)
			@(negedge clk)
			MOSI = OperationBits[1]; // din[9]
			@(negedge clk)
			MOSI = OperationBits[0]; // din[8]
			for (i=0; i<8; i=i+1) begin
				@(negedge clk)
				MOSI = DATA[7-i];  // send MSB first
			end
			// end of communication
			@(negedge clk);
			SS_n = 1'b1; 
		end
	endtask

	task CHECK_MISO_OUTPUT;
		input [7:0] tx_data;
		begin
			@(negedge clk);
			@(negedge clk);
			// start of communication
			SS_n = 0;
			for (i=0; i<8; i=i+1) begin
				@(negedge clk);
				if (MISO_DUT != tx_data[7-i]) begin
					$display("error in MISO transmit, check the waveform");
				end
			end
			// end of communication
			SS_n = 1'b1;
		end
	endtask
	/////////////////////////////////////////////////////////////////
	
	 

endmodule