class count_down_random_with_clk_div_8 extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  packet pkt_rand = new();
  bit [7:0] count_down_clk_div_8 = 8'h1b;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task count_down_random_with_clk_div_8::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t: [Count down rand clk div 8] Implement test", $time);

  // Clear first
  write(TCR_addr, 8'h00);
  write(TDR_addr, 8'h00);

  // Randomize
  assert(pkt_rand.randomize()) else $error ("Randomization failed");

  // APB transactions
  //write(TIE_addr, TIE_underflow_enb); // Enable interrupt trigger alongside undf

  wdata = pkt_rand.TDR_data;
  write(TDR_addr, wdata); // Write TDR data to TDR addr

  read (TCR_addr, rdata); // Read data
  write(TCR_addr, TCR_load_enb); // Enable Load data from TDR to TCR

  write(TCR_addr, TCR_count_down_enb); // Enable count down
  write(TCR_addr, count_down_clk_div_8);
  read (TCR_addr, rdata);

  if (wdata != 8'h44 && wdata != 8'hdd) begin
    $display("[Count down rand clk div 8] Error");
    error_cnt += 1;
  end

endtask