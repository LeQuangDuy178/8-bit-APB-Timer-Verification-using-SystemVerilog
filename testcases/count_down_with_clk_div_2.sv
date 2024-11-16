class count_down_with_clk_div_2 extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task count_down_with_clk_div_2::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t: [Count down clk div 2] Implement test", $time);

  // Clear first
  write(TCR_addr, 8'h00);

  // APB transaction
  wdata = TCR_count_down_enb; // Enable count down first APB transaction
  write(TCR_addr, wdata); // Trigger initial count down data to 8'hff
  wdata = 8'h0b;
  write(TCR_addr, wdata); // Must start counter with count down and clk div 2 config

  if (wdata != TCR_count_down_enb & wdata != 8'h0b) begin
    $display("[Count down clk div 2] Error");
    error_cnt += 1;
  end

endtask