// UART Receiver: Exercise 2.4

`include "uart_params.v"

module uart_rx(
  input wire clk,
  input wire rst,
  input wire din,
  output reg valid,
  output reg [7:0] data_in);
  
  reg [8:0] etu_cnt;
  reg [2:0] bit_cnt;
  reg [7:0] data;
  reg [1:0] state;
  reg starting;
  
  wire etu_full = (etu_cnt == `UART_FULL_ETU);
  wire etu_half = (etu_cnt == `UART_HALF_ETU);
  
  always @(posedge clk) begin
    
    etu_cnt <= (etu_cnt + 1);
    bit_cnt <= bit_cnt;
    
    state <= state;
    valid <= valid;
    data <= data;
    starting <= starting;
    
    if (rst) begin
      state <= `UART_START;
      bit_cnt <= 2'd0;
      etu_cnt <= 9'd0;
      data <= 8'd0;
      valid <= 1'b0;    
      data_in <= 8'd0;
    end
    
    else
    begin
      
    case (state)
      `UART_START:
      begin
        valid <= 1'd0;
        
        // If din is low, wait half an ETU, then check to see if it's low again.
        // If it is, then it's time to start reading data
        if (~din) begin
          if (~starting) begin
            starting <= 1'd1;
            etu_cnt <= 9'd0;
          end
          else  // din is low, and we've already toggled starting
          begin 
            if (etu_half) begin
              etu_cnt <= 0;
              bit_cnt <= 0;
              state <= `UART_DATA;
            end
          end
        end
        else    // din is high
        begin
          starting <= 1'd0;
        end
      end
      
      `UART_DATA:
      begin 
        if (etu_full) begin
          etu_cnt <= 9'd0;
          bit_cnt <= (bit_cnt + 1);
          
          data <= {din, data[7:1]};
          
          if (bit_cnt == 7) begin
            state <= `UART_STOP;
          end
          
        end
      end
      
      `UART_STOP:
      begin
        if (etu_full) begin
          etu_cnt <= 9'd0;
          data_in <= data;
          valid <= din;
          state <= `UART_START;
        end
      end
      
    endcase
    
    end
  end 
  
endmodule