class count_up_random_with_clk_div_4 extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  packet pkt_rand = new();

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task count_up_random_with_clk_div_4::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t [Count up random with clk div 4] Implement test", $time);

  // Clear first
  write(TCR_addr, 8'h00); // So that clk_div, load and count_down can configure
  write(TDR_addr, 8'h00);

  // Randomize
  assert (pkt_rand.randomize()) else $error ("Randomization failed!");

  // APB transaction
  write(TDR_addr, pkt_rand.TDR_data); // Write TDR data to TDR addr
  write(TCR_addr, 8'h04); // Enable load TDR data in
  read (TCR_addr, rdata); // 8'h04
  write(TCR_addr, 8'h11); // Start timer count with count up & clk div 4
  read (TCR_addr, rdata); // 8'h11 as it read previous apb trans

  if (pkt_rand.TDR_data != 8'hdd && pkt_rand.TDR_data != 8'h44) begin
    $display("[Count up random with clk div 4] Error");
    error_cnt += 1;
  end

endtask