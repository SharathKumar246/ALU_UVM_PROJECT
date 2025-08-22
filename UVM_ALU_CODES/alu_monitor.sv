
class alu_monitor extends uvm_monitor;

    virtual alu_interface vif;
    uvm_analysis_port#(alu_sequence_item) item_collected_port;
    alu_sequence_item trans_collected;

    `uvm_component_utils(alu_monitor)

  function new(string name="alu_monitor", uvm_component parent=null);
        super.new(name, parent);
        trans_collected = new();
        item_collected_port = new("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      if(!uvm_config_db#(virtual alu_interface)::get(this, "", "vif", vif))
                 `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction


    virtual task run_phase(uvm_phase phase);
           $display("in MON run phase ");

//       $display("in MON run phase after 3 dealy");
      forever
        begin

          @(vif.DRV_DONE);
          monitor_collect();
          $display("[MONITOR]sending at time=%t",$time);

          item_collected_port.write(trans_collected);
//           repeat(2)@(posedge vif.mon_cb);
//                trans_collected.print();
        end
    endtask

  virtual task monitor_collect();
                $display("in monitor_collect()");

        trans_collected.MODE = vif.MODE;
        trans_collected.CMD = vif.CMD;
        trans_collected.CIN = vif.CIN;
        trans_collected.CE = vif.CE;
        trans_collected.INP_VALID = vif.INP_VALID;
        trans_collected.OPA = vif.OPA;
        trans_collected.OPB = vif.OPB;

        trans_collected.RES = vif.RES;
        trans_collected.OFLOW = vif.OFLOW;
        trans_collected.COUT = vif.COUT;
        trans_collected.G = vif.G;
        trans_collected.L = vif.L;
        trans_collected.E = vif.E;
        trans_collected.ERR = vif.ERR;

//     trans_collected.print();
        `uvm_info(get_type_name(),
                  $sformatf("[MONITOR] CE=%0d CIN=%0d INP_VALID=%0d MODE=%0d CMD=%0d OPA=%0d OPB=%0d RES=%0d",
                trans_collected.CE, trans_collected.CIN, trans_collected.INP_VALID, trans_collected.MODE, trans_collected.CMD, trans_collected.OPA,trans_collected.OPB,trans_collected.RES),UVM_LOW);

  endtask

endclass
