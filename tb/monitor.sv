class monitor; // extends uvm_monitor (uvm_build_phase and uvm_connect_phase (uvm_phase phase)) (later connect sequence, driver and monitor to uvm_agent)

// Properties
mailbox #(packet) m2s_mb; // Monitor to scoreboard for SFC
virtual dut_if dut_vif;
packet pkt_send_sco;

// Constructor
function new(mailbox #(packet) m2s_mb, virtual dut_if dut_vif);
  this.dut_vif = dut_vif;
  this.m2s_mb = m2s_mb;
endfunction

// Task run to capture DUT signals and convert to packet sending to SCO
extern task run();
extern task detect_apb_addr();
extern task detect_apb_pwdata();
extern task detect_apb_prdata();
//extern task detect_apb_transfer();

endclass

task monitor::run();
  pkt_send_sco = new(); // pkt after converted from DUT signals and send to scoreboard

  while(1) begin // While (1) will have its own termination condition
    // Check to wait psel, penable and pwrite in correct pattern to capture
    do begin
      @(posedge dut_vif.psel); // Do at least 1 time
    end while(! (dut_vif.psel == 1'b1));

    // Check if psel not true -> loop will execute again to wait psel posedge
    $display("%0t: [Monitor] Start capturing APB transaction", $time);

    // Start capturing APB signals
    // Capturing APB transfer mode R/W, APB address, APB data for R/W through
    // pkt_send_sco.addr = dut_vif.paddr; pkt_send_sco.data = dut_vif.prdata;
    // pkt_send_sco.transfer = packet::WRITE/READ;

    // Capture signals (parallely using fork-join)
    fork
      detect_apb_addr();
      if (dut_vif.pwrite == 1'b1) begin
        detect_apb_pwdata();
        pkt_send_sco.transfer = packet::WRITE;
      end else if (dut_vif.pwrite == 1'b0) begin
        detect_apb_prdata();
        pkt_send_sco.transfer = packet::READ;
      end
    join

    // Send all data packet to scoreboard (addr, data and transfer)
    m2s_mb.put(pkt_send_sco);

  end
endtask

task monitor::detect_apb_addr();
  pkt_send_sco.addr = dut_vif.paddr; // TCR, TSR, TDR, TIE register address
endtask

task monitor::detect_apb_pwdata();
  @(posedge dut_vif.penable);
  pkt_send_sco.data = dut_vif.pwdata; // Capture APB write data
endtask

task monitor::detect_apb_prdata();
  @(posedge dut_vif.penable);
  pkt_send_sco.data = dut_vif.prdata;
endtask