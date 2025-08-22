
`include"define.v"
`include"defines.sv"

class alu_scoreboard extends uvm_scoreboard;

virtual alu_interface vif;

alu_sequence_item packet_queue[$];
alu_sequence_item expected;

int match,mismatch,total_transaction;

  `uvm_component_utils(alu_scoreboard)

  uvm_analysis_imp #(alu_sequence_item, alu_scoreboard)  item_collected_export_passive;

  function new (string name, uvm_component parent);
    super.new(name, parent);
    expected=new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual alu_interface)::get(this,"","vif",vif);
    item_collected_export_passive = new("item_collected_export_passive", this);
  endfunction

  virtual function void write(alu_sequence_item packet);
    $display("Scoreboard Received:: Packet at time =%0t",$time);
    packet_queue.push_back(packet);
    `uvm_info(get_type_name(),$sformatf("[FROM MONITOR]OPA=%d OPB=%d CIN=%d CMD=%d INP_VALID=%d MODE=%d RES=%d",packet.OPA,packet.OPB,packet.CIN,packet.CMD,packet.INP_VALID,packet.MODE,packet.RES),UVM_LOW);
  endfunction

  function void CMD_NAME(alu_sequence_item actual);
    if(actual.MODE)begin
        case(actual.CMD)

        `ADD:`uvm_info(get_type_name(),$sformatf("-------------------------ADD------------------------------- "),UVM_LOW)
        `SUB:`uvm_info(get_type_name(),$sformatf("-------------------------SUB------------------------------- "),UVM_LOW)
        `ADD_CIN:`uvm_info(get_type_name(),$sformatf("-------------------------ADD_CIN------------------------------- "),UVM_LOW)
        `SUB_CIN:`uvm_info(get_type_name(),$sformatf("-------------------------SUB_CIN------------------------------- "),UVM_LOW)
        `INC_A:`uvm_info(get_type_name(),$sformatf("-------------------------INC_A------------------------------- "),UVM_LOW)
        `DEC_A:`uvm_info(get_type_name(),$sformatf("-------------------------DEC_A------------------------------- "),UVM_LOW)
        `INC_B:`uvm_info(get_type_name(),$sformatf("-------------------------INC_B------------------------------- "),UVM_LOW)
        `DEC_B:`uvm_info(get_type_name(),$sformatf("-------------------------DEC_B------------------------------- "),UVM_LOW)
        `CMP:`uvm_info(get_type_name(),$sformatf("-------------------------CMP------------------------------- "),UVM_LOW)
        `MULT_INC:`uvm_info(get_type_name(),$sformatf("-------------------------MULT_INC------------------------------- "),UVM_LOW)
        `MULT_SHIFT:`uvm_info(get_type_name(),$sformatf("-------------------------MULT_SHIFT------------------------------- "),UVM_LOW)
         default:`uvm_info(get_type_name(),$sformatf("-------------------------Defualt error CMD------------------------------- "),UVM_LOW)
        endcase
        end

     else begin
        case(actual.CMD)
        `AND:`uvm_info(get_type_name(),$sformatf("-------------------------AND------------------------------- "),UVM_LOW)
        `NAND:`uvm_info(get_type_name(),$sformatf("-------------------------NAND------------------------------- "),UVM_LOW)
        `OR:`uvm_info(get_type_name(),$sformatf("-------------------------OR------------------------------- "),UVM_LOW)
        `NOR:`uvm_info(get_type_name(),$sformatf("-------------------------NOR------------------------------- "),UVM_LOW)
        `XOR:`uvm_info(get_type_name(),$sformatf("-------------------------XOR------------------------------- "),UVM_LOW)
        `XNOR:`uvm_info(get_type_name(),$sformatf("-------------------------XNOR------------------------------- "),UVM_LOW)
        `NOT_A:`uvm_info(get_type_name(),$sformatf("-------------------------NOT_A------------------------------- "),UVM_LOW)
        `NOT_B:`uvm_info(get_type_name(),$sformatf("-------------------------NOT_B------------------------------- "),UVM_LOW)
        `SHR1_A:`uvm_info(get_type_name(),$sformatf("-------------------------SHR1_A------------------------------- "),UVM_LOW)
        `SHL1_A:`uvm_info(get_type_name(),$sformatf("-------------------------SHL1_A------------------------------- "),UVM_LOW)
        `SHR1_B:`uvm_info(get_type_name(),$sformatf("-------------------------SHR1_B------------------------------- "),UVM_LOW)
        `SHL1_B:`uvm_info(get_type_name(),$sformatf("-------------------------SHL1_B------------------------------- "),UVM_LOW)
        `ROL_A_B:`uvm_info(get_type_name(),$sformatf("-------------------------ROL_A_B------------------------------- "),UVM_LOW)
        `ROR_A_B:`uvm_info(get_type_name(),$sformatf("-------------------------ROR_A_B------------------------------- "),UVM_LOW)
      default:`uvm_info(get_type_name(),$sformatf("-------------------------Defualt error CMD------------------------------- "),UVM_LOW)
    endcase
         end
  endfunction

  function void compare(alu_sequence_item expected, alu_sequence_item actual);
    if((expected.RES===actual.RES &&
       (expected.ERR===actual.ERR) &&
       (expected.OFLOW===actual.OFLOW)&&
        (expected.COUT===actual.COUT)&&
        (expected.G===actual.G)&&
        (expected.L===actual.L)&&
        (expected.E===actual.E)))
              begin
                 match++;
                 total_transaction++;
                `uvm_info(get_type_name(),$sformatf("-------------------------------------------------------- "),UVM_LOW);
                 CMD_NAME(actual);
                `uvm_info(get_type_name(),"-------------------------MATCH SUCCESSFULL-------------------------------",UVM_LOW);
                `uvm_info(get_type_name(),$sformatf("OPA=%d OPB=%d CIN =%d CMD=%d INP_VALID=%d MODE=%d",actual.OPA,actual.OPB,actual.CIN,actual.CMD,actual.INP_VALID,actual.MODE),UVM_LOW);

                `uvm_info(get_type_name(),$sformatf(" EXPECTED : RES=%d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E= %d",expected.RES,expected.ERR,expected.OFLOW,expected.COUT,expected.G,expected.L,expected.E),UVM_LOW);
                `uvm_info(get_type_name(),$sformatf(" ACTUAL   : RES=%d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E= %d",actual.RES,actual.ERR,actual.OFLOW,actual.COUT,actual.G,actual.L,actual.E),UVM_LOW);

                `uvm_info(get_type_name(),$sformatf("-------------------------------------------------------- "),UVM_LOW);
               end
              else
                begin
                        mismatch++;
                        total_transaction++;
                    `uvm_info(get_type_name(),$sformatf("-------------------------------------------------------- "),UVM_LOW);
                    CMD_NAME(actual);
                                   `uvm_info(get_type_name(),"-------------------------MATCH FAILED-------------------------------",UVM_LOW);
                   `uvm_info(get_type_name(),$sformatf("OPA=%d OPB=%d CIN =%d CMD=%d INP_VALID=%d MODE=%d",actual.OPA,actual.OPB,actual.CIN,actual.CMD,actual.INP_VALID,actual.MODE),UVM_LOW);
                  `uvm_info(get_type_name(),$sformatf(" EXPECTED : RES=%d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E= %d",expected.RES,expected.ERR,expected.OFLOW,expected.COUT,expected.G,expected.L,expected.E),UVM_LOW);
                  `uvm_info(get_type_name(),$sformatf(" ACTUAL   : RES=%d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E= %d",actual.RES,actual.ERR,actual.OFLOW,actual.COUT,actual.G,actual.L,actual.E),UVM_LOW);

                `uvm_info(get_type_name(),$sformatf("---------------------------------------------------- "),UVM_LOW);

                end
          `uvm_info(get_type_name(),$sformatf("|||||||||||   MATCH = %0d ,MISMATCH = %0d   |||||||||||",match,mismatch),UVM_MEDIUM);
          `uvm_info(get_type_name(),$sformatf("||||||||||||||  TOTAL TRANSACTION = %0d  ||||||||||||||",total_transaction),UVM_MEDIUM);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_sequence_item actual;
    forever begin
      wait(packet_queue.size()>0);
      actual = packet_queue.pop_front();
      `uvm_info(get_type_name(),$sformatf("[packet (POPPED)]OPA=%d OPB=%d CIN=%d CMD=%d INP_VALID=%d MODE=%d",actual.OPA,actual.OPB,actual.CIN,actual.CMD,actual.INP_VALID,actual.MODE),UVM_LOW);
      if(vif.RST)begin
        `uvm_info(get_type_name(),"ENTERED RST=1",UVM_LOW);
                expected.RES=9'bz;
            expected.OFLOW=1'bz;
            expected.COUT=1'bz;
            expected.ERR=1'bz;
            expected.G=1'bz;
            expected.L=1'bz;
            expected.E=1'bz;
      end
      if(actual.CE==1)
      begin
        `uvm_info(get_type_name(),"ENTERED CE=1",UVM_LOW);
                expected.RES=9'bz;
            expected.OFLOW=1'bz;
            expected.COUT=1'bz;
            expected.ERR=1'bz;
            expected.G=1'bz;
            expected.L=1'bz;
            expected.E=1'bz;
        if(actual.MODE)
          begin
            //ARITHMETIC
            if(actual.INP_VALID==2'd3)
            begin// MODE 1 - INP_VALID 11
              `uvm_info(get_type_name(),"ENTERED inside INP_VALID=11 MODE=1",UVM_LOW);

              case(actual.CMD)
                `ADD:begin
                         expected.RES=actual.OPA+actual.OPB;
                         expected.COUT=expected.RES[`OP_WIDTH];
                         end

                `SUB:begin
                         expected.RES=actual.OPA-actual.OPB;
                         expected.OFLOW=(actual.OPA<actual.OPB);
                         end

                `ADD_CIN:begin
                                 expected.RES=actual.OPA+actual.OPB+actual.CIN;
                         expected.COUT=expected.RES[`OP_WIDTH];
                                 end

                `SUB_CIN:begin
                                 expected.RES=actual.OPA-actual.OPB-actual.CIN;
                             expected.OFLOW=(actual.OPA<(actual.OPB + actual.CIN));
                                 end

                `INC_A: expected.RES=actual.OPA+1;
                `DEC_A: expected.RES=actual.OPA-1;
                `INC_B: expected.RES=actual.OPB+1;
                `DEC_B: expected.RES=actual.OPB-1;
                `CMP: begin
                   expected.E=(actual.OPA==actual.OPB)? 1'b1:1'bz;
                   expected.G=(actual.OPA>actual.OPB)? 1'b1:1'bz;
                   expected.L=(actual.OPA<actual.OPB)? 1'b1:1'bz;
                end
                `MULT_INC: expected.RES=(actual.OPA+1)*(actual.OPB+1);
                `MULT_SHIFT: expected.RES=(actual.OPA<<1)*(actual.OPB);

                default: begin
                    expected.RES=9'bz;
                    expected.OFLOW=1'bz;
                    expected.COUT=1'bz;
                    expected.ERR=1'bz;
                    expected.G=1'bz;
                    expected.L=1'bz;
                    expected.E=1'b1;
                end
              endcase
              compare(expected,actual);

        end
            else if(actual.INP_VALID==2'b01)
         begin// MODE 1 - INP_VALID 01
           `uvm_info(get_type_name(),"ENTERED inside INP_VALID=01 MODE=1",UVM_LOW);
           case(actual.CMD)
                `INC_A: begin
                  `uvm_info(get_type_name(),"INC A",UVM_LOW);
                  expected.RES=actual.OPA+1;
                end
                `DEC_A: expected.RES=actual.OPA-1;
                 default: begin
                        expected.RES=9'bz;
                        expected.OFLOW=1'bz;
                        expected.COUT=1'bz;
                        expected.G=1'bz;
                        expected.L=1'bz;
                        expected.E=1'bz;
                        expected.ERR=1'b1;
                end
               endcase
               compare(expected,actual);

         end
            else if(actual.INP_VALID==2'b10)
              begin // MODE 1 - INP_VALID 10
                `uvm_info(get_type_name(),"ENTERED inside INP_VALID=10 MODE=1",UVM_LOW);
              case(actual.CMD)
                `INC_B: expected.RES=actual.OPB+1;
                `DEC_B: expected.RES=actual.OPB-1;
                 default: begin
                        expected.RES=9'bz;
                        expected.OFLOW=1'bz;
                        expected.COUT=1'bz;
                        expected.G=1'bz;
                        expected.L=1'bz;
                        expected.E=1'bz;
                        expected.ERR=1'b1;
                end
               endcase
               compare(expected,actual);
              end

              else
                begin//// MODE 1 - INP_VALID 00
                  `uvm_info(get_type_name(),"ENTERED inside INP_VALID=00 MODE=1",UVM_LOW);
                        expected.RES=9'bz;
                        expected.OFLOW=1'bz;
                        expected.COUT=1'bz;
                        expected.G=1'bz;
                        expected.L=1'bz;
                        expected.E=1'bz;
                        expected.ERR=1'bz;
                  compare(expected,actual);
                end

          end
        else
          begin
            //LOGICAL

            if(actual.INP_VALID==2'd3)
            begin// MODE 0 - INP_VALID 11
              `uvm_info(get_type_name(),"ENTERED inside INP_VALID=11 MODE=0",UVM_LOW);

              case(actual.CMD)
                `AND: expected.RES={1'b0,(actual.OPA & actual.OPB)};
                `NAND: expected.RES={1'b0,~(actual.OPA & actual.OPB)};
                `OR: expected.RES={1'b0,(actual.OPA | actual.OPB)};
                `NOR: expected.RES={1'b0,~(actual.OPA | actual.OPB)};
                `XOR: expected.RES={1'b0,(actual.OPA ^ actual.OPB)};
                `XNOR: expected.RES={1'b0,~(actual.OPA ^ actual.OPB)};
                `NOT_A: expected.RES={1'b0,~(actual.OPA)};
                `NOT_B: expected.RES={1'b0,~(actual.OPB)};
                `SHR1_A: expected.RES={1'b0,(actual.OPA>>1)};
                `SHL1_A: expected.RES={1'b0,(actual.OPA<<1)};
                `SHR1_B: expected.RES={1'b0,(actual.OPB>>1)};
                `SHL1_B: expected.RES={1'b0,(actual.OPB<<1)};
                `ROL_A_B: begin
                   expected.RES = (actual.OPA << actual.OPB[`ROR_WIDTH-1:0]) | (actual.OPA >> (`OP_WIDTH - actual.OPB[`ROR_WIDTH-1:0]));
                 if (|actual.OPB[7:4]) expected.ERR = 1'b1;
                 end
                `ROR_A_B: begin
                   expected.RES = (actual.OPA >> actual.OPB[`ROR_WIDTH-1:0]) | (actual.OPA << (`OP_WIDTH - actual.OPB[`ROR_WIDTH-1:0]));
                 if (|actual.OPB[7:4]) expected.ERR = 1'b1;
                 end

                default: begin
                    expected.RES=9'bz;
                    expected.OFLOW=1'bz;
                    expected.COUT=1'bz;
                    expected.ERR=1'bz;
                    expected.G=1'bz;
                    expected.L=1'bz;
                    expected.E=1'b1;
                end
              endcase
              compare(expected,actual);

        end
            else if(actual.INP_VALID==2'd1)
         begin// MODE 0 - INP_VALID 01
           `uvm_info(get_type_name(),"ENTERED inside INP_VALID=01 MODE=0",UVM_LOW);
           case(actual.CMD)
                `NOT_A: expected.RES={1'b0,~(actual.OPA)};
                `SHR1_A: expected.RES={1'b0,(actual.OPA>>1)};
                `SHL1_A: expected.RES={1'b0,(actual.OPA<<1)};
                 default: begin
                        expected.RES=9'bz;
                        expected.OFLOW=1'bz;
                        expected.COUT=1'bz;
                        expected.G=1'bz;
                        expected.L=1'bz;
                        expected.E=1'bz;
                        expected.ERR=1'b1;
                end
               endcase
               compare(expected,actual);

         end
            else if(actual.INP_VALID==2'd2)
              begin // MODE 0 - INP_VALID 10
                `uvm_info(get_type_name(),"ENTERED inside INP_VALID=10 MODE=0",UVM_LOW);
              case(actual.CMD)
                `NOT_B: expected.RES={1'b0,~(actual.OPB)};
                `SHR1_B: expected.RES={1'b0,(actual.OPB>>1)};
                `SHL1_B: expected.RES={1'b0,(actual.OPB<<1)};
                 default: begin
                        expected.RES=9'bz;
                        expected.OFLOW=1'bz;
                        expected.COUT=1'bz;
                        expected.G=1'bz;
                        expected.L=1'bz;
                        expected.E=1'bz;
                        expected.ERR=1'b1;
                end
               endcase
               compare(expected,actual);
              end

              else
                begin// MODE 0 - INP_VALID 00
                  `uvm_info(get_type_name(),$sformatf("ENTERED inside INP_VALID=00 MODE=0"),UVM_LOW);
                        expected.RES=9'bz;
                        expected.OFLOW=1'bz;
                        expected.COUT=1'bz;
                        expected.G=1'bz;
                        expected.L=1'bz;
                        expected.E=1'bz;
                        expected.ERR=1'bz;
                  compare(expected,actual);
                end

          end
      end
      else//CE==0
        begin
          `uvm_info(get_type_name(),"CE = 0",UVM_LOW);
       actual.RES=actual.RES;
       actual.OFLOW=actual.OFLOW;
       actual.COUT=actual.COUT;
       actual.G=actual.G;
       actual.L=actual.L;
       actual.E=actual.E;
       actual.ERR=actual.ERR;
          `uvm_info(get_type_name(),$sformatf("(ACTUAL DATA CE=0)RES=%d OFLOW=%d COUT=%d G=%d L=%d E =%d ERR=%d",actual.RES,actual.OFLOW,actual.COUT,actual.G,actual.L,actual.E,actual.ERR),UVM_LOW);
                            compare(expected,actual);

        end

    end
  endtask
endclass
