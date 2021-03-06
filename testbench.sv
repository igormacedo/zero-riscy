// Code your testbench here
// or browse Examples
module zeroriscy_tb;

parameter N_EXT_PERF_COUNTERS = 0;
parameter RV32E = 0;
parameter RV32M = 0;

logic           clk_i;
logic           rst_ni;

logic           clock_en_i  = 1;    // enable clock, otherwise it is gated
logic           test_en_i = 0;     // enable all clock gates for testing

// Core ID, Cluster ID and boot address are considered more or less static
logic [ 3:0]    core_id_i = 1;
logic [ 5:0]    cluster_id_i = 1;
logic [31:0]    boot_addr_i = 0;

// Instruction memory interface
logic           instr_req_o;
logic           instr_gnt_i;
logic           instr_rvalid_i;
logic [31:0]    instr_addr_o;
logic [31:0]    instr_rdata_i;

// Data memory interface
logic           data_req_o;
logic           data_gnt_i;
logic           data_rvalid_i = 1'b0;
logic           data_we_o;
logic [3:0]     data_be_o;
logic [31:0]    data_addr_o;
logic [31:0]    data_wdata_o;
logic [31:0]    data_rdata_i;
logic           data_err_i;

// Interrupt /* inputs
logic           irq_i;           // level sensitive IR lines
logic [4:0]     irq_id_i;
logic           irq_ack_o;       // irq ack
logic [4:0]     irq_id_o;

// Debug Interface
logic           debug_req_i;
logic           debug_gnt_o;
logic           debug_rvalid_o;
logic [14:0]    debug_addr_i;
logic           debug_we_i;
logic [31:0]    debug_wdata_i;
logic [31:0]    debug_rdata_o;
logic           debug_halted_o;
logic           debug_halt_i;
logic           debug_resume_i;

// CPU Control Signals
logic                               fetch_enable_i;
//logic [N_EXT_PERF_COUNTERS-1:0]     ext_perf_counters_i;

zeroriscy_core #(.N_EXT_PERF_COUNTERS(N_EXT_PERF_COUNTERS), .RV32E(RV32E), .RV32M(RV32M)) dut(
  // Clock and Reset
  /* input  logic */        .clk_i(clk_i),
  /* input  logic */        .rst_ni(rst_ni),

  /* input  logic */        .clock_en_i(clock_en_i),    // enable clock, otherwise it is gated
  /* input  logic */        .test_en_i(test_en_i),     // enable all clock gates for testing

  // Core ID, Cluster ID and boot address are considered more or less static
  /* input  logic [ 3:0] */ .core_id_i(core_id_i),
  /* input  logic [ 5:0] */ .cluster_id_i(cluster_id_i),
  /* input  logic [31:0] */ .boot_addr_i(boot_addr_i),

  // Instruction memory interface
  /* output logic */        .instr_req_o(instr_req_o),
  /* input  logic */        .instr_gnt_i(instr_gnt_i),
  /* input  logic */        .instr_rvalid_i(instr_rvalid_i),
  /* output logic [31:0] */ .instr_addr_o(instr_addr_o),
  /* input  logic [31:0] */ .instr_rdata_i(instr_rdata_i),

  // Data memory interface
  /* output logic */        .data_req_o(data_req_o),
  /* input  logic */        .data_gnt_i(data_gnt_i),
  /* input  logic */        .data_rvalid_i(data_rvalid_i),
  /* output logic */        .data_we_o(data_we_o),
  /* output logic [3:0] */  .data_be_o(data_be_o),
  /* output logic [31:0] */ .data_addr_o(data_addr_o),
  /* output logic [31:0] */ .data_wdata_o(data_wdata_o),
  /* input  logic [31:0] */ .data_rdata_i(data_rdata_i),
  /* input  logic */        .data_err_i(data_err_i),

  // Interrupt /* inputs
  /* input  logic */        .irq_i(irq_i),                 // level sensitive IR lines
  /* input  logic [4:0] */  .irq_id_i(irq_id_i),
  /* output logic */        .irq_ack_o(irq_ack_o),             // irq ack
  /* output logic [4:0] */  .irq_id_o(irq_id_o),

  // Debug Interface
  /* input  logic */        .debug_req_i(debug_req_i),
  /* output logic */        .debug_gnt_o(debug_gnt_o),
  /* output logic */        .debug_rvalid_o(debug_rvalid_o),
  /* input  logic [14:0] */ .debug_addr_i(debug_addr_i),
  /* input  logic */        .debug_we_i(debug_we_i),
  /* input  logic [31:0] */ .debug_wdata_i(debug_wdata_i),
  /* output logic [31:0] */ .debug_rdata_o(debug_rdata_o),
  /* output logic */        .debug_halted_o(debug_halted_o),
  /* input  logic */        .debug_halt_i(debug_halt_i),
  /* input  logic */        .debug_resume_i(debug_resume_i),

  // CPU Control Signals
  /* input  logic */        .fetch_enable_i(fetch_enable_i),

  /* input  logic [N_EXT_PERF_COUNTERS-1:0] */ .ext_perf_counters_i()
);

initial clk_i = 1;
always #1 clk_i = ~clk_i;
  
/*addi r5, r0, imm(1)*/  
  logic[31:0] instruction1 = {12'b000000000011,5'b00000,3'b000,5'b00101,7'b0010011};

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, zeroriscy_tb);

    rst_ni = 0;
  	fetch_enable_i = 1;
  	instr_gnt_i = 0;
  	instr_rvalid_i = 0;
    #1;
    rst_ni = 1;
    #1;
 
 	// Fetch instruction protocol
  	instr_rdata_i = instruction1;
    instr_gnt_i =   1;
    instr_rvalid_i = 1;
  	#2;
  	instr_gnt_i = 0;
    instr_rvalid_i = 0;

  
    $finish;
end

endmodule