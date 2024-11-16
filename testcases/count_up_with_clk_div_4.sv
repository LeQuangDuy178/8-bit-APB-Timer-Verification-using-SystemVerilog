class count_up_with_clk_div_4 extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task count_up_with_clk_div_4::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t: [Count up with clk div 4] Implement test", $time);

  write(8'h00, 8'h00);
  write(8'h00, 8'h11); // Enable counter count up with clk div 4

endtask