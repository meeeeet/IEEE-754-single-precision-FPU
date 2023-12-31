class fpu_monitor extends uvm_monitor;
    `uvm_component_utils(fpu_monitor)
    virtual fpu_if fpu_vif;
  	fpu_sequence_item item;
/* ------------------------------- constructor ------------------------------ */
    function new(string name="fpu_monitor",uvm_component parent);
        super.new(name,parent);
        `uvm_info("fpu_monitor", "Inside constructor of fpu_monitor", UVM_LOW)
    endfunction

/* ------------------------------- build_phase ------------------------------ */
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), "Inside build phase", UVM_LOW)

      if(!(uvm_config_db #(virtual fpu_if)::get(this,"*","fpu_vif",fpu_vif)))
            `uvm_error(get_name(), "Faild to get Virtual IF from database........")  
          
    endfunction: build_phase

/* ------------------------------ connect_phase ----------------------------- */
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_name(), "Inside connect phase", UVM_LOW)
    endfunction

/* -------------------------------- run_phase ------------------------------- */
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Inside run phase", UVM_LOW)
      forever begin
        item=fpu_sequence_item::type_id::create("item");
        //sample inputs
        @(negedge fpu_vif.clk);
        item.a<=fpu_vif.a;
        item.b<=fpu_vif.b;
        item.opcode<=fpu_vif.opcode;
        @(posedge fpu_vif.clk);
        item.out<=fpu_vif.out;
        print(item);
      end
    endtask
  
    task print(fpu_sequence_item item);
    `uvm_info(get_name(),$sformatf("Received data: %b %b %b",item.a,item.b,item.opcode),UVM_LOW)
  endtask


endclass: fpu_monitor