module SPI_Wrapper
(
	input wire  clk,
	input wire  rst_n,
	input wire  SS_n,
	input wire  MOSI,
	output wire MISO 
);

	wire [9:0] data_from_SPI_to_RAM;
	wire [7:0] data_from_RAM_to_SPI;
	wire data_from_SPI_to_RAM_valid, data_from_RAM_to_SPI_valid;

	// instantiate SPI slave module
	SPI_Slave SPI 
	(
		.MOSI(MOSI),
		.MISO(MISO),
		.SS_n(SS_n),
		.clk(clk),
		.rst_n(rst_n),
		.rx_data(data_from_SPI_to_RAM),
		.rx_valid(data_from_SPI_to_RAM_valid),
		.tx_data(data_from_RAM_to_SPI),
		.tx_valid(data_from_RAM_to_SPI_valid)
	);
	// instantiate RAM module
	RAM RAM1 
	(
		.clk(clk),
		.rst_n(rst_n),
		.din(data_from_SPI_to_RAM),
		.rx_valid(data_from_SPI_to_RAM_valid),
		.dout(data_from_RAM_to_SPI),
		.tx_valid(data_from_RAM_to_SPI_valid)
	);
	

endmodule