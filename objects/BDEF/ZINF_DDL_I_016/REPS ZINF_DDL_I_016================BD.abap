managed implementation in class zbp_inf_ddl_i_016 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_016 //alias <alias_name>
persistent table zinf_t016
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t016
    {
      Bukrs        = bukrs;
      Bwasl        = bwasl;
      Afabe        = afabe;
      Hkont        = hkont;
      Hkont2       = hkont_2;
      Blart        = blart;
      AccPrinciple = acc_principle;
    }
}