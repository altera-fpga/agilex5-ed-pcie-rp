
class sysrp_error_catcher extends uvm_report_catcher;

  uvm_severity cur_severity[$];
  string       msg_to_demote[$];

  `uvm_object_utils(sysrp_error_catcher)

  function new(string name = "sysrp_error_catcher");
     super.new(name);
  endfunction: new

  function set_msg_to_demote(string msg);
    msg_to_demote.push_back(msg);
  endfunction: set_msg_to_demote

  function set_severity_to_demote(uvm_severity severity);
    cur_severity.push_back(severity);
  endfunction: set_severity_to_demote

  function action_e catch();
    foreach (msg_to_demote[i]) begin
      if (!uvm_re_match(msg_to_demote[i], get_message())) begin
        if (get_severity() == cur_severity[i]) begin
          set_severity(UVM_INFO);
        end
      end
    end
    return THROW;
  endfunction: catch
endclass: sysrp_error_catcher
