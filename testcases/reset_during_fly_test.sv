class reset_during_fly_test extends base_test;

  bit [7:0] rdata;
  bit [7:0] wdata;

  function new();
    super.new();
  endfunction

  extern virtual task run_scenario();

endclass

task reset_during_fly_test::run_scenario();

    wait (dut_vif.presetn == 1'b1);
    $display("%0t: [Reset during fly test] Implement test", $time);

    // Perform count up
    write(TCR_addr, TCR_default_count_up);

    // Perform reset operation
    repeat (144) @(posedge dut_vif.ker_clk); // Internal count sync ker_clk
    @(posedge dut_vif.pclk); // Wait for next pclk for stability
    dut_vif.presetn = 1'b0; // Trigger reset

    // Write some signal during reset region
    // Reset will trigger internal_count to 0 (how to check it?)
    wdata = TCR_default_count_up;

    write(TCR_addr, wdata); // Enable count up to observe timer_en behavior
    @(posedge dut_vif.pclk);

    if (dut_vif.pwdata != 8'h01) begin
        $display("%0t: [Reset during fly test] Reset affects", $time);
    end

    // Deassert reset
    repeat (2) @(posedge dut_vif.pclk);
    dut_vif.presetn = 1'b1;

    // 1 APB transfer to indicate that signal can assign again
    wait (dut_vif.presetn == 1'b1);

    wdata = 8'h16;
    write(TCR_addr, wdata); // Enable APB trans
    read (TCR_addr, rdata);

    if (wdata != 8'h16) begin
        $display("[Reset during fly test] Error");
        error_cnt += 1;
        end else if (wdata == 8'h16) begin
        $display("%0t: [Reset during fly test] Reset successful", $time);
    end

endtask