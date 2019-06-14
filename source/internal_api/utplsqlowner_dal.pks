create or replace package utplsqlowner_dal is
 
  gc_fetch_limit constant number := 50000;
  
  type t_ut_compound_data_tmp is table of ut_compound_data_tmp%rowtype;
  type t_ut_compound_data_diff_tmp is table of ut_compound_data_diff_tmp%rowtype;
  
  procedure clean_expectations;
  
  procedure ins_ut_compound_data_tmp(
    a_data_id ut_compound_data_tmp.data_id%type, 
    a_set_id ut_compound_data_tmp.item_no%type, 
    a_xml in out nocopy ut_compound_data_tmp.item_data%type);
  
  function get_ut_compound_data_tmp(a_data_id ut_compound_data_tmp.data_id%type) return t_ut_compound_data_tmp
    pipelined;
    
  procedure get_ut_compound_data_xml(
      a_data_id ut_compound_data_tmp.data_id%type, 
      a_max_rows integer,
      a_result_tab out nocopy ut_utils.t_clob_tab);

end;
/
