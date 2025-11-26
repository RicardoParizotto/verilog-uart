/*
========================================================
Description: Basic UART receiver module.
========================================================
*/
module serial(
    input CLOCK_50,
    input UART_RXD,           //Receiver input
	output UART_TXD,          //transmit output
	input [7:0] SW,
    output wire [7:0] LEDR,
	output  reg [3:0] KEY,
    output wire data_valid, // The single-cycle pulse when data is ready
    output wire [7:0] rx_byte // The actual received 8-bit data
);

reg debug_latch = 1'b0;
wire rx_done_pulse;
wire [7:0] LEDR_local;      
reg tx_byte_local; 
reg [7:0] tx_data_reg;
reg sw1_prev;
wire sw1_rise;
wire is_transmitting_w; 

assign sw1_rise = SW[1] & ~sw1_prev;

uart uart0(
    .clk(CLOCK_50),              // Connects to CLOCK_50
    .rst(SW[0]),                 // Connects reset to switch 0 SW[0] 
    .rx(UART_RXD),               // Connects to UART_RXD
    .tx(UART_TXD),               // Working TX output
    .transmit(tx_byte_local),    // Connects to the need of transmitting
    .tx_byte(tx_data_reg),       // Data to transmit
    .received(rx_done_pulse),    // The signal is high when a byte is ready
    .rx_byte(rx_byte),           // The 8-bit received byte
    .is_receiving(),             // Unused 
    .is_transmitting(is_transmitting_w),          // Unused 
    .recv_error()                // Unused 
);

always @(posedge CLOCK_50) begin	
	sw1_prev <= SW[1];
    //do not start transmit if is already transmiting
	if(SW[1] == 1'b1 && ~is_transmitting_w) begin
	   tx_byte_local <= 1'b1;          //signal to start transmiting when switch is high
       tx_data_reg <= 8'h41;           //data to transmit
   end else
	   tx_byte_local <= 1'b0; 
end

endmodule