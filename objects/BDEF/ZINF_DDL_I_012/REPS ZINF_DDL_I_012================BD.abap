managed implementation in class zbp_inf_ddl_i_012 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_012 //alias <alias_name>
persistent table zinf_t012
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t012
    {
      Bukrs          = bukrs;
      Rldnr          = rldnr;
      Stype          = stype;
      Hkont          = hkont;
      Blart          = blart;
      AccPrinciple   = acc_principle;
      CorrectHkontBs = correct_hkont_bs;
      CorrectHkontPl = correct_hkont_pl;
    }
}