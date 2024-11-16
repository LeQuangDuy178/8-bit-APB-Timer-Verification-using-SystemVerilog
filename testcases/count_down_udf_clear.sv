class count_down_udf_clear extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  bit interrupt_flag = 1;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task count_down_udf_clear::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t: [Count down intr, underflow clear] Implement test", $time);

  // Clear first
  write(TIE_addr, 8'h00);
  write(TCR_addr, 8'h00);
  write(TSR_addr, 8'h00);

  // APB trans
  write(TIE_addr, TIE_underflow_enb);
  write(TCR_addr, TCR_count_down_enb);
  write(TCR_addr, TCR_default_count_down);

  @(posedge dut_vif.interrupt);
  write(TSR_addr, TSR_underflow_clear); // Clear underflow next pclk

  // Checker
  @(posedge dut_vif.pclk); // Wait 1 more pclk
  if (dut_vif.interrupt != interrupt_flag) begin
    $display("%0t: [Count down intr, underflow clear] Udf clear successful", $time);
  end else begin
    $display("[Count down intr, underflow clear] Error");
    error_cnt += 1;
  end

endtask