managed implementation in class zbp_inf_ddl_i_010 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_010 //alias <alias_name>
persistent table zinf_t010
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t010
    {
      RateType = rate_type;
      RateDesc = rate_desc;
    }
}