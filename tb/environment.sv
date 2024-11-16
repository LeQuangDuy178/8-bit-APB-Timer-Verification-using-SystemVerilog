class environment; // extends uvm_env (build_phase, connect_phase and uvm_agent)

    // Properties
    stimulus sti;
    driver drv;
    monitor mon;
    scoreboard sco;

    mailbox #(packet) s2d_mb;
    mailbox #(packet) m2s_mb;

    virtual dut_if dut_vif;

    // Constuctor
    function new(virtual dut_if dut_vif); // Pass interface of DUT to env
    this.dut_vif = dut_vif;
    endfunction

    // Build phase (non timestamp)
    function void build();
    $display("%0t: [Environment] Build simulation", $time);

    s2d_mb = new();
    m2s_mb = new();

    sti = new(s2d_mb);
    drv = new(s2d_mb, dut_vif);
    mon = new(m2s_mb, dut_vif);
    sco = new(m2s_mb);
    endfunction

    // Run phase (timestamp)
    task run();
    fork
        sti.run();
        drv.run();
        mon.run();
        sco.run();
    join
    endtask

    // Connect phase
    
endclass
