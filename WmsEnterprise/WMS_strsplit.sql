create or replace
function WMS_strsplit(p_value varchar2,
                                    p_split varchar2 := ',')
-- select * from table(strsplit('1,2,3,4,5'))
 return strsplit_type
  pipelined is
  v_idx       integer;
  v_str       varchar2(500);
  v_strs_last varchar2(4000) := p_value;

begin
  loop
    v_idx := instr(v_strs_last, p_split);
    exit when v_idx = 0;
    v_str       := substr(v_strs_last, 1, v_idx - 1);
    v_strs_last := substr(v_strs_last, v_idx + 1);
    pipe row(v_str);
  end loop;
  pipe row(v_strs_last);
  return;

end WMS_strsplit;
 