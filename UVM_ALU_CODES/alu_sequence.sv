
class alu_sequence extends uvm_sequence#(alu_sequence_item);
    `uvm_object_utils(alu_sequence)

  function new(string name = "alu_sequence");
        super.new(name);
    endfunction

//   task pre_body();
//     uvm_phase phase = get_starting_phase();
//     phase.raise_objection(this);
//   endtask

         virtual task body();
        alu_sequence_item req;
        req = alu_sequence_item::type_id::create("req");
        wait_for_grant();
        req.randomize();
        send_request(req);
        wait_for_item_done();
//        $display("item done");
    endtask

//   task post_body();
//     uvm_phase phase = get_starting_phase();
//     phase.drop_objection(this);
//   endtask
endclass



////////////////////////////////ARITHMETIC ALL COMMANDS////////////////////////////////
class alu_seq_1 extends uvm_sequence#(alu_sequence_item);
  int unsigned start_cmd = 0;
  int unsigned end_cmd   = 10;

  `uvm_object_utils(alu_seq_1)

  function new(string name = "alu_seq_1");
    super.new(name);
  endfunction

  virtual task body();
    $display("\n/////////////////////////////////////////////////---- [in seq 1] ALL ARITHMETIC COMMANDS ----/////////////////////////////////////////////////\n");
    for (int i = start_cmd; i <= end_cmd; i++) begin
      `uvm_info("Sequence", $sformatf("/////Starting ALU transaction for CMD=%0d/////", i), UVM_MEDIUM)
      `uvm_do_with(req,{req.CMD == i; req.MODE == 1; req.INP_VALID == 3; req.CE==1;})
    end
  endtask
endclass


