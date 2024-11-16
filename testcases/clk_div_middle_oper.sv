class clk_div_middle_oper extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task clk_div_middle_oper::run_scenario();

  wait(dut_vif.presetn == 1'b1);
  $display("%0t: [Clk division middle operation] Implement test", $time);

  // Clear first
  write(TCR_addr, 8'h00);

  // Start normal count up o clk division
  write(TCR_addr, TCR_default_count_up);

  // At middle operation
  repeat (81) @(posedge dut_vif.ker_clk);
  @(posedge dut_vif.pclk);

  // Stop the timer counter
  write(TCR_addr, TCR_stop_counter);

  // Configure clk division to 4 (either 2 or 8)
  write(TCR_addr, TCR_clk_div_4 + 1'b1); // Together with timer_en = 1 to enb count up
  write(TCR_addr, TCR_default_count_up); // Timer_en to 1 again to continue count up

endtask