# Idea of the project
the project is about the implementaion of the SPI slave (not standard) and interfacing it with single port RAM in verilog.
# Project Block Digram
![صورة واتساب بتاريخ 2024-05-12 في 06 00 39_6b7cc2b7](https://github.com/Abdulrahmmann18/SPI_With_SinglePort_RAM/assets/144833244/90b89ebf-d215-4924-b5b0-bf3655aad0a4)

# Project phases
The project passes through Four main phases :- 
### Write Address Phase 
  - Master will start the write command by sending the write address value, x_data [9:8] = din[9:8] = 2'b00.
  - SS_n = 0 to tell the SPI Slave that the master will begin communication.
  - SPI Slave check the first received bit on MOSI port 'O' which is a control bit to let the slave determine which operation will take place "write in this case". SPI Slave then expects to receive 10 more bits, the first 2 bits are "00" on two clock cycles and then the wr_address will be sent on 8 more clock cycles.
  - Now the data is converted from serial "MOSI" to parallel after writing the rx_data[9:0] bus.
  - rx valid will be HIGH to inform the RAM that it should expect data on din bus.
  - din takes the value of rx_data.
  - RAM checks on din[9:8] and find that they hold "00".
  - RAM stores din[7:0] in the internal write address bus.
  - SS_n = 1 to end communication from Master side.
### Write DATA Phase 
  - Master will continue the write command by sending the write data value, rx_data[9:8] = in[9:8] = 2'b01.
  - SS_n= 0 to tell the SPI Slave that the master will begin communication.
  - SPI Slave check the first received bit on MOSI port 'O' which is a control bit to let the slave determine which operation will take place "write in this case". SPI Slave then expects to receive 10 more bits, the first 2 bits are "01" on two clock cycles and then the wr_data will be sent on 8 more clock cycles.
  - Now the data is converted from serial "MOSI" to parallel after writing the rx_data[9:0] bus.
  - x_valid will be HIGH to inform the RAM that it should expect data on din bus.
  - din takes the value of rx_data.
  - RAM checks on din[9:8] and find that they hold "01".
  - RAM stores din[7:0] in the RAM with wr_address previously held.
  - SS_n = 1 to end communication from Master side.
### Read Address Phase
  - Master will start the read command by sending the read address value, rx_data [9:8] = din[9:8] = 2'b10.
  - SS_n = 0 to tell the SPI Slave that the master will begin communication.
  - SPI Slave check the first received bit on MOSI port '1' which is a control bit to let the slave determine which operation will take place "read in this case". SPI Slave then expects to receive 10 more bits, the first 2 bits are "10" on two clock cycles and then the rd_address will be sent on 8 more clock cycles.
  - Now the data is converted from serial "MOSI" to parallel after writing the rx_data[9:0] bus.
  - rx_ valid will be HIGH to inform the RAM that it should expect data on din bus.
  - din takes the value of rx_data.
  - RAM checks on din[9:8] and find that they hold "10".
  - RAM stores din[7:0] in the internal read address bus.
  - SS_n = 1 to end communication from Master side.
### Read DATA Phase
  - Master will continue the read command by sending the read data command, rx_data [9:8] = din[9:8] = 2'b11.
  - SS_n = 0 to tell the SPI Slave that the master will begin communication.
  - SPI Slave check the first received bit on MOSI port '1' which is a control bit to let the slave determine which operation will take place "read in this case". SPI Slave then expects to receive 10 more bits, the first 2 bits are "11" on two clock cycles and then dummy data will be sent and ignored since the master is waiting for the data to be sent from slave side.
  - Now the data is converted from serial "MOSI" to parallel after writing the rx_data[9:0] bus.
  - din takes the value of rx_data.
  - RAM reads din[9:8] and find that they hold "11".
  - RAM will read from the memory with rd_address previously held.
  - RAM will assert tx_ valid to inform slave that data out is ready.
  - Slave reads tx_data and convert it into serial out data on MISO port.
  - SS_n = 1, Master ends communication after receiving data "8 clock cycles".
