
`include "uvm_macros.svh"
`include "alu_interface.sv"
`include "alu_pkg.sv"
`include "design.sv"
module top;
        import uvm_pkg::*;
        import alu_pkg::*;

        bit CLK;
        bit RESET;

        initial CLK = 1'b0;
        always #5 CLK = ~ CLK;

        initial begin
        RESET = 1'b1;
        #5 RESET = 1'b0;
    end

        alu_interface intrf(CLK,RESET);

  ALU_DESIGN  #( .DW(`OP_WIDTH), .CW(`CMD_WIDTH) )
        DUV (  .OPA(intrf.OPA),
         .OPB(intrf.OPB),
         .INP_VALID(intrf.INP_VALID),
         .CIN(intrf.CIN),
         .CLK(intrf.CLK),
         .RST(intrf.RST),
         .CMD(intrf.CMD),
         .CE(intrf.CE),
         .MODE(intrf.MODE),
         .COUT(intrf.COUT),
         .OFLOW(intrf.OFLOW),
         .RES(intrf.RES),
         .G(intrf.G),
         .E(intrf.E),
         .L(intrf.L),
         .ERR(intrf.ERR) );

  initial begin
    uvm_config_db#(virtual alu_interface)::set(uvm_root::get(),"*","vif",intrf);
     $dumpfile("dump.vcd");
     $dumpvars;
  end

  initial begin
    run_test("test_regression");

        #100; $finish;
  end
endmodule
