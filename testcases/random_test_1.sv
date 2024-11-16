class random_test_1 extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  packet pkt_rand = new();

  bit interrupt_flag = 1'b1;

  extern virtual task run_scenario();

endclass

task random_test_1::run_scenario();

    wait(dut_vif.presetn == 1'b1);

    // Start randomize packet
    assert
    (pkt_rand.randomize()) else $error("Randomization failed");

    // Clear first
    write(TCR_addr, 8'h00); // Enable TCR configuration
    write(TSR_addr, 8'h00);
    write(TDR_addr, 8'h00);
    write(TIE_addr, 8'h00);

    // APB transaction
    // 1st: write random data to TDR
    write(TDR_addr, pkt_rand.TDR_data);
    read (TDR_addr, rdata); // Read it

    // 2nd: load TDR data to TCR
    write(TCR_addr, TCR_load_enb);

    // 3rd: Random TCR instruction (with timer_en = 0)
    write(TCR_addr, pkt_rand.TCR_data);

    // 4th: Random TIE data (underflow en or overflow_en)
    write(TIE_addr, pkt_rand.TIE_data);

    // 5th: Start counter
    write(TCR_addr, pkt_rand.TCR_data_count_enb);

    // 6th: At interrupt posedge, clear ovf/udf and interrupt
    @(posedge dut_vif.interrupt);
    write(TSR_addr, pkt_rand.TSR_data);

    // Clk div is configure but cannot be applied to counter
    // Since count_enb has configured the clk_div back to 0

endtask