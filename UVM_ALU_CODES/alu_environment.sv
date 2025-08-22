
class alu_environment extends uvm_env;

        alu_agent      active_agent;
        alu_agent      passive_agent;

    alu_scoreboard scoreboard;
    alu_subscriber subscriber;
  `uvm_component_utils(alu_environment)

  function new(string name="alu_environment", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        active_agent = alu_agent::type_id::create("active_agent", this);
        passive_agent = alu_agent::type_id::create("passive_agent", this);
        scoreboard = alu_scoreboard::type_id::create("scoreboard", this);
        subscriber = alu_subscriber::type_id::create("subscriber",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      passive_agent.monitor.item_collected_port.connect(scoreboard.item_collected_export_passive);
      active_agent.monitor.item_collected_port.connect(subscriber.act_mon);
      passive_agent.monitor.item_collected_port.connect(subscriber.pass_mon);

    endfunction

endclass
