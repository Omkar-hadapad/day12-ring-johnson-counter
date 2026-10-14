//==============================================================
// DAY 12 - RING COUNTER + JOHNSON COUNTER
// Digital VLSI / Verilog RTL / Hierarchical Design
//
// Hierarchy:
// LEVEL 1 : NOT Gate
// LEVEL 2 : D Flip-Flop
// LEVEL 3 : 4-bit Shift Register
// LEVEL 4 : Ring Counter
// LEVEL 5 : Johnson Counter
// LEVEL 6 : RTL Ring Counter
// LEVEL 7 : RTL Johnson Counter
// LEVEL 8 : TOP MODULE
//==============================================================


//==============================================================
// LEVEL 1 : NOT GATE
//==============================================================

module not_gate (
    input  A,
    output Y
);

assign Y = ~A;

endmodule


//==============================================================
// LEVEL 2A : D FLIP-FLOP WITH SYNCHRONOUS RESET TO 0
//==============================================================

module dff_sync_reset0 (
    input clk,
    input reset,
    input D,
    output reg Q
);

always @(posedge clk)
begin
    if (reset)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule


//==============================================================
// LEVEL 2B : D FLIP-FLOP WITH SYNCHRONOUS RESET TO 1
// Used for Ring Counter because Ring Counter needs 0001.
//==============================================================

module dff_sync_reset1 (
    input clk,
    input reset,
    input D,
    output reg Q
);

always @(posedge clk)
begin
    if (reset)
        Q <= 1'b1;
    else
        Q <= D;
end

endmodule


//==============================================================
// LEVEL 2C : D FLIP-FLOP WITH ASYNCHRONOUS RESET TO 0
//==============================================================

module dff_async_reset0 (
    input clk,
    input reset,
    input D,
    output reg Q
);

always @(posedge clk or posedge reset)
begin
    if (reset)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule


//==============================================================
// LEVEL 2D : D FLIP-FLOP WITH ASYNCHRONOUS RESET TO 1
//==============================================================

module dff_async_reset1 (
    input clk,
    input reset,
    input D,
    output reg Q
);

always @(posedge clk or posedge reset)
begin
    if (reset)
        Q <= 1'b1;
    else
        Q <= D;
end

endmodule


//==============================================================
// LEVEL 3 : 4-BIT SHIFT REGISTER
//
// Shift direction:
//
// D3 <- serial_in
// D2 <- Q3
// D1 <- Q2
// D0 <- Q1
//==============================================================

module shift_register_4bit_sync (
    input clk,
    input reset,
    input serial_in,
    output [3:0] Q
);

wire q3;
wire q2;
wire q1;
wire q0;

dff_sync_reset0 FF3 (
    .clk(clk),
    .reset(reset),
    .D(serial_in),
    .Q(q3)
);

dff_sync_reset0 FF2 (
    .clk(clk),
    .reset(reset),
    .D(q3),
    .Q(q2)
);

dff_sync_reset0 FF1 (
    .clk(clk),
    .reset(reset),
    .D(q2),
    .Q(q1)
);

dff_sync_reset0 FF0 (
    .clk(clk),
    .reset(reset),
    .D(q1),
    .Q(q0)
);

assign Q = {q3, q2, q1, q0};

endmodule


//==============================================================
// LEVEL 4A : 4-BIT RING COUNTER
// SYNCHRONOUS RESET
//
// Reset state = 0001
//
// Feedback:
// Q0 <- Q3
//
// Next state:
// Q3 <- Q2
// Q2 <- Q1
// Q1 <- Q0
// Q0 <- Q3
//==============================================================

module ring_counter_sync (
    input clk,
    input reset,
    output [3:0] Q
);

wire d3;
wire d2;
wire d1;
wire d0;

wire q3;
wire q2;
wire q1;
wire q0;

// Feedback
assign d3 = q2;
assign d2 = q1;
assign d1 = q0;
assign d0 = q3;

// Q0 resets to 1
dff_sync_reset1 FF0 (
    .clk(clk),
    .reset(reset),
    .D(d0),
    .Q(q0)
);

// Other flip-flops reset to 0
dff_sync_reset0 FF1 (
    .clk(clk),
    .reset(reset),
    .D(d1),
    .Q(q1)
);

dff_sync_reset0 FF2 (
    .clk(clk),
    .reset(reset),
    .D(d2),
    .Q(q2)
);

dff_sync_reset0 FF3 (
    .clk(clk),
    .reset(reset),
    .D(d3),
    .Q(q3)
);

assign Q = {q3, q2, q1, q0};

endmodule


//==============================================================
// LEVEL 4B : 4-BIT RING COUNTER
// ASYNCHRONOUS RESET
//==============================================================

module ring_counter_async (
    input clk,
    input reset,
    output [3:0] Q
);

wire d3;
wire d2;
wire d1;
wire d0;

wire q3;
wire q2;
wire q1;
wire q0;

assign d3 = q2;
assign d2 = q1;
assign d1 = q0;
assign d0 = q3;

