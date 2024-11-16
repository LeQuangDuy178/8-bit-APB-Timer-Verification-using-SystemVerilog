class count_down_to_count_up extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task count_down_to_count_up::run_scenario();

  wait(dut_vif.presetn == 1'b1);
  $display("%0t: [Count up to count down] Implement test", $time);

  write(TCR_addr, 8'h00); // Clear first
  write(TCR_addr, TCR_count_down_enb);

  write(TCR_addr, TCR_clk_div_4 + TCR_default_count_down); // Count down clk div 4

  repeat (178) @(posedge dut_vif.ker_clk);
  @(posedge dut_vif.pclk);

  write(TCR_addr, TCR_stop_counter);

  //write(TCR_addr, TCR_count_down_enb);
  write(TCR_addr, TCR_clk_div_8 + TCR_default_count_up);

endtask