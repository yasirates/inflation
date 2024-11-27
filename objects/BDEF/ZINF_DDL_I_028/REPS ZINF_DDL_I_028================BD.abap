managed implementation in class zbp_inf_ddl_i_028 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_028 //alias <alias_name>
persistent table zinf_t028
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( numbering : managed , readonly ) Uuid;

  mapping for zinf_t028
    {
      Uuid      = uuid;
      Hkont     = hkont;
      EndexDate = endex_date;
      Budat     = budat;
      Dmbtr     = dmbtr;
      Waers     = waers;
    }
}