dff_async_reset1 FF0 (
    .clk(clk),
    .reset(reset),
    .D(d0),
    .Q(q0)
);

dff_async_reset0 FF1 (
    .clk(clk),
    .reset(reset),
    .D(d1),
    .Q(q1)
);

dff_async_reset0 FF2 (
    .clk(clk),
    .reset(reset),
    .D(d2),
    .Q(q2)
);

dff_async_reset0 FF3 (
    .clk(clk),
    .reset(reset),
    .D(d3),
    .Q(q3)
);

assign Q = {q3, q2, q1, q0};

endmodule


//==============================================================
// LEVEL 5A : JOHNSON COUNTER
// SYNCHRONOUS RESET
//
// Reset = 0000
//
// Feedback:
// Q0 <- ~Q3
//
// Next state:
// Q3 <- Q2
// Q2 <- Q1
// Q1 <- Q0
// Q0 <- ~Q3
//==============================================================

module johnson_counter_sync (
    input clk,
    input reset,
    output [3:0] Q
);

wire d3;
wire d2;
wire d1;
wire d0;

wire q3;
wire q2;
wire q1;
wire q0;

wire not_q3;

// NOT gate used for Johnson feedback
not_gate N1 (
    .A(q3),
    .Y(not_q3)
);

assign d3 = q2;
assign d2 = q1;
assign d1 = q0;
assign d0 = not_q3;

dff_sync_reset0 FF0 (
    .clk(clk),
    .reset(reset),
    .D(d0),
    .Q(q0)
);

dff_sync_reset0 FF1 (
    .clk(clk),
    .reset(reset),
    .D(d1),
    .Q(q1)
);

dff_sync_reset0 FF2 (
    .clk(clk),
    .reset(reset),
    .D(d2),
    .Q(q2)
);

dff_sync_reset0 FF3 (
    .clk(clk),
    .reset(reset),
    .D(d3),
    .Q(q3)
);

assign Q = {q3, q2, q1, q0};

endmodule


//==============================================================
// LEVEL 5B : JOHNSON COUNTER
// ASYNCHRONOUS RESET
//==============================================================

module johnson_counter_async (
    input clk,
    input reset,
    output [3:0] Q
);

wire d3;
wire d2;
wire d1;
wire d0;

wire q3;
wire q2;
wire q1;
wire q0;

wire not_q3;

not_gate N1 (
    .A(q3),
    .Y(not_q3)
);

assign d3 = q2;
assign d2 = q1;
assign d1 = q0;
assign d0 = not_q3;

dff_async_reset0 FF0 (
    .clk(clk),
    .reset(reset),
    .D(d0),
    .Q(q0)
);

dff_async_reset0 FF1 (
    .clk(clk),
    .reset(reset),
    .D(d1),
    .Q(q1)
);

dff_async_reset0 FF2 (
    .clk(clk),
    .reset(reset),
    .D(d2),
    .Q(q2)
);

dff_async_reset0 FF3 (
    .clk(clk),
    .reset(reset),
    .D(d3),
    .Q(q3)
);

assign Q = {q3, q2, q1, q0};

endmodule


//==============================================================
// LEVEL 6 : RING COUNTER RTL
//==============================================================

module ring_counter_rtl (
    input clk,
    input reset,
    output reg [3:0] Q
);

always @(posedge clk)
begin
    if (reset)
        Q <= 4'b0001;
    else
        Q <= {Q[2:0], Q[3]};
end

endmodule


//==============================================================
// LEVEL 7 : JOHNSON COUNTER RTL
//==============================================================

module johnson_counter_rtl (
    input clk,
    input reset,
    output reg [3:0] Q
);

always @(posedge clk)
begin
    if (reset)
        Q <= 4'b0000;
    else
        Q <= {Q[2:0], ~Q[3]};
end

endmodule


//==============================================================
// LEVEL 8 : TOP MODULE
//==============================================================

module ring_johnson_counter_top (
    input clk,
    input reset,

    output [3:0] ring_sync,
    output [3:0] ring_async,

    output [3:0] johnson_sync,
    output [3:0] johnson_async,

    output [3:0] ring_rtl,
    output [3:0] johnson_rtl
);

ring_counter_sync RING_SYNC (
    .clk(clk),
    .reset(reset),
    .Q(ring_sync)
);

ring_counter_async RING_ASYNC (
    .clk(clk),
    .reset(reset),
    .Q(ring_async)
);

johnson_counter_sync JOHNSON_SYNC (
    .clk(clk),
    .reset(reset),
    .Q(johnson_sync)
);

johnson_counter_async JOHNSON_ASYNC (
    .clk(clk),
    .reset(reset),
    .Q(johnson_async)
);

ring_counter_rtl RING_RTL (
    .clk(clk),
    .reset(reset),
    .Q(ring_rtl)
);

johnson_counter_rtl JOHNSON_RTL (
    .clk(clk),
    .reset(reset),
    .Q(johnson_rtl)
);

endmodule