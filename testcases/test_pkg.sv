package test_pkg;

  import timer_pkg::*; // Including all environment components

  `include "base_test.sv"
  `include "register_default_value_test.sv"
  `include "register_write_random.sv"   
  `include "count_up_without_clk_div.sv"
  `include "count_up_with_clk_div_2.sv"
  `include "count_up_with_clk_div_4.sv"
  `include "count_up_with_clk_div_8.sv"
  `include "count_up_random_with_clk_div_4.sv"
  `include "count_down_with_clk_div_2.sv"
  `include "count_down_random_with_clk_div_8.sv"
  `include "count_up_intr_ovf.sv"
  `include "count_down_intr_udf.sv"
  `include "count_up_ovf_clear.sv"
  `include "count_down_udf_clear.sv"
  `include "reserved_region_test.sv"
  `include "reset_during_fly_test.sv"
  `include "timer_stop_load_TDR.sv"
  `include "clk_div_middle_oper.sv"
  `include "count_up_to_count_down.sv"
  `include "count_down_to_count_up.sv"
  `include "random_test_1.sv"
  //`include "random_test_2.sv"
  //`include "random test_3.sv"
  //`include "random test_4.sv"

endpackage