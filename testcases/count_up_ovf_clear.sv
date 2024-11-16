class count_up_ovf_clear extends base_test; // extends uvm_test

  bit [7:0] rdata;
  bit [7:0] wdata;

  bit interrupt_flag = 1'b1;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task count_up_ovf_clear::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t: [Count up interrupt, overflow clear] Implement test", $time);

  // Clear first
  write(TCR_addr, 8'h00);
  write(TIE_addr, 8'h00);
  write(TSR_addr, 8'h00);

  // APB trans
  write(TIE_addr, TIE_overflow_enb); // Enable interrupt trigger alongside overflow
  write(TCR_addr, TCR_default_count_up); // Clear overflow status
  write(TSR_addr, TSR_overflow_clear); // Clear overflow status

  // Observe APB interrupt
  @(posedge dut_vif.interrupt); // wait for interrupt trigger
  write(TCR_addr, 8'h00); // Stop counting
  write(TSR_addr, TSR_overflow_clear); // Clear overflow status at this timestamp

  // Checker: compare interrupt flag for error check
  // No need skip 4 posedge pclk because drv event is called from the API write
  @(posedge dut_vif.pclk); // wait 4 pclk tick for 2 write transaction

  if (dut_vif.interrupt != interrupt_flag) begin // interrupt already clear
    $display("%0t: [Count up interrupt, overflow clear] Clear ovf successful", $time);
  end else begin
    $display("[Count up interrupt, overflow clear] Error");
    error_cnt += 1;
  end

endtask