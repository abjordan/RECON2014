`timescale 1 ns/1 ps

module ext2_tb ();
  
// Make some testbench signals

reg tb_clk;  // clock
reg tb_rst;  // reset
reg tb_en;   // enable
wire [7:0] tb_cnt;   // output

// Create a foo_counter
foo_counter counterfoo(
  .clk(tb_clk),
  .rst(tb_rst),
  .en(tb_en),
  .cnt(tb_cnt));
  
// Set up the initial state
initial
begin
  tb_clk <= 0;
  tb_rst <= 0;
  tb_en <= 0;
  
  #250
  tb_rst <= 1'b1;
  #250
  tb_rst <= 1'b0;
  
  #250
  tb_en <= 1'b1;
  #1000
  tb_en <= 0'b0;
  
end

// Toggle the clock every 50 ns
always
begin
  #50 tb_clk <= ~tb_clk;
end

endmodule