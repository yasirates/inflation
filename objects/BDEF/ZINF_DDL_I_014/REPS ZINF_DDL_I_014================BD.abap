managed implementation in class zbp_inf_ddl_i_014 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_014 //alias <alias_name>
persistent table zinf_t014
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t014
    {
      Bukrs        = bukrs;
      Rldnr        = rldnr;
      Hkont        = hkont;
      Blart        = blart;
      AccPrinciple = acc_principle;
      ZdhbBil      = zdhb_bil;
      Zdhb_pl      = zdhb_pl;
    }
}