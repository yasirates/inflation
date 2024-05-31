unmanaged implementation in class zbp_inf_i_hknt_valuation unique;
//strict ( 2 );

define behavior for ZINF_I_HKNT_VALUATION alias valuation
//late numbering
lock master
authorization master ( instance )
//etag master <field_name>
{

  create;
  update;
  delete;


  action accounting;
  action reverse;

}