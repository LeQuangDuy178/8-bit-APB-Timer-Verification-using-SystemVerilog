class timer_stop_load_TDR extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task timer_stop_load_TDR::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t: [Timer stop load TDR] Implement test", $time);

  // Clear first
  write(TCR_addr, 8'h00);
  write(TDR_addr, 8'h00);

  // APB transactions
  // Start normal count up
  write(TCR_addr, TCR_default_count_up);

  // During counting operation
  repeat (144) @(posedge dut_vif.ker_clk);

  @(posedge dut_vif.pclk); // In the next pclk after 144 ker_clk counter
  write(TCR_addr, TCR_stop_counter); // Stop the counter

  wdata = 8'h16;
  write(TDR_addr, wdata); // Write TDR data to TDR register

  // Checker
  if (wdata != 8'h16) begin
    $display("[Timer stop load TDR] Error");
    error_cnt += 1;
  end else if (wdata == 8'h16) begin
    $display("%0t: [Timer stop load TDR] Load TDR successful after timer stop", $time);
  end

  write(TCR_addr, TCR_load_enb); // Enable loading TDR data to TCR register
  write(TCR_addr, TCR_default_count_up); // Start counting again from TDR data

endtask