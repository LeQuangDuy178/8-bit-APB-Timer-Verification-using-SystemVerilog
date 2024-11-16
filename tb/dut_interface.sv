interface dut_if;

    // APB inputs
    logic ker_clk; // APB Clock
    logic pclk;    // APB Clock
    logic presetn; // Active-low reset
    logic psel;    // APB Select
    logic penable; // APB Enable
    logic pwrite;   // APB Write enable
    logic [7:0] paddr;   // APB Address
    logic [7:0] pwdata;   // APB Write data

    // APB outputs
    logic [7:0] prdata;   // APB Read data
    logic pready;  // APB Ready data
    logic interrupt; // Interrupt signal

endinterface