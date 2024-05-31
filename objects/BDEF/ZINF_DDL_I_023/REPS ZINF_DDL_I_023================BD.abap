managed implementation in class zbp_inf_ddl_i_023 unique;
strict ( 2 );

define behavior for ZINF_DDL_I_023 //alias <alias_name>
persistent table zinf_t023
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t023
    {
      Bukrs        = bukrs;
      AccPrinciple = acc_principle;
      Afabe        = afabe;
    }
}