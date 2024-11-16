class reserved_region_test extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task reserved_region_test::run_scenario();

  wait (dut_vif.presetn == 1'b1);
  $display("%0t: [Testbench] Reserved region test", $time);

  // Write data to reserved region of each register then read them
  // Exclude TDR not having any reserved region
  write(TCR_addr, 8'he0); // 8'b11100000
  read (TCR_addr, rdata);

  write(TSR_addr, 8'hfc);
  read (TSR_addr, rdata); // Perform by hardware, clear by software

  write(TIE_addr, 8'hfc); // 8'b11111100
  read (TIE_addr, rdata);

  if (rdata == 8'h00) begin
    $display("%0t: [Reserved region test] Reserved region check successful", $time);
  end else begin
    $display("[Reserved region test] Error");
    error_cnt += 1;
  end

endtask