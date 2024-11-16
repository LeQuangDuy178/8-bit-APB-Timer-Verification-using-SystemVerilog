class scoreboard; // extends uvm_scoreboard

// Properties
mailbox #(packet) m2s_mb; // Monitor to scoreboard packet
int error_cnt;

// Coverage properties
`include "packet_coverage.sv"

//packet pkt_trans_cov; // For coverage analysis (will be called in packet_coverage.sv)
bit sfc_enb = 1; // Trigger coverage flag

// Constructor
function new(mailbox #(packet) m2s_mb);
  this.m2s_mb = m2s_mb;

  pkt_trans_cov = new();
  APB_GROUP = new();
endfunction

// Run scoreboard to display APB transaction data and perform SFC analysis
extern task run();

extern function void sample_packet_sfc(packet pkt_get_mon);
extern function void report(int error_cnt);

endclass

task scoreboard::run();
  packet pkt_get_mon = new(); // Packet to receive from monitor

  while(1) begin
    m2s_mb.get(pkt_get_mon);

    $display("%0t: [Scoreboard] Get packet from monitor: %s: addr = 8'h%h, data = 8'h%h", $time, pkt_get_mon.transfer.name(), pkt_get_mon.addr, pkt_get_mon.data);

    // Report error for every wrong package
    // error_cnt++;

    // report(int error_cnt);

    // Enable SFC
    if (sfc_enb) sample_packet_sfc(pkt_get_mon);
  end
endtask

function void scoreboard::sample_packet_sfc(packet pkt_get_mon);
  $cast(pkt_trans_cov, pkt_get_mon); // Force to packet from monitor to coverage
  APB_GROUP.sample();
endfunction

function void scoreboard::report(int error_cnt);
  int total_error = this.error_cnt + error_cnt;

  if (total_error == 0) begin
    $display("%0t: [Scoreboard] Status: TEST PASSED", $time); // Regression search for keyword
  end else begin
    $display("%0t: [Scoreboard] Status: TEST FAILED", $time);
    $display("%0t: [Scoreboard] Test error: %0d", $time, total_error);
  end
endfunction

