managed implementation in class zbp_inf_ddl_i_008 unique;
strict ( 2 );

define behavior for ZINF_DDL_I_008 alias Valuation
persistent table zinf_t008
lock master
authorization master ( instance )
//etag master <field_name>
{
  //  create;
  //  update;
  //  delete;


  action accountingPopup parameter ZINF_ABSTRACT_HKNT_VALUATION result [1] $self;
  action reversePopup result [1] $self;


  mapping for zinf_t008
    {
      Bukrs          = bukrs;
      Budat          = budat;
      Hkont          = hkont;
      Rldnr          = rldnr;
      DevirBudat     = devir_budat;
      DevirBelnr     = devir_belnr;
      DevirBuzei     = devir_buzei;
      Rtype          = rtype;
      Txt50          = txt50;
      Blart          = blart;
      AccPrinciple   = acc_principle;
      Dmbtr          = dmbtr;
      Waers          = waers;
      EndexDate      = endex_date;
      Factor         = factor;
      EndexBalance   = endex_balance;
      CorrectBalance = correct_balance;
      CorrectHkontBs = correct_hkont_bs;
      CorrectHkontPl = correct_hkont_pl;
      Belnr          = belnr;
      Gjahr          = gjahr;
      RevBelnr       = rev_belnr;
      RevGjahr       = rev_gjahr;
    }
}