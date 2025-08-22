
`include "defines.sv"

`uvm_analysis_imp_decl(_passive_mon)
`uvm_analysis_imp_decl(_active_mon)

class alu_subscriber extends uvm_component;

  `uvm_component_utils(alu_subscriber)
  uvm_analysis_imp_passive_mon #(alu_sequence_item,alu_subscriber) pass_mon;
  uvm_analysis_imp_active_mon #(alu_sequence_item,alu_subscriber) act_mon;

  alu_sequence_item pass_mon_seq,act_mon_seq;
  real drv_cvg,mon_cvg;

  covergroup driver_cov;
    coverpoint act_mon_seq.INP_VALID {  bins valid_opa = {2'b01};
                                        bins valid_opb = {2'b10};
                                    bins valid_both = {2'b11};
                                    bins invalid = {2'b00};
                                 }
    COMMAND : coverpoint act_mon_seq.CMD { bins arithmetic[] = {[0:10]};
                                         bins logical[] = {[0:13]};
                                         bins arithmetic_invalid[] = {[11:15]};
                                         bins logical_invalid[] = {14,15};
                                          }
      MODE : coverpoint act_mon_seq.MODE { bins arithmetic = {1};
                                         bins logical = {0};
                                       }
      CLOCK_ENABLE : coverpoint act_mon_seq.CE { bins clock_enable_valid = {1};
                                               bins clock_enable_invalid = {0};
                                               }
    OPERAND_A : coverpoint act_mon_seq.OPA { bins opa[]={[0:(2**`OP_WIDTH)-1]};}
    OPERAND_B : coverpoint act_mon_seq.OPB { bins opb[]={[0:(2**`OP_WIDTH)-1]};}
      CARRY_IN : coverpoint act_mon_seq.CIN { bins cin_high = {1};
                                            bins cin_low = {0};
                                          }
      MODE_CMD_: cross MODE,COMMAND;
  endgroup

  covergroup monitor_cov;
    RESULT_CHECK:coverpoint pass_mon_seq.RES { bins result[]={[0:(2**`OP_WIDTH)-1]};
                                                            option.auto_bin_max = 8;}
      CARR_OUT:coverpoint pass_mon_seq.COUT{ bins cout_active = {1};
                                          bins cout_inactive = {0};
                                        }
      OVERFLOW:coverpoint pass_mon_seq.OFLOW { bins oflow_active = {1};
                                            bins oflow_inactive = {0};
                                          }
      ERROR:coverpoint pass_mon_seq.ERR { bins error_active = {1};
                                     }
      GREATER:coverpoint pass_mon_seq.G { bins greater_active = {1};
                                     }
      EQUAL:coverpoint pass_mon_seq.E { bins equal_active = {1};
                                   }
      LESSER:coverpoint pass_mon_seq.L { bins lesser_active = {1};
                                    }
  endgroup

  function new(string name="alu_subscriber",uvm_component parent =null);
    super.new(name,parent);
    driver_cov = new();
    monitor_cov = new();
    pass_mon = new("pass_mon",this);
    act_mon = new("act_mon",this);
  endfunction

  function void write_active_mon(alu_sequence_item item);
        act_mon_seq = item;
                driver_cov.sample();
  endfunction

  function void write_passive_mon(alu_sequence_item item);
        pass_mon_seq = item;
                monitor_cov.sample();
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    drv_cvg = driver_cov.get_coverage();
    mon_cvg = monitor_cov.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
                super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("[Driver]: Coverage --> %0.2f", drv_cvg), UVM_MEDIUM);
    `uvm_info(get_type_name(), $sformatf("[Monitor]: Coverage --> %0.2f", mon_cvg), UVM_MEDIUM);
        endfunction
endclass
