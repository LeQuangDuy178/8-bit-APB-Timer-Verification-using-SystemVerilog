class count_up_intr_ovf extends base_test; // extends uvm_test

  bit [7:0] rdata;
  bit [7:0] wdata;

  bit interrupt_flag = 1'b1;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task count_up_intr_ovf::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t: [Count up interrupt enable with overflow] Implement test", $time);

  // Clear first
  write(TCR_addr, 8'h00);
  write(TIE_addr, 8'h00);

  // APB trans
  write(TIE_addr, TIE_overflow_enb); // Enable interrupt trigger alongside overflow
  write(TCR_addr, TCR_default_count_up);

  // Observe APB interrupt
  // Finish count up
  @(posedge dut_vif.interrupt); // Wait 1 more pclk tick

  // Checker: compare interrupt flag for error check
  if (interrupt_flag == dut_vif.interrupt) begin
    $display("%0t: [Count up interrupt enb with overflow] Interrupt detect", $time);
  end else begin
    $display("[Count up interrupt enb with overflow] Error");
    error_cnt += 1;
  end

endtask