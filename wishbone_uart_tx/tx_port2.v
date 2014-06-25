`include "reg_defs.v"
`include "uart_tx.v"

module  krake_port_tx2(
    input wire        clk_i,
    input wire        rst_i,
    output reg        ack_o,
    input wire [7:0]  dat_i,
    input wire [3:0]  adr_i,
    output reg [7:0]  dat_o,
    input wire        stb_i,
    input wire        we_i,
    input wire [5:0]  ch_in,
    output wire [5:0]  ch_out,
    output wire [5:0]  ch_oe,
    input wire        clka,
    input wire        clkb,
    input wire        clkc,
    input wire        clkd);

reg [7:0] data;
reg tx_en;
wire tx_rdy;
reg tx_rst;
wire dout;

assign ch_oe = 6'b111111;
assign ch_out = {clk_i, ack_o, stb_i, tx_rdy, tx_en, dout};

uart_tx txi(
  .clk(clk_i),
  .rst(rst_i),
  .en(tx_en),
  .data_out(data),
  .rdy(tx_rdy),
  .dout(dout));

always @ (posedge clk_i)
begin
  if(rst_i)
  begin
    tx_rst <= 1'd1;
    data <= 8'd0;
    tx_en <= 1'd0;
  end
  else
  begin
    // Default Assignments
    ack_o <= 1'b0;
    dat_o <= 8'd0;
    tx_en <= 1'b0;
    data <= data;

    if(stb_i)
    begin
      case(adr_i)

        `UART_STATUS:
        begin
          if(we_i) // Write
          begin
            tx_en <= dat_i[0];
            ack_o <= 1'b1;
          end
          else // Read
          begin
            dat_o[0] <= tx_rdy;
            ack_o <= 1'b1;
          end
        end

        `UART_DATAREG:
        begin
          if(we_i) // Write
          begin
            data <= dat_i;
            ack_o <= 1'b1;
          end
          else // Read
          begin
            dat_o <= data;
            ack_o <= 1'b1;
          end
        end


      endcase
    end
  end
end

endmodule

