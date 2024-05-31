unmanaged implementation in class zbp_inf_i_gelir_tablo_endex unique;
//strict ( 2 );

define behavior for ZINF_I_GELIR_TABLO_ENDEX alias endex
//late numbering
lock master
authorization master ( instance )
//etag master <field_name>
{
  //create;
  //update;
  //delete;

  action accounting;
  action reverse;
}