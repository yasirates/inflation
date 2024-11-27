unmanaged implementation in class zbp_inf_custom_stk_correction unique;
//strict ( 1 );

define behavior for ZINF_CUSTOM_STK_CORRECTION alias stk_corr
//late numbering
lock master
authorization master ( instance )
//etag master <field_name>
{

  field ( readonly : update ) uuid;
  field ( readonly : update ) bukrs;
  field ( readonly : update ) rldnr;
  field ( readonly : update ) stock_hkont;
  field ( readonly : update ) rspmon;
  field ( readonly : update ) rtype;



  //  create;
  //  update;
  //  delete;
}