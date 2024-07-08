managed implementation in class zbp_inf_ddl_i_027 unique;
strict ( 2 );

define behavior for ZINF_DDL_I_027 //alias <alias_name>
persistent table zinf_t027
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t027
    {
      Bukrs          = bukrs;
      Hkont          = hkont;
      Rldnr          = rldnr;
      Blart          = blart;
      AccPrinciple   = acc_principle;
      Statu          = statu;
      Source         = source;
      CorrectHkontBs = correct_hkont_bs;
      CorrectHkontPl = correct_hkont_pl;
    }
}