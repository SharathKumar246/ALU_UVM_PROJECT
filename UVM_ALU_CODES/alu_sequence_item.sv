
`include "uvm_macros.svh"
`include "defines.sv"

import uvm_pkg::*;

class alu_sequence_item extends uvm_sequence_item;

    rand logic [`OP_WIDTH-1:0] OPA;
    rand logic [`OP_WIDTH-1:0] OPB;
    rand logic CIN;
    rand logic CE;
    rand logic MODE;
    rand logic [1:0] INP_VALID;
    rand logic [`CMD_WIDTH-1:0] CMD;

    logic [`OP_WIDTH:0] RES;
    logic OFLOW;
    logic COUT;
    logic G, L, E;
    logic ERR;

  `uvm_object_utils_begin(alu_sequence_item)
    `uvm_field_int(OPA, UVM_ALL_ON)
    `uvm_field_int(OPB, UVM_ALL_ON)
    `uvm_field_int(CIN, UVM_ALL_ON)
    `uvm_field_int(CE, UVM_ALL_ON)
    `uvm_field_int(MODE, UVM_ALL_ON)
    `uvm_field_int(INP_VALID, UVM_ALL_ON)
    `uvm_field_int(CMD, UVM_ALL_ON)
    `uvm_field_int(RES, UVM_ALL_ON)
    `uvm_field_int(OFLOW, UVM_ALL_ON)
    `uvm_field_int(COUT, UVM_ALL_ON)
    `uvm_field_int(G, UVM_ALL_ON)
    `uvm_field_int(L, UVM_ALL_ON)
    `uvm_field_int(E, UVM_ALL_ON)
    `uvm_field_int(ERR, UVM_ALL_ON)
    `uvm_object_utils_end

  function new(string name = "alu_sequence_item");
        super.new(name);
    endfunction

endclass
