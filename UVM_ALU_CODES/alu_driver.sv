
class alu_driver extends uvm_driver #(alu_sequence_item);

  `uvm_component_utils(alu_driver)

  virtual alu_interface vif;


  bit found_valid_11;

  function new (string name, uvm_component parent);
    super.new(name, parent);
    found_valid_11 = 1'b0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_interface)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    $display("in DRV run phase ");
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

  virtual task drive();
        @(posedge vif.drv_cb);

    //  Main decision block
    if (req.INP_VALID == 2'b11 || req.INP_VALID == 2'b00) begin
      // Direct drive for INP_VALID == 11 or 00
      drive_to_if(req);
      apply_timing(req);
          ->vif.DRV_DONE;
    end
    else if (((req.INP_VALID == 2'b01) && (req.MODE == 1) && (req.CMD inside {4, 5})) ||
             ((req.INP_VALID == 2'b10) && (req.MODE == 1) && (req.CMD inside {6, 7})) ||
             ((req.INP_VALID == 2'b01) && (req.MODE == 0) && (req.CMD inside {6, 8, 9})) ||
             ((req.INP_VALID == 2'b10) && (req.MODE == 0) && (req.CMD inside {7, 10, 11}))) begin
      // Single operand ops for INP_VALID == 01 or 10
      drive_to_if(req);
      apply_timing(req);
      ->vif.DRV_DONE;

    end
    else begin
      // First drive original transaction
      drive_to_if(req);
//       apply_timing(req);
//       ->vif.DRV_DONE;

//////////////////// 16-cycle wait/randomize sequence////////////////////
      found_valid_11 = 1'b0;
      for (int clk_count = 0; clk_count < 16 && !found_valid_11; clk_count++) begin:forloop
        alu_sequence_item temp_req = new();
        temp_req.copy(req);
        temp_req.CE.rand_mode(0);
        temp_req.CMD.rand_mode(0);
        temp_req.MODE.rand_mode(0);
//        temp_req.INP_VALID.rand_mode(0);
        void'(temp_req.randomize());

//         repeat (1) @(vif.drv_cb);
//                      drive_to_if(temp_req);

//         item_collected_port.write(temp_req);

        if (temp_req.INP_VALID == 2'b11) begin
                found_valid_11 = 1'b1;
            `uvm_info(get_type_name(), $sformatf("///FOUND INP_VALID == 11 at cycle %0d///", clk_count + 1), UVM_LOW);
                repeat (1) @(vif.drv_cb);
                drive_to_if(temp_req);
                apply_timing(temp_req);
                ->vif.DRV_DONE;
            break;
        end
        `uvm_info(get_type_name(), $sformatf("[Waiting] inside 16 clk [cycle %0d]", clk_count + 1),UVM_LOW);
         repeat (1) @(vif.drv_cb);
         drive_to_if(temp_req);
      end:forloop

      if (!found_valid_11) begin
        `uvm_info(get_type_name(), "///////////DID NOT FIND INP_VALID == 11 WITHIN 16 CLOCK CYCLES//////////", UVM_LOW);
      end
    end

  endtask

  //  Drive to interface
  virtual task drive_to_if(alu_sequence_item tr);
    vif.drv_cb.CE        <= tr.CE;
    vif.drv_cb.CIN       <= tr.CIN;
    vif.drv_cb.INP_VALID <= tr.INP_VALID;
    vif.drv_cb.MODE      <= tr.MODE;
    vif.drv_cb.CMD       <= tr.CMD;
    vif.drv_cb.OPA       <= tr.OPA;
    vif.drv_cb.OPB       <= tr.OPB;
//     tr.print();
    `uvm_info(get_type_name(),
              $sformatf("[DRIVER] CE=%0d CIN=%0d INP_VALID=%0d MODE=%0d CMD=%0d OPA=%0d OPB=%0d",
                tr.CE, tr.CIN, tr.INP_VALID, tr.MODE, tr.CMD, tr.OPA, tr.OPB),
      UVM_LOW);
  endtask

  //Timing logic
  virtual task apply_timing(alu_sequence_item tr);

    if (tr.MODE && (tr.CMD inside {'d9, 'd10}))begin
      repeat(3) @(vif.drv_cb);
    end
    else begin
      $display("Entry inside apply time %0t",$time);
      repeat(2)@(vif.drv_cb);
      $display("Exiting apply time %0t",$time);
    end

  endtask

endclass
