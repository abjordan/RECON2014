`timescale 1 ns/1 ps // Set the timescale for the simluation
module ex3_tb ();

// Create the testbench signals
reg		 tb_clk, tb_rst, tb_en;
wire  rdy;
wire  tb_dout;
wire  tb_valid;
reg [7:0] tb_cnt;
wire [7:0] tb_data_in;

// Instantiate the foo_counter module (cnti)
uart_tx txi(
		.clk(tb_clk),
		.rst(tb_rst),
		.data_out(tb_cnt),
		.en(tb_en),
		.rdy(rdy),
		.dout(tb_dout));

uart_rx rxi(
    .clk(tb_clk),
    .rst(tb_rst),
    .din(tb_dout),
    .valid(tb_valid),
    .data_in(tb_data_in));

initial
begin
	tb_clk <= 1'b0;
	tb_rst <= 1'b0;
	tb_en <= 1'b0;
	tb_cnt <= 8'd0;
end

// Generate a 50MHz clock
always
begin
	#10 tb_clk <= ~tb_clk;
end

// After 2 clock cycles reset for 2 clock cycles
initial
begin
	#40 tb_rst <= 1'b1;
	#40 tb_rst <= 1'b0;
end

always @(posedge tb_clk)
begin
	tb_en <= 1'b0;

	if(tb_en == 1'b0 && rdy == 1'b1)
	begin
		tb_cnt <= tb_cnt + 1;
		tb_en <= 1'b1;
	end
end


endmodule