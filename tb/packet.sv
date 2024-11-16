class packet; // Extends uvm_sequence_item

    // Properties
    typedef enum bit {READ = 0, WRITE = 1} transfer_enum;

    bit [7:0] addr; // Should be controlled between directed and rand test
    bit [7:0] data; // Should be controlled between directed and rand test
    transfer_enum transfer; // transfer = 0 = READ, transfer = 1 = WRITE

    // psel/penable/pwrite should be configure the same for every APB bus tran

    function new();
    endfunction

    // Random data list
    rand bit [7:0] TCR_data;
    rand bit [7:0] TSR_data;
    rand bit [7:0] TDR_data;
    rand bit [7:0] TIE_data;

    rand bit [7:0] TCR_data_count_enb;

    // Constraint for randomized data
    constraint TDR_data_range {
    TDR_data inside {8'h44, 8'hdd};
    TDR_data dist {8'h44 := 50, 8'hdd := 50};
    }

    constraint TCR_data_range {
    TCR_data[7:5] == 3'b000;

    TCR_data[4:3] inside {2'b00, 2'b01, 2'b10, 2'b11};
    TCR_data[2] inside {1'b0, 1'b1};

    TCR_data[1] inside {1'b0, 1'b1};
    TCR_data[0] = 1'b0; // Turn off timer_en for TCR configuration

    TIE_data == 8'h01 -> TCR_data_count_enb == 8'h01;
    TIE_data == 8'h02 -> TCR_data_count_enb == 8'h03;
    }

    constraint TSR_data_range {
    TSR_data inside {8'h01, 8'h02};

    TIE_data == 8'h01 -> TSR_data == 8'h01; // Overflow enb -> ovf clear
    TIE_data == 8'h02 -> TSR_data == 8'h02; // Udf enb -> udf clear
    }

    constraint TIE_data_range {
    TIE_data inside {8'h01, 8'h02};

    TIE_data dist {8'h01 := 50, 8'h02 := 50};
    }

endclass