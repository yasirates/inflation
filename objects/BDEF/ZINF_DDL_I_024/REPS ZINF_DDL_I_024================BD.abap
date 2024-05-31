managed implementation in class zbp_inf_ddl_i_024 unique;
strict ( 2 );

define behavior for ZINF_DDL_I_024 //alias <alias_name>
persistent table zinf_t024
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;


  mapping for zinf_t024
    {
      Bukrs        = bukrs;
      AccPrinciple = acc_principle;
      Anln1        = anln1;
      Anln2        = anln2;
    }

}