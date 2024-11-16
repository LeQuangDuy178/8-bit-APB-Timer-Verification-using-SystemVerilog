class register_write_random extends base_test;

  bit [7:0] rdata;
  packet pkt_rand = new();

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task register_write_random::run_scenario();

  wait (dut_vif.presetn == 1'b1);

  assert(pkt_rand.randomize()) else $error("Randomization failed");

  $display("Check random: 8'h%h", pkt_rand.TDR_data);
  pkt_rand.data = pkt_rand.TDR_data; // Assign TDR data randomized

  write(8'h02, pkt_rand.data);
  read(8'h02, rdata);

  $display("Check read data: 8'h%h", rdata);
  if (pkt_rand.data != 8'h44 && pkt_rand.data != 8'hdd) begin
    $display("%0t: [Register write random] Error", $time);
    error_cnt++;
  end

endtask