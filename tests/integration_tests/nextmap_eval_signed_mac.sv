// RUN: LAKEROAD="$LAKEROAD_DIR/bin/lakeroad-portfolio.py" \
// RUN: cargo run -- \
// RUN:   --bitwuzla \
// RUN:   --filepath %s \
// RUN:   --top-module-name top \
// RUN:   --architecture xilinx-ultrascale-plus \
// RUN:   --simulate \
// RUN:   --simulate-with-verilator-arg="--verilator_include_dir=$LAKEROAD_DIR/lakeroad-private/DSP48E2" \
// RUN:   --simulate-with-verilator-arg="--verilator_extra_arg=-DXIL_XECLIB" \
// RUN:   --simulate-with-verilator-arg="--verilator_extra_arg=-Wno-UNOPTFLAT" \
// RUN:   --simulate-with-verilator-arg="--verilator_extra_arg=-Wno-COMBDLY" \
// RUN:   --simulate-with-verilator-arg="--verilator_extra_arg=-Wno-LATCH" \
// RUN:   --simulate-with-verilator-arg="--verilator_extra_arg=-Wno-WIDTH" \
// RUN:   --simulate-with-verilator-arg="--verilator_extra_arg=-Wno-STMTDLY" \
// RUN:   --simulate-with-verilator-arg="--verilator_extra_arg=-Wno-CASEX" \
// RUN:   --simulate-with-verilator-arg="--verilator_extra_arg=-Wno-TIMESCALEMOD" \
// RUN:   --simulate-with-verilator-arg="--verilator_extra_arg=-Wno-PINMISSING" \
// RUN: | FileCheck %s

module top (
    input clk,
    input signed [15:0] a, b,
    input signed [31:0] c,
    output signed [31:0] p
);
    // pipeline depth = 2
    reg signed [31:0] p_reg0, p_reg1;

    always @(posedge clk) begin
        p_reg0 <= (a * b) + c;
        p_reg1 <= p_reg0;
    end

    assign p = p_reg1;
endmodule

// CHECK: module top(