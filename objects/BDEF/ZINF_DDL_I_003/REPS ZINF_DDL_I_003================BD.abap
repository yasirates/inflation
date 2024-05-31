managed implementation in class zbp_inf_ddl_i_003 unique;
strict ( 1 );

define behavior for ZINF_DDL_I_003 alias t003
persistent table zinf_t003
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t003
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