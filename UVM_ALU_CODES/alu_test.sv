
class alu_base extends uvm_test;
      `uvm_component_utils(alu_base)

    alu_environment env;


    function new(string name = "alu_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = alu_environment::type_id::create("env", this);
      uvm_config_db#(uvm_active_passive_enum)::set(this,"env.passive_agent" , "is_passive" ,UVM_PASSIVE);
      uvm_config_db#(uvm_active_passive_enum)::set(this,"env.active_agent" , "is_active" ,UVM_ACTIVE);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
                super.build_phase(phase);
        uvm_top.print_topology();
    endfunction
endclass


class test1 extends alu_base;

  `uvm_component_utils(test1)
  function new(string name="test1",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_seq_1 seq1;
    phase.raise_objection(this);
    seq1 = alu_seq_1::type_id::create("seq1");
    $display("/////////////////////////////////////////////////---- [in test 1] ALL ARITHMETIC COMMANDS ----/////////////////////////////////////////////////\n");
//     repeat(10)begin
    seq1.start(env.active_agent.sequencer);
//     end
    phase.drop_objection(this);
  endtask
  endclass


class test2 extends alu_base;

  `uvm_component_utils(test2)
  function new(string name="test2",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_seq_2 seq2;
    phase.raise_objection(this);
    seq2 = alu_seq_2::type_id::create("seq2");
    $display("/////////////////////////////////////////////////---- [in test 2] ALL LOGICAL COMMANDS ----/////////////////////////////////////////////////\n");
//     repeat(10)begin
    seq2.start(env.active_agent.sequencer);
//     end
    phase.drop_objection(this);
  endtask

endclass



class test_regression extends alu_base;

  `uvm_component_utils(test_regression)
  function new(string name="test_regression",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_seq_regression seq;
    phase.raise_objection(this);
    seq = alu_seq_regression::type_id::create("seq");
    $display("/////////////////////////////////////////////////---- [in test_regression] ALL COMMANDS ----/////////////////////////////////////////////////\n");
     repeat(10)begin
    seq.start(env.active_agent.sequencer);
     end

    phase.drop_objection(this);
  endtask

endclass

