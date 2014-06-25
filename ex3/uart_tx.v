// UART Transmitter

`include "uart_params.v"


module uart_tx(
  input wire clk,
  input wire rst,
  input wire en,
  input wire [7:0] data_out,
  output reg rdy,
  output reg dout);
  
  reg [7:0] data;
  reg [1:0] state;
  reg [2:0] cnt;
  reg [8:0] etu_cnt;
  
  wire etu_full = (etu_cnt == `UART_FULL_ETU);
  
  always @(posedge clk) begin
    
    etu_cnt <= (etu_cnt + 1);
    state <= state;
    cnt <= cnt;
    dout <= dout;
    data <= data;
    rdy <= rdy;
    
    if (rst) begin
      state <= 2'd0;
      cnt <= 3'd0;
      dout <= 1'd1;
      data <= 8'd0;
      rdy <= 1'd1;
    end
    
    case(state)
      `UART_START:
      begin
        if (en) begin
          dout <= 1'd0;
          cnt <= 3'd0;
          etu_cnt <= 9'd0;
          data <= data_out;
          state <= `UART_DATA;
          rdy <= 1'd0;
        end
      end
      
      `UART_DATA:
      begin
        if (etu_full) begin
          etu_cnt <= 9'd0;
          dout <= data[0];           // send the last bit
          cnt <= cnt + 1;           // incr. the counter
          data <= {1'b0, data[7:1]};   // shift data over

          if (cnt == 3'd7) begin
            state <= `UART_STOP;
          end
        end
      end
      
      `UART_STOP:
      begin
        if (etu_full) begin
          etu_cnt <= 9'd0;
          dout <= 1'd1;
          state <= `UART_IDLE;
        end
      end
      
      `UART_IDLE:
      begin
        if (etu_full) begin
          etu_cnt <= 9'd0;
          rdy <= 1'd1;
          state <= `UART_START;
        end
      end
      
    endcase
  end
endmodule