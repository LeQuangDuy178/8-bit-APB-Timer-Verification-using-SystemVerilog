class register_default_value_test extends base_test;

  bit [7:0] rdata;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task register_default_value_test::run_scenario();

  wait (dut_vif.presetn == 1'b1);

  read(8'h00, rdata); // Wait for event, while still report error once
  read(8'h01, rdata);
  read(8'h02, rdata);
  read(8'h03, rdata);

  // Checker (reference model when capturing interrupt)
  if (rdata != 8'h00) begin
    $display("%0t: [Register default] Error", $time);
    error_cnt++;
  end
  //env.sco.report(error_cnt);

endtask