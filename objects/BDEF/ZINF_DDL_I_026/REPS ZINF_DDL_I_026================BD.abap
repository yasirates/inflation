managed implementation in class zbp_inf_ddl_i_026 unique;
strict ( 2 );

define behavior for ZINF_DDL_I_026 //alias <alias_name>
persistent table zinf_t026
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;


  mapping for zinf_t026
    {
      Hkont         = hkont;
      BalanceAmount = balance_amount;
      Waers         = waers;
      Bukrs         = bukrs;
      EndexDate     = endex_date;
    }
}