managed implementation in class zbp_inf_ddl_i_007 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_007 //alias <alias_name>
persistent table zinf_t007
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( readonly ) AccTypeText;

  mapping for zinf_t007
    {
      Bukrs          = bukrs;
      StockHkont     = stock_hkont;
      Rldnr          = rldnr;
      AccType        = acc_type;
      Blart          = blart;
      AccPrinciple   = acc_principle;
      DiscountHkont  = discount_hkont;
      DiscountRate   = discount_rate;
      AvrIndexRate   = avr_index_rate;
      CorrectHkontBs = correct_hkont_bs;
      CorrectHkontPl = correct_hkont_pl;
    }
}