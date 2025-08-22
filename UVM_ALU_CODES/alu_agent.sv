
class alu_agent extends uvm_agent;

    alu_driver driver;
    alu_sequencer sequencer;
    alu_monitor monitor;

    `uvm_component_utils(alu_agent)

  function new(string name="alu_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(uvm_active_passive_enum) :: get(this,"","is_active",is_active);
        if (get_is_active() == UVM_ACTIVE) begin
            driver = alu_driver::type_id::create("driver", this);
            sequencer = alu_sequencer::type_id::create("sequencer", this);
        end
        monitor = alu_monitor::type_id::create("monitor", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        if (get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction

endclass
