
//==============================================================
// DAY 12 SELF-CHECKING TESTBENCH
// Ring Counter + Johnson Counter
//
// Verification:
// 1. NOT gate
// 2. DFF
// 3. 4-bit Shift Register
// 4. Ring Counter
// 5. Johnson Counter
// 6. Structural vs RTL
// 7. Synchronous Reset
// 8. Asynchronous Reset
// 9. Complete Counting Sequences
//
// Final result is automatically PASS or FAIL.
//
// Johnson sequence used by this DUT:
//
// 0000
// 0001
// 0011
// 0111
// 1111
// 1110
// 1100
// 1000
// 0000
//==============================================================

`timescale 1ns/1ps

module day12_tb;


//==============================================================
// GLOBAL ERROR COUNTER
//==============================================================

integer errors;

initial
begin
    errors = 0;
end


//==============================================================
// CLOCK
//==============================================================

reg clk;

initial
begin
    clk = 1'b0;

    forever
        #5 clk = ~clk;
end


//==============================================================
// RESET
//==============================================================

reg reset;


//==============================================================
// NOT GATE
//==============================================================

reg  not_A;
wire not_Y;

not_gate DUT_NOT (
    .A(not_A),
    .Y(not_Y)
);


//==============================================================
// D FLIP-FLOP
//==============================================================

reg  dff_D;
wire dff_Q;

dff_sync_reset0 DUT_DFF (
    .clk   (clk),
    .reset (reset),
    .D     (dff_D),
    .Q     (dff_Q)
);


//==============================================================
// SHIFT REGISTER
//==============================================================

reg        serial_in;
wire [3:0] shift_Q;

shift_register_4bit_sync DUT_SHIFT (
    .clk       (clk),
    .reset     (reset),
    .serial_in (serial_in),
    .Q         (shift_Q)
);


//==============================================================
// RING COUNTERS
//==============================================================

wire [3:0] ring_sync;
wire [3:0] ring_async;
wire [3:0] ring_rtl;


//==============================================================
// JOHNSON COUNTERS
//==============================================================

wire [3:0] johnson_sync;
wire [3:0] johnson_async;
wire [3:0] johnson_rtl;


//==============================================================
// TOP MODULE
//==============================================================

ring_johnson_counter_top DUT_TOP (
    .clk          (clk),
    .reset        (reset),

    .ring_sync    (ring_sync),
    .ring_async   (ring_async),

    .johnson_sync (johnson_sync),
    .johnson_async(johnson_async),

    .ring_rtl     (ring_rtl),
    .johnson_rtl  (johnson_rtl)
);


//==============================================================
// 1-BIT CHECK TASK
//==============================================================

task check_bit;

input       actual;
input       expected;
input [255:0] test_name;

begin

    if (actual === expected)
    begin
        $display(
            "PASS : %s | Actual=%b Expected=%b",
            test_name,
            actual,
            expected
        );
    end
    else
    begin
        $display(
            "FAIL : %s | Actual=%b Expected=%b",
            test_name,
            actual,
            expected
        );

        errors = errors + 1;
    end

end

endtask


//==============================================================
// 4-BIT CHECK TASK
//==============================================================

task check_4bit;

input [3:0]   actual;
input [3:0]   expected;
input [255:0] test_name;

begin

    if (actual === expected)
    begin
        $display(
            "PASS : %s | Actual=%b Expected=%b",
            test_name,
            actual,
            expected
        );
    end
    else
    begin
        $display(
            "FAIL : %s | Actual=%b Expected=%b",
            test_name,
            actual,
            expected
        );

        errors = errors + 1;
    end

end

endtask


//==============================================================
// STRUCTURAL VS RTL CHECK TASK
//==============================================================

task check_structural_rtl;

input [3:0] structural;
input [3:0] rtl;
input [255:0] test_name;

begin

    if (structural === rtl)
    begin
        $display(
            "PASS : %s | Structural=%b RTL=%b",
            test_name,
            structural,
            rtl
        );
    end
    else
    begin
        $display(
            "FAIL : %s | Structural=%b RTL=%b",
            test_name,
            structural,
            rtl
        );

        errors = errors + 1;
    end

end

endtask


//==============================================================
// MAIN SELF-CHECKING TEST
//==============================================================

initial
begin

    //----------------------------------------------------------
    // INITIAL VALUES
    //----------------------------------------------------------

    reset     = 1'b0;
    not_A     = 1'b0;
    dff_D     = 1'b0;
    serial_in = 1'b0;


    //==========================================================
    // TEST 1 : NOT GATE
    //==========================================================

    $display("");
    $display("================================================");
    $display("TEST 1 : NOT GATE");
    $display("================================================");

    not_A = 1'b0;
    #1;

    check_bit(
        not_Y,
        1'b1,
        "NOT 0 = 1"
    );

    not_A = 1'b1;
    #1;

    check_bit(
        not_Y,
        1'b0,
        "NOT 1 = 0"
    );


    //==========================================================
    // TEST 2 : D FLIP-FLOP
    //==========================================================

    $display("");
    $display("================================================");
    $display("TEST 2 : D FLIP-FLOP");
    $display("================================================");

    //----------------------------------------------------------
    // Synchronous reset
    //----------------------------------------------------------

    reset = 1'b1;
    dff_D = 1'b0;

    @(posedge clk);
    #1;

    check_bit(
        dff_Q,
        1'b0,
        "DFF RESET"
    );

    //----------------------------------------------------------
    // Capture 1
    //----------------------------------------------------------

    reset = 1'b0;
    dff_D = 1'b1;

    @(posedge clk);
    #1;

    check_bit(
        dff_Q,
        1'b1,
        "DFF CAPTURE 1"
    );

    //----------------------------------------------------------
    // Capture 0
    //----------------------------------------------------------

    dff_D = 1'b0;

    @(posedge clk);
    #1;

    check_bit(
        dff_Q,
        1'b0,
        "DFF CAPTURE 0"
    );


    //==========================================================
    // TEST 3 : 4-BIT SHIFT REGISTER
    //==========================================================

    $display("");
    $display("================================================");
    $display("TEST 3 : 4-BIT SHIFT REGISTER");
    $display("================================================");

    //----------------------------------------------------------
    // Reset
    //----------------------------------------------------------

    reset     = 1'b1;
    serial_in = 1'b0;

    @(posedge clk);
    #1;

    check_4bit(
        shift_Q,
        4'b0000,
        "SHIFT RESET"
    );

    //----------------------------------------------------------
    // Shift 1
    //----------------------------------------------------------

    reset     = 1'b0;
    serial_in = 1'b1;

    @(posedge clk);
    #1;

    check_4bit(
        shift_Q,
        4'b1000,
        "SHIFT STATE 1"
    );

    //----------------------------------------------------------
    // Shift 2
    //----------------------------------------------------------

    serial_in = 1'b0;

    @(posedge clk);
    #1;

    check_4bit(
        shift_Q,
        4'b0100,
        "SHIFT STATE 2"
    );

    //----------------------------------------------------------
    // Shift 3
    //----------------------------------------------------------

    serial_in = 1'b1;

    @(posedge clk);
    #1;

    check_4bit(
        shift_Q,
        4'b1010,
        "SHIFT STATE 3"
    );

    //----------------------------------------------------------
    // Shift 4
    //----------------------------------------------------------

    serial_in = 1'b1;

    @(posedge clk);
    #1;

    check_4bit(
        shift_Q,
        4'b1101,
        "SHIFT STATE 4"
    );


    //==========================================================
    // TEST 4 : RING COUNTER
    //==========================================================

    $display("");
    $display("================================================");
    $display("TEST 4 : RING COUNTER");
    $display("================================================");

    //----------------------------------------------------------
    // Reset
    //----------------------------------------------------------

    reset = 1'b1;

    @(posedge clk);
    #1;

    check_4bit(
        ring_sync,
        4'b0001,
        "RING SYNC RESET"
    );

    check_4bit(
        ring_rtl,
        4'b0001,
        "RING RTL RESET"
    );

    //----------------------------------------------------------
    // Structural vs RTL after reset
    //----------------------------------------------------------

    check_structural_rtl(
        ring_sync,
        ring_rtl,
        "RING RESET STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 1
    //----------------------------------------------------------

    reset = 1'b0;

    @(posedge clk);
    #1;

    check_4bit(
        ring_sync,
        4'b0010,
        "RING STATE 1"
    );

    check_4bit(
        ring_rtl,
        4'b0010,
        "RING RTL STATE 1"
    );

    check_structural_rtl(
        ring_sync,
        ring_rtl,
        "RING STATE 1 STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 2
    //----------------------------------------------------------

    @(posedge clk);
    #1;

    check_4bit(
        ring_sync,
        4'b0100,
        "RING STATE 2"
    );

    check_structural_rtl(
        ring_sync,
        ring_rtl,
        "RING STATE 2 STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 3
    //----------------------------------------------------------

    @(posedge clk);
    #1;

    check_4bit(
        ring_sync,
        4'b1000,
        "RING STATE 3"
    );

    check_structural_rtl(
        ring_sync,
        ring_rtl,
        "RING STATE 3 STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 4 - Repeat
    //----------------------------------------------------------

    @(posedge clk);
    #1;

    check_4bit(
        ring_sync,
        4'b0001,
        "RING STATE 4 REPEAT"
    );

    check_structural_rtl(
        ring_sync,
        ring_rtl,
        "RING STATE 4 STRUCTURAL VS RTL"
    );


    //==========================================================
    // TEST 5 : JOHNSON COUNTER
    //==========================================================

    $display("");
    $display("================================================");
    $display("TEST 5 : JOHNSON COUNTER");
    $display("================================================");

    //----------------------------------------------------------
    // Reset
    //----------------------------------------------------------

    reset = 1'b1;

    @(posedge clk);
    #1;

    check_4bit(
        johnson_sync,
        4'b0000,
        "JOHNSON SYNC RESET"
    );

    check_4bit(
        johnson_rtl,
        4'b0000,
        "JOHNSON RTL RESET"
    );

    check_structural_rtl(
        johnson_sync,
        johnson_rtl,
        "JOHNSON RESET STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 1
    //----------------------------------------------------------

    reset = 1'b0;

    @(posedge clk);
    #1;

    check_4bit(
        johnson_sync,
        4'b0001,
        "JOHNSON STATE 1"
    );

    check_4bit(
        johnson_rtl,
        4'b0001,
        "JOHNSON RTL STATE 1"
    );

    check_structural_rtl(
        johnson_sync,
        johnson_rtl,
        "JOHNSON STATE 1 STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 2
    //----------------------------------------------------------

    @(posedge clk);
    #1;

    check_4bit(
        johnson_sync,
        4'b0011,
        "JOHNSON STATE 2"
    );

    check_4bit(
        johnson_rtl,
        4'b0011,
        "JOHNSON RTL STATE 2"
    );

    check_structural_rtl(
        johnson_sync,
        johnson_rtl,
        "JOHNSON STATE 2 STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 3
    //----------------------------------------------------------

    @(posedge clk);
    #1;

    check_4bit(
        johnson_sync,
        4'b0111,
        "JOHNSON STATE 3"
    );

    check_4bit(
        johnson_rtl,
        4'b0111,
        "JOHNSON RTL STATE 3"
    );

    check_structural_rtl(
        johnson_sync,
        johnson_rtl,
        "JOHNSON STATE 3 STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 4
    //----------------------------------------------------------

    @(posedge clk);
    #1;

    check_4bit(
        johnson_sync,
        4'b1111,
        "JOHNSON STATE 4"
    );

    check_4bit(
        johnson_rtl,
        4'b1111,
        "JOHNSON RTL STATE 4"
    );

    check_structural_rtl(
        johnson_sync,
        johnson_rtl,
        "JOHNSON STATE 4 STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 5
    //----------------------------------------------------------

    @(posedge clk);
    #1;

    check_4bit(
        johnson_sync,
        4'b1110,
        "JOHNSON STATE 5"
    );

    check_4bit(
        johnson_rtl,
        4'b1110,
        "JOHNSON RTL STATE 5"
    );

    check_structural_rtl(
        johnson_sync,
        johnson_rtl,
        "JOHNSON STATE 5 STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 6
    //----------------------------------------------------------

    @(posedge clk);
    #1;

    check_4bit(
        johnson_sync,
        4'b1100,
        "JOHNSON STATE 6"
    );

    check_4bit(
        johnson_rtl,
        4'b1100,
        "JOHNSON RTL STATE 6"
    );

    check_structural_rtl(
        johnson_sync,
        johnson_rtl,
        "JOHNSON STATE 6 STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 7
    //----------------------------------------------------------

    @(posedge clk);
    #1;

    check_4bit(
        johnson_sync,
        4'b1000,
        "JOHNSON STATE 7"
    );

    check_4bit(
        johnson_rtl,
        4'b1000,
        "JOHNSON RTL STATE 7"
    );

    check_structural_rtl(
        johnson_sync,
        johnson_rtl,
        "JOHNSON STATE 7 STRUCTURAL VS RTL"
    );

    //----------------------------------------------------------
    // State 8 - Repeat
    //----------------------------------------------------------

    @(posedge clk);
    #1;

    check_4bit(
        johnson_sync,
        4'b0000,
        "JOHNSON STATE 8 REPEAT"
    );

    check_4bit(
        johnson_rtl,
        4'b0000,
        "JOHNSON RTL STATE 8 REPEAT"
    );

    check_structural_rtl(
        johnson_sync,
        johnson_rtl,
        "JOHNSON STATE 8 STRUCTURAL VS RTL"
    );


    //==========================================================
    // TEST 6 : ASYNCHRONOUS RESET
    //==========================================================

    $display("");
    $display("================================================");
    $display("TEST 6 : ASYNCHRONOUS RESET");
    $display("================================================");

    //----------------------------------------------------------
    // Keep reset asserted away from clock edge.
    // Async outputs must respond immediately.
    //----------------------------------------------------------

    reset = 1'b1;

    #1;

    check_4bit(
        ring_async,
        4'b0001,
        "RING ASYNC RESET"
    );

    check_4bit(
        johnson_async,
        4'b0000,
        "JOHNSON ASYNC RESET"
    );

    //----------------------------------------------------------
    // Verify async reset independently of clock.
    //----------------------------------------------------------

    #2;

    check_4bit(
        ring_async,
        4'b0001,
        "RING ASYNC RESET HOLD"
    );

    check_4bit(
        johnson_async,
        4'b0000,
        "JOHNSON ASYNC RESET HOLD"
    );


    //==========================================================
    // TEST 7 : SYNCHRONOUS RESET
    //==========================================================

    $display("");
    $display("================================================");
    $display("TEST 7 : SYNCHRONOUS RESET");
    $display("================================================");

    //----------------------------------------------------------
    // Reset must be sampled at active clock edge.
    //----------------------------------------------------------

    reset = 1'b1;

    @(posedge clk);
    #1;

    check_4bit(
        ring_sync,
        4'b0001,
        "RING SYNC RESET"
    );

    check_4bit(
        ring_rtl,
        4'b0001,
        "RING RTL SYNC RESET"
    );

    check_4bit(
        johnson_sync,
        4'b0000,
        "JOHNSON SYNC RESET"
    );

    check_4bit(
        johnson_rtl,
        4'b0000,
        "JOHNSON RTL SYNC RESET"
    );

    //----------------------------------------------------------
    // Structural vs RTL after synchronous reset.
    //----------------------------------------------------------

    check_structural_rtl(
        ring_sync,
        ring_rtl,
        "RING SYNC RESET STRUCTURAL VS RTL"
    );

    check_structural_rtl(
        johnson_sync,
        johnson_rtl,
        "JOHNSON SYNC RESET STRUCTURAL VS RTL"
    );


    //==========================================================
    // TEST 8 : ASYNC VS SYNC RESET VALUES
    //==========================================================

    $display("");
    $display("================================================");
    $display("TEST 8 : RESET VALUE CONSISTENCY");
    $display("================================================");

    check_4bit(
        ring_sync,
        ring_async,
        "RING SYNC VS ASYNC RESET"
    );

    check_4bit(
        johnson_sync,
        johnson_async,
        "JOHNSON SYNC VS ASYNC RESET"
    );


    //==========================================================
    // FINAL RESULT
    //==========================================================

    #2;

    $display("");
    $display("================================================");
    $display("DAY 12 SELF-CHECKING TEST COMPLETE");
    $display("================================================");

    if (errors == 0)
    begin

        $display("");
        $display("***********************************************");
        $display(" DAY 12 PASS - ALL TESTS PASSED");
        $display("***********************************************");
        $display("");
        $display("Total Errors = %0d", errors);
        $display("");

    end
    else
    begin

        $display("");
        $display("***********************************************");
        $display(" DAY 12 FAIL - ERRORS DETECTED");
        $display("***********************************************");
        $display("");
        $display("Total Errors = %0d", errors);
        $display("");

    end

    $finish;

end


//==============================================================
// CONTINUOUS MONITOR
//==============================================================

initial
begin

    $monitor(
        "TIME=%0t | RESET=%b | RING_SYNC=%b | RING_RTL=%b | RING_ASYNC=%b | JOHNSON_SYNC=%b | JOHNSON_RTL=%b | JOHNSON_ASYNC=%b",
        $time,
        reset,
        ring_sync,
        ring_rtl,
        ring_async,
        johnson_sync,
        johnson_rtl,
        johnson_async
    );

end


//==============================================================
// VCD WAVEFORM
//==============================================================

initial
begin

    $dumpfile("day12.vcd");
    $dumpvars(0, day12_tb);

end


endmodule

