module foo_counter(
  input wire clk,
  input wire rst,
  input wire en,
  output reg [7:0] cnt);
  
always @(posedge clk)
begin
  // Synchronous reset
  if (rst)
  begin
    cnt <= 8'd0;
  end
  else
  begin
    if (en)
    begin
      cnt <= cnt + 1;
    end
    else
    begin
      cnt <= cnt;
    end
  end
end

endmodule