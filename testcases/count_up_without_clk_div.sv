class count_up_without_clk_div extends base_test;

  // UVM
  //`uvm_object_utils(count_up_without_clk_div);

  // Properties
  //packet pkt;
  bit [7:0] rdata;
  bit [7:0] wdata;

  // Constructor
  function new();
    super.new();
  endfunction

  // Virtual task overdriving base task
  extern virtual task run_scenario();

endclass

task count_up_without_clk_div::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t: [Count up without clk div] Implement test", $time);

  write(TCR_addr, TCR_default_count_up); // Enable counter count up without clk div

endtask