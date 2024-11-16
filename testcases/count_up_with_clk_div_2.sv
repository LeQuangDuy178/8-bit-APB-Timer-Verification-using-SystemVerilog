class count_up_with_clk_div_2 extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task count_up_with_clk_div_2::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t: [Count up clk div 2] Write clk_div 2 and start count up", $time);

  //write(8'h02, 8'h12);
  //read(8'h02, rdata);

  //write(8'h03, 8'h24);
  //read(8'h03, rdata);

  write(8'h00, 8'h00); // Turn off timer counter
  //write(8'h00, 8'h08); // 0b01 to [4:3] clk_div 2 and count up enable
  write(8'h00, 8'h09); // Enable counter with clk_div 2 in 1 transaction

  // Count error
  /*

  if (wdata == 8'h00) begin
                       $display("%0t: [Count up clk div 2] Test failed");

  end                    error_cnt += 1;

  */

endtask