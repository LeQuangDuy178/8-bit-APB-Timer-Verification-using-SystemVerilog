class count_down_intr_udf extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  bit interrupt_flag = 1'b1;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task count_down_intr_udf::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t: [Count down interrupt enb underflow] Implement test", $time);

  // Clear first
  write(TIE_addr, 8'h00);
  write(TCR_addr, 8'h00);

  // APB trans
  write(TIE_addr, TIE_underflow_enb);

  write(TCR_addr, TCR_count_down_enb); // Enable count down first (start data 8'hff)
  write(TCR_addr, TCR_default_count_down); // Enable timer counter (count down enb)

  // Checker
  @(posedge dut_vif.interrupt);

  if (dut_vif.interrupt == interrupt_flag) begin
    $display("%0t: [Count down interrupt enb underflow] Interrupt detect", $time);
  end else begin
    $display("[Count down interrupt enb underflow] Error");
    error_cnt += 1;
  end

endtask