managed implementation in class zbp_inf_ddl_i_009 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_009 //alias <alias_name>
persistent table zinf_t009
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t009
    {
      Bukrs     = bukrs;
      CostHkont = cost_hkont;
      Rldnr     = rldnr;
    }
}