////////////////////////////////LOGICAL ALL COMMANDS////////////////////////////////
class alu_seq_2 extends uvm_sequence#(alu_sequence_item);
  int unsigned start_cmd = 0;
  int unsigned end_cmd   = 13;

  `uvm_object_utils(alu_seq_2)

  function new(string name = "alu_seq_2");
    super.new(name);
  endfunction

  virtual task body();
    $display("\n/////////////////////////////////////////////////---- [in seq 2] ALL LOGICAL COMMANDS ----/////////////////////////////////////////////////\n");
    for (int i = start_cmd; i <= end_cmd; i++) begin
      `uvm_info("Sequence", $sformatf("/////Starting ALU transaction for CMD=%0d/////", i), UVM_MEDIUM)
      `uvm_do_with(req,{req.CMD == i; req.MODE == 0; req.INP_VALID == 3; req.CE==1;})
    end
  endtask
endclass


//////////////////////////////// INP_VALID = 00 ////////////////////////////////
class alu_seq_3 extends uvm_sequence#(alu_sequence_item);

  `uvm_object_utils(alu_seq_3)

  function new(string name = "alu_seq_3");
    super.new(name);
  endfunction

  virtual task body();
    $display("\n/////////////////////////////////////////////////---- [in seq 3] INP_VALID = 00  ----/////////////////////////////////////////////////\n");
    repeat(20)begin
    `uvm_do_with(req,{ req.CMD inside {[0:13]}; req.INP_VALID=='b00; req.CE==1;})
    end
  endtask
endclass


//////////////////////////////// OPA COMMANDS ONLY (INP_VALID=01) ////////////////////////////////
class alu_seq_4 extends uvm_sequence#(alu_sequence_item);

  `uvm_object_utils(alu_seq_4)

  function new(string name = "alu_seq_4");
    super.new(name);
  endfunction

  virtual task body();
    $display("\n/////////////////////////////////////////////////---- [in seq 4] OPA COMMANDS ONLY (INP_VALID=01)  ----/////////////////////////////////////////////////\n");
    repeat(20)begin
      `uvm_do_with(req,{req.INP_VALID=='b01; req.CE==1;
                        if(req.MODE)
                          req.CMD inside {4,5};
                        else
                          req.CMD inside {6,8,9};})
    end
  endtask
endclass


////////////////////////////////  OPB COMMANDS ONLY (INP_VALID=10)////////////////////////////////
class alu_seq_5 extends uvm_sequence#(alu_sequence_item);

  `uvm_object_utils(alu_seq_5)

  function new(string name = "alu_seq_5");
    super.new(name);
  endfunction

  virtual task body();
    $display("\n/////////////////////////////////////////////////---- [in seq 5] OPB COMMANDS ONLY (INP_VALID=10)  ----/////////////////////////////////////////////////\n");
    repeat(20)begin
      `uvm_do_with(req,{req.INP_VALID=='b10; req.CE==1;
                        if(req.MODE)
                          req.CMD inside {6,7};
                        else
                          req.CMD inside {7,10,11};})
    end
  endtask
endclass



//////////////////////////////// MULTIPLICATION ////////////////////////////////
class alu_seq_6 extends uvm_sequence#(alu_sequence_item);

  `uvm_object_utils(alu_seq_6)

  function new(string name = "alu_seq_6");
    super.new(name);
  endfunction

  virtual task body();
    $display("\n/////////////////////////////////////////////////---- [in seq 6] MULTIPLICATION  ----/////////////////////////////////////////////////\n");
    repeat(20)begin
      `uvm_do_with(req,{ req.CMD inside {9,10}; req.MODE == 1; req.INP_VALID== 3 ; req.CE==1;})
    end
  endtask
endclass

//////////////////////////////// 16 CLOCK TEST ////////////////////////////////
class alu_seq_7 extends uvm_sequence#(alu_sequence_item);

  `uvm_object_utils(alu_seq_7)

  function new(string name = "alu_seq_7");
    super.new(name);
  endfunction

  virtual task body();
    $display("\n/////////////////////////////////////////////////---- [in seq 7] 16 CLOCK TEST  ----/////////////////////////////////////////////////\n");
    repeat(20)begin
      `uvm_do_with(req,{ req.INP_VALID inside {1,2} ; req.CE==1;
                        if(req.MODE)
                          req.CMD inside {0,1,2,3,8,9,10};
                        else
                          req.CMD inside {0,1,2,3,4,5,12,13};})
    end
  endtask
endclass


//////////////////////////////// CE = 0  TEST ////////////////////////////////
class alu_seq_8 extends uvm_sequence#(alu_sequence_item);

  `uvm_object_utils(alu_seq_8)

  function new(string name = "alu_seq_8");
    super.new(name);
  endfunction

  virtual task body();
    $display("\n/////////////////////////////////////////////////----  CE = 0  ----/////////////////////////////////////////////////\n");
    repeat(20)begin
      `uvm_do_with(req,{req.CE==0;})
    end
  endtask
endclass

//////////////////////////////// COMPARE  TEST ////////////////////////////////
class alu_seq_9 extends uvm_sequence#(alu_sequence_item);

  `uvm_object_utils(alu_seq_9)

  function new(string name = "alu_seq_9");
    super.new(name);
  endfunction

  virtual task body();
    $display("\n/////////////////////////////////////////////////---- COMPARE  TEST ----/////////////////////////////////////////////////\n");
    repeat(20)begin
      `uvm_do_with(req,{req.CE==1; req.CMD==8; req.MODE==1;  req.INP_VALID==3;})
    end
  endtask
endclass



//////////////////////////////// --- R E G R E S S I O N ---- ////////////////////////////////
class alu_seq_regression extends uvm_sequence#(alu_sequence_item);

  alu_seq_1 seq1;
  alu_seq_2 seq2;
  alu_seq_3 seq3;
  alu_seq_4 seq4;
  alu_seq_5 seq5;
  alu_seq_6 seq6;
  alu_seq_7 seq7;
  alu_seq_8 seq8;
  alu_seq_9 seq9;


  `uvm_object_utils(alu_seq_regression)

  function new(string name = "alu_seq_regression");
    super.new(name);
  endfunction

  virtual task body();

    `uvm_do(seq1)
    `uvm_do(seq2)
    `uvm_do(seq3)
    `uvm_do(seq4)
    `uvm_do(seq5)
    `uvm_do(seq6)
    `uvm_do(seq7)
    `uvm_do(seq8)
    `uvm_do(seq9)

     repeat(20)begin
       `uvm_do(seq1)
       `uvm_do(seq2)
     end

  endtask
endclass
