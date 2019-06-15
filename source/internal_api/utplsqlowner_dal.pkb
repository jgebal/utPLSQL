create or replace package body utplsqlowner_dal as

  procedure clean_expectations is
  begin
    delete from ut_compound_data_tmp;
    delete from ut_compound_data_diff_tmp;  
  end;

  procedure ins_ut_compound_data_tmp(
    a_data_id ut_compound_data_tmp.data_id%type, 
    a_set_id ut_compound_data_tmp.item_no%type, 
    a_xml in out nocopy ut_compound_data_tmp.item_data%type) is
  begin
    insert into ut_compound_data_tmp(data_id, item_no, item_data)
    values (a_data_id, a_set_id, a_xml);
  end;

  function get_ut_compound_data_tmp(a_data_id ut_compound_data_tmp.data_id%type) return t_ut_compound_data_tmp
    pipelined is
    l_rows t_ut_compound_data_tmp;
    cursor c_get_componund_tmp is
    select t.data_id ,t.item_no ,t.item_data ,t.item_hash ,t.pk_hash , t.duplicate_no
    from ut_compound_data_tmp t
    where t.data_id = a_data_id;
  begin
    open c_get_componund_tmp;
    loop
      fetch c_get_componund_tmp bulk collect into l_rows limit gc_fetch_limit;
      exit when l_rows.count = 0;     
      for idx in 1..l_rows.count loop
        pipe row(l_rows(idx));
      end loop;   
    end loop;
    close c_get_componund_tmp;
  end;

  procedure get_ut_compound_data_xml(
      a_data_id ut_compound_data_tmp.data_id%type, 
      a_max_rows integer,
      a_result_tab out nocopy ut_utils.t_clob_tab) is 
    l_results       ut_utils.t_clob_tab;
    cursor c_get_data_tmp is
    select xmlserialize( content ucd.item_data no indent)
            from ut_compound_data_tmp tmp
            ,xmltable ( '/ROWSET' passing tmp.item_data
            columns item_data xmltype PATH '*'         
            ) ucd where tmp.data_id = a_data_id and rownum <= a_max_rows;  
  begin
      --return first c_max_rows rows
    open c_get_data_tmp;
    fetch c_get_data_tmp bulk collect into a_result_tab;  
    close c_get_data_tmp;
  end;

end;
/
