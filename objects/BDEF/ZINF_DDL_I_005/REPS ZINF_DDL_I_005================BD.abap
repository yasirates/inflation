managed implementation in class zbp_inf_ddl_i_005 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_005 alias t005
persistent table zinf_t005
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t005
    {
      Bukrs   = bukrs;
      Gjahr   = gjahr;
      Monat   = monat;
      Hkont   = hkont;
      Dmbtr   = dmbtr;
      Waers   = waers;
    }
}