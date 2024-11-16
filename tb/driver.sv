class driver; // extends uvm_driver #(uvm_sequence_item)

    // Properties
    mailbox #(packet) s2d_mb;
    packet pkt_get_sti;
    virtual dut_if dut_vif;

    // Event trigger for Write/Read API
    event xfer_done;

    // Constructor
    function new(mailbox #(packet) s2d_mb, virtual dut_if dut_vif);
        this.s2d_mb = s2d_mb;
        this.dut_vif = dut_vif;
    endfunction

    // Task run() to get packet STI and convert to DUT signals
    extern task run();

    //extern task assert_check();

endclass

task driver::run();
    pkt_get_sti = new(); // pkt get from stimulus to drive DUT signals

    forever begin // Forever will terminte the inside til simulation ends
        s2d_mb.get(pkt_get_sti); // Get packet from stimulus
        $display("%0t: [Driver] Get packet data from stimulus : 8'h%h", $time, pkt_get_sti.data);

        // Start driving DUT signals (stabilized psel, penable and write
        // alongside with paddr and pwdata)

        // Single APB bus transfer should be in 3 pclk cycle
        // Drive entire APB bus: psel/penable/pwrite(SVA) and
        // paddr and I->pwdata(for WRITE) and 0->prdata(for READ)

        //
        $display("%0t: [Driver] Start APB transfer", $time);
        //wait(dut_vif.presetn == 1);
        // All APB bus transfer synchronize with pclk

        // Write transfer (without wait state)
        if (pkt_get_sti.transfer == packet::WRITE) begin
            @(posedge dut_vif.pclk); // 1st clk tick - Setup phase
            dut_vif.paddr = pkt_get_sti.addr;
            dut_vif.psel = 1'b1;
            dut_vif.penable = 1'b0;
            dut_vif.pwrite = 1'b1;
            dut_vif.pwdata = pkt_get_sti.data;

            @(posedge dut_vif.pclk); // 2nd clk tick - Access phase
            dut_vif.penable = 1'b1;

            @(posedge dut_vif.pclk); // 3rd clk tick - Clear phase
            dut_vif.paddr = 8'b00;
            dut_vif.psel = 1'b0;
            dut_vif.penable = 1'b0;
            dut_vif.pwrite = 1'b0;
            dut_vif.pwdata = 8'b00;
        end

        // Read transfer (without wait state)
        else if (pkt_get_sti.transfer == packet::READ) begin
            @(posedge dut_vif.pclk); // 1st clk tick - Setup phase
            dut_vif.paddr = pkt_get_sti.addr;
            dut_vif.psel = 1'b1;
            dut_vif.penable = 1'b0;
            dut_vif.pwrite = 1'b0;

            @(posedge dut_vif.pclk); // 2nd clk tick - Access phase
            dut_vif.penable = 1'b1; // pready is asserted to allow prdata access
            // prdata will be achieved when penable is valid
            // pkt_get_sti.data = dut_vif.prdata; // prdata get from monitor

            @(posedge dut_vif.pclk); // 3rd clk tick - Clear phase
            dut_vif.paddr = 8'h00;
            dut_vif.psel = 1'b0;
            dut_vif.penable = 1'b0; // Also turn off pready
            dut_vif.pwrite = 1'b0;
        end

        /*
        * Refer to APB datasheet for both Write and Read transfer
        * 1. In 1st clk tick - Setup phase, psel is asserted
        *    -> Then pwrite/paddr/pwdata must be valid
        *    -> For prdata, value is valid until pready is asserted (last clk)
        * 2. In 2nd clk tick - Access phase, penable is asserted
        *    -> pready is asserted by Completer (can be varied)
        *    -> This allow pwdata/prdata is accepted in next clk tick
        * 3. In 3nd clk tick - End of transfer (last clk tick)
        *    -> psel is deasserted, so as penable
        */

        // Trigger event indicate completing 1 Write/Read transfer
        -> xfer_done;
    end
endtask