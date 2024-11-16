class base_test;
    // extends uvm_test

    // Properties
    //packet pkt;
    environment env;
    virtual dut if dut_vif;

    // Address by name
    bit [7:0] TCR_addr = 8'h00;
    bit [7:0] TSR_addr = 8'h01;
    bit [7:0] TDR_addr = 8'h02;
    bit [7:0] TIE_addr = 8'h03;

    // Register API instructions
    bit [7:0] TCR_stop_counter = 8'h00;
    bit [7:0] TCR_clk_div_2 = 8'h08;
    bit [7:0] TCR_clk_div_4 = 8'h10;
    bit [7:0] TCR_clk_div_8 = 8'h18;
    bit [7:0] TCR_default_count_up = 8'h01;
    bit [7:0] TCR_count_down_enb = 8'h02; // Count down assign before timer_en
    bit [7:0] TCR_default_count_down = 8'h03;
    bit [7:0] TCR_load_enb = 8'h04;
    bit [7:0] TIE_underflow_enb = 8'h02;
    bit [7:0] TIE_overflow_enb = 8'h01;
    bit [7:0] TSR_underflow_clear = 8'h02;
    bit [7:0] TSR_overflow_clear = 8'h01;

    // Count error for every tests
    int error_cnt = 0;

    // constructor
    function new();
    endfunction

    // Build phase
    function void build();
    env = new(dut_vif); // Assign vif of base to env (including drv and mon)
    env.build();
    endfunction

    // Run scenario
    virtual task run_scenario(); // Refer to section 6 in Vplan to create custom test
    endtask

    // Task and function
    extern task read(bit [7:0] addr, ref bit [7:0] data);
    extern task write(bit [7:0] addr, bit [7:0] data);

    // Run test after assigning test case
    task run_test(); // Run phase
        build(); // Build and connect environment first
        fork
            env.run(); // Allow modules to run and test case applied synchronously but not wait till done
        join_any // Do not wait till 2 statements both finish but allow below to continue
        run_scenario();
        env.sco.report(error_cnt);
        #3us; // Adjust by different test case simulation time length required
        $display("%0t: [Base test] End simulation", $time);
        $finish;
    endtask

endclass

task base_test::write(bit [7:0] addr, bit [7:0] data);
  packet pkt = new();
  pkt.addr = addr; // This packet will be send to stimulus
  pkt.data = data;
  pkt.transfer = packet::WRITE;
  env.sti.send_pkt(pkt);
  @(env.drv.xfer_done); // trigger by driver indicate transfer complete
endtask

task base_test::read(bit [7:0] addr, ref bit [7:0] data);
  packet pkt = new(); // This packet will be send to stimulus
  pkt.addr = addr;
  pkt.transfer = packet::READ;
  env.sti.send_pkt(pkt);
  @(env.drv.xfer_done); // wait(event.triggered) will only wait 1 event
  data = pkt.data; // Read data and store in ref data so that data = read data real time
endtask

/* Address, Transfer and Data range for each registers
* Exceeding this range value will result in Reserved region
* Reserved: Write not affect to the actual DUT, read as zero data
* Address -> [0x00:0x03]
* Transfer -> [READ: WRITE]
* In TCR (0x00): Data -> [0x00:0x1F]
* In TSR (0x01): Data -> [0x00:0x03]
* In TDR (0x02): Data -> [0x00:0xFF]
* In TIE (0x03): Data -> [0x00:0x03]
*/