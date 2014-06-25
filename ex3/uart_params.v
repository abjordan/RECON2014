`define UART_START      3'd0
`define UART_DATA       3'd1
`define UART_STOP       3'd2
`define UART_IDLE       3'd3
`define UART_IDLE2      3'd4
`define SYSTEM_CLOCK    50000000

`define UART_FULL_ETU (`SYSTEM_CLOCK/115200)
`define UART_HALF_ETU ((`SYSTEM_CLOCK/115200)/2)