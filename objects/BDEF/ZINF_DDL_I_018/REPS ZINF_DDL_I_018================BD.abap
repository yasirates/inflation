managed implementation in class zbp_inf_ddl_i_018 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_018 //alias <alias_name>
persistent table zinf_t018
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t018
    {
      Bukrs   = bukrs;
      Anlkl   = anlkl;
    }
}