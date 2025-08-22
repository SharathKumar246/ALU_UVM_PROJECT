`include "defines.sv"
interface alu_interface(input logic CLK,RST);

  logic [1:0] INP_VALID;
  logic CE;
  logic MODE;
  logic CIN;
  logic [`CMD_WIDTH-1:0] CMD;
  logic [`OP_WIDTH-1:0] OPA,OPB;


  logic ERR;
  logic [`OP_WIDTH:0] RES;
  logic OFLOW;
  logic COUT;
  logic G;
  logic L;
  logic E;

event DRV_DONE;

  clocking drv_cb@(posedge CLK);
    default input #0 output #0;
    output CE,CIN,INP_VALID,MODE,CMD,OPA,OPB;
    input RST;
  endclocking

  clocking mon_cb@(posedge CLK);
    default input #0 output #0;
    input ERR,RES,OFLOW,COUT,G,L,E;
    input OPA,OPB,CIN,CE,MODE,CMD,INP_VALID;
  endclocking



  modport DRV(clocking drv_cb,input CLK,RST);
    modport MON(clocking mon_cb,input CLK,RST);

endinterface
