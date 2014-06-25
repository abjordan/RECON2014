`define UART_START      2'd0
`define UART_DATA       2'd1
`define UART_STOP       2'd2
`define UART_IDLE       2'd3
`define SYSTEM_CLOCK    50000000

`define UART_FULL_ETU (`SYSTEM_CLOCK/115200)
`define UART_HALF_ETU ((`SYSTEM_CLOCK/115200)/2)