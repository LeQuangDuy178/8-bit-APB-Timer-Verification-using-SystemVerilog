`timescale 1ns/1ps

module testbench;
    import timer_pkg::*;
    import test_pkg::*;

    dut_if d_if();

    timer_top u_dut (
    .ker_clk(d_if.ker_clk),
    .pclk(d_if.pclk),
    .presetn(d_if.presetn),
    .psel(d_if.psel),
    .penable(d_if.penable),
    .pwrite(d_if.pwrite),
    .paddr(d_if.paddr),
    .pwdata(d_if.pwdata),
    .prdata(d_if.prdata),
    .pready(d_if.pready),
    .interrupt(d_if.interrupt));

    // Internal counter assign
    bit [7:0] internal_count;

    assign internal_count = u_dut.u_counter.cnt;

    // Clock in division of ker_clk
    bit clk_in;
    assign clk_in = u_dut.u_counter.clk_in;

    // Define parent test and various child tests
    base_test base = new();
    count_up_without_clk_div cu_wo_cd = new();
    count_up_with_clk_div_2 cu_w_cd2 = new();
    register_default_value_test reg_default = new();
    register_write_random reg_wr_rand = new();
    count_up_with_clk_div_4 cu_w_cd4 = new();
    count_up_with_clk_div_8 cu_w_cd8 = new();
    count_up_random_with_clk_div_4 cu_rand_w_cd4 = new();
    count_down_with_clk_div_2 cd_w_cd2 = new();
    count_down_random_with_clk_div_8 cd_rand_w_cd8 = new();
    count_up_intr_ovf cu_ovf_intr = new();
    count_down_intr_udf cd_intr_udf = new();
    count_up_ovf_clear cu_ovf_clear = new();
    count_down_udf_clear cd_udf_clear = new();
    reserved_region_test rsvd_test = new();
    reset_during_fly_test rstn_fly_test = new();
    timer_stop_load_TDR tmr_stop_TDR = new();
    clk_div_middle_oper clk_div_mid_oper = new();
    count_up_to_count_down cu_to_cd = new();
    count_down_to_count_up cd_to_cu = new();
    random_test_1 rand_test_1 = new();

    initial begin

        // Testbench user-defined code
        // SVA to analyize DUT signals
        // SFC to covering APB transaction

        // Perform test base on TESTNAME input command

        if ($test$plusargs("count_up_without_clk_div")) begin
        base = cu_wo_cd;
        $display("%0t: [Testbench] Implement count up without clk division test", $time);
        end 

        else if ($test$plusargs("count_up_with_clk_div_2")) begin
        base = cu_w_cd2;
        $display("%0t: [Testbench] Implement count up with clk division 2 on test", $time);
        end 

        else if ($test$plusargs("register_default_value_test")) begin
        base = reg_default;
        $display("%0t: [Testbench] Implement register default value test", $time);
        end 

        else if ($test$plusargs("register_write_rand")) begin
        base = reg_wr_rand;
        $display("%0t: [Testbench] Implement register write random value test", $time);
        end 

        else if ($test$plusargs("count_up_with_clk_div_4")) begin
        base = cu_w_cd4;
        $display("%0t: [Testbench] Implement count up with clk division 4", $time);
        end 

        else if ($test$plusargs("count_up_with_clk_div_8")) begin
        base = cu_w_cd8;
        $display("%0t: [Testbench] Implement count up with clk division 8", $time);
        end

        else if ($test$plusargs("count_up_random_with_clk_div_4")) begin
        base = cu_rand_w_cd4;
        $display("%0t: [testbench] Implement count up random value clk div 4", $time);
        end

        else if ($test$plusargs("count_down_with_clk_div_2")) begin
        base = cd_w_cd2;
        $display("%0t: [Testbench] Implement count down with clk division 2", $time);
        end

        else if ($test$plusargs("count_down_random_with_clk_div_8")) begin
        base = cd_rand_w_cd8;
        $display("%0t: [Testbench] Implement count down random val clk div 8", $time);
        end

        else if ($test$plusargs("count_up_intr_ovf")) begin
        base = cu_ovf_intr;
        $display("%0t: [Testbench] Implement count up interrupt enb with ovf", $time);
        end

        else if ($test$plusargs("count_up_ovf_clear")) begin
        base = cu_ovf_clear;
        $display("%0t: [Testbench] Implement count up intr clear overflow", $time);
        end

        else if ($test$plusargs("count_down_intr_udf")) begin
        base = cd_intr_udf;
        $display("%0t: [Testbench] Implement count down intr enb with udf", $time);
        end

        else if ($test$plusargs("count_down_udf_clear")) begin
        base = cd_udf_clear;
        $display("%0t: [Testbench] Implement count down intr clear underflow", $time);
        end

        else if ($test$plusargs("reserved_region_test")) begin
        base = rsvd_test;
        $display("%0t: [Testbench] Implement reserved region test", $time);
        end

        else if ($test$plusargs("reset_during_fly_test")) begin
        base = rstn_fly_test;
        $display("%0t: [Testbench] Implement reset during fly test", $time);
        end

        else if ($test$plusargs("timer_stop_load_TDR")) begin
        base = tmr_stop_TDR;
        $display("%0t: [Testbench] Implement timer stop load TDR test", $time);
        end

        else if ($test$plusargs("clk_div_middle_oper")) begin
        base = clk_div_mid_oper;
        $display("%0t: [Testbench] Implement clk division middle operation", $time);
        end

        else if ($test$plusargs("count_up_to_count_down")) begin
        base = cu_to_cd;
        $display("%0t: [Testbench] Implement count up to count down test", $time);
        end

        else if ($test$plusargs("count_down_to_count_up")) begin
        base = cd_to_cu;
        $display("%0t: [Testbench] Implement count down to count up test", $time);
        end

        else if ($test$plusargs("random_test_1")) begin
        base = rand_test_1;
        $display("%0t: [Testbench] Implement random test 1", $time);
        end

        // Assign DUT and run test
        base.dut_vif = d_if;
        base.run_test();

    end

    // SVA code
    // Check pwrite, psel and penable behavior
    sequence seq_a;
    a: d_if.pwrite && d_if.psel && d_if.penable ##1 d_if.psel && d_if.penable;
    endsequence

    property prop_a;
    @(posedge d_if.pclk) d_if.pwrite && d_if.psel && d_if.penable -> seq_a;
    endproperty

    assert property(prop_a) begin
    $display("[SVA] Successful relationship between pwrite, psel and penable");
    end else begin
    $display("[SVA] Unsuccessful assertion between pwrite, psel and penable");
    end

    // Check paddr, pwdata stable
    property prop_b; // Property at Accessing phase (2nd pclk) of APB transaction
    @(posedge d_if.pclk) d_if.psel && d_if.penable -> $stable(d_if.paddr) && $stable(d_if.pwdata); // Address and data is accessed in this phase so need stability
    endproperty

    assert property(prop_b) begin
    $display("[SVA] Successful stability of paddr and pwdata");
    end else begin
    $display("[SVA] Unsuccessful stability of paddr and pwdata");
    end

endmodule