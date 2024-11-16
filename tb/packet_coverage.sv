packet pkt_trans_cov; // Packet for coverage analysis

covergroup APB_GROUP;

apb_addr: coverpoint pkt_trans_cov.addr {
  bins TCR_addr = {8'h00};
  bins TSR_addr = {8'h01};
  bins TDR_addr = {8'h02};
  bins TIE_addr = {8'h03};
}

apb_data: coverpoint pkt_trans_cov.data {
  bins TCR_data = {[8'h00:8'hff]};
  bins TSR_data = {[8'h00:8'h03]};
  bins TDR_data = {[8'h00:8'hff]};
  bins TIE_data = {[8'h00:8'h03]};
}

apb_transfer: coverpoint pkt_trans_cov.transfer {
  bins apb_read = {packet::READ};
  bins apb_write = {packet::WRITE};
}

apb_transaction_type: cross apb_addr, apb_transfer; // relationship of r/w and addr

// TCR feature
apb_TCR_timer_en: coverpoint pkt_trans_cov.data[0] {
  bins timer_en[] = {1'b0, 1'b1}; // timer_en[0] = timer not count, timer_en[1] = start cnt
}

apb_TCR_count_down: coverpoint pkt_trans_cov.data[1:0] {
  bins count_down = {2'b11}; // count_down[0] = count up, count_down[1] = count down
  bins count_up = {2'b01};
}

apb_TCR_load: coverpoint pkt_trans_cov.data[2] {
  bins load[] = {1'b0, 1'b1}; // load[0] = normal oper, count_down[1] = stop timer_en and load
}

apb_TCR_clk_div: coverpoint pkt_trans_cov.data[4:3] {
  bins clk_div_none = {2'b00};
  bins clk_div_2 = {2'b01};
  bins clk_div_4 = {2'b10};
  bins clk_div_8 = {2'b11};
}

apb_TCR_reserved: coverpoint pkt_trans_cov.data[7:5] {
  bins rsvd = {[3'b001:3'b111]};
}

// TSR feature
apb_TSR_overunder: coverpoint pkt_trans_cov.data {
  bins overflow_clear = {2'b01};
  bins underflow_clear = {2'b10};
}

// TDR feature
apb_TDR_load_data: coverpoint pkt_trans_cov.data {
  bins data = {[8'h00:8'hff]};
}

// TIE feature
apb_TIE_interrupt_overunder: coverpoint pkt_trans_cov.data {
  bins underflow_en = {2'b10};
  bins overflow_en = {2'b01};
}

// Cross transaction of addr and data
// (user-defined crosspoint only)
apb_count_up: cross apb_addr, apb_TCR_clk_div, apb_TCR_count_down {
  ignore bins count_up_clk_div_0 = !binsof(apb_addr) intersect (8'h00) || !binsof(apb_TCR_clk_div) intersect (2'b00) || !binsof(apb_TCR_count_down) intersect (1'b0);
  ignore bins count_up_clk_div_2 = !binsof(apb_addr) intersect (8'h00) || !binsof(apb_TCR_clk_div) intersect (2'b01) || !binsof(apb_TCR_count_down) intersect (1'b0);
  ignore bins count_up_clk_div_4 = !binsof(apb_addr) intersect (8'h00) || !binsof(apb_TCR_clk_div) intersect (2'b10) || !binsof(apb_TCR_count_down) intersect (1'b0);
  ignore bins count_up_clk_div_8 = !binsof(apb_addr) intersect (8'h00) || !binsof(apb_TCR_clk_div) intersect (2'b11) || !binsof(apb_TCR_count_down) intersect (1'b0);
}

apb_count_down: cross apb_addr, apb_TCR_clk_div, apb_TCR_count_down {
  ignore bins count_down_clk_div_0 = !binsof(apb_addr) intersect (8'h00) || !binsof(apb_TCR_clk_div) intersect (2'b00) || binsof(apb_TCR_count_down) intersect (1'b1);
  ignore bins count_down_clk_div_2 = binsof(apb_addr) intersect (8'h00) || binsof(apb_TCR_clk_div) intersect (2'b01) || binsof(apb_TCR_count_down) intersect (1'b1);
  ignore bins count_down_clk_div_4 = binsof(apb_addr) intersect (8'h00) || binsof(apb_TCR_clk_div) intersect (2'b10) || binsof(apb_TCR_count_down) intersect (1'b1);
  ignore bins count_down_clk_div_8 = binsof(apb_addr) intersect (8'h00) || binsof(apb_TCR_clk_div) intersect (2'b11) || binsof(apb_TCR_count_down) intersect (1'b1);
}

apb_TDR_load: cross apb_addr, apb_TDR_load_data {
  ignore bins TDR_load_enable = !binsof(apb_addr) intersect (8'h01) || !binsof(apb_TDR_load_data) intersect ([8'h00:8'hff]);
}

apb_TIE_enb: cross apb_addr, apb_TIE_interrupt_overunder {
  ignore bins overflow_en = !binsof(apb_addr) intersect (8'h03) || !binsof(apb_TIE_interrupt_overunder) intersect (2'b01);
  ignore bins underflow_en = !binsof(apb_addr) intersect (8'h03) || !binsof(apb_TIE_interrupt_overunder) intersect (2'b10);
}

apb_TSR_clear: cross apb_addr, apb_TSR_overunder {
  ignore bins overflow_clear = !binsof(apb_addr) intersect (8'h01) || !binsof(apb_TSR_overunder) intersect (2'b01);
  ignore bins underflow_clear = !binsof(apb_addr) intersect (8'h01) || !binsof(apb_TSR_overunder) intersect (2'b10);
}

endgroup