class stimulus; // Extends uvm_sequencer

// Properties
packet pkt_send_drv; // pkt to send to driver
mailbox #(packet) s2d_mb;
packet pkt_queue[$];

// Constructor
function new(mailbox #(packet) s2d_mb);
  this.s2d_mb = s2d_mb;
endfunction

// Get packet created from test classes and send to queue
function void send_pkt(packet pkt_get);
  $display("%0t: [Stimulus] Get packet for test case", $time);
  pkt_queue.push_back(pkt_get);
endfunction

// Task run sending packet to driver
task run();
  pkt_send_drv = new();

  forever begin
    wait(pkt_queue.size() > 0); // Wait until queue has data
    pkt_send_drv = pkt_queue.pop_front(); // Sequence item for test case x

    $display("%0t: [Stimulus] Check data pkt sending to mailbox driver : 8'h%h", $time, pkt_send_drv.data);
    s2d_mb.put(pkt_send_drv);
    $display("%0t: [Stimulus] Send packet to driver", $time);
  end
endtask

endclass