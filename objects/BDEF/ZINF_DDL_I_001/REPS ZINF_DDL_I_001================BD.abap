managed implementation in class zbp_inf_ddl_i_001 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_001 alias t001
persistent table zinf_t001
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t001
    {
      RateType = rate_type;
      Budat    = budat;
      BankRate = bank_rate;
    }
}