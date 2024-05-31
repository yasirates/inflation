unmanaged implementation in class zbp_inf_custom_gelir_t_endex unique;
strict ( 1 );

define behavior for zinf_custom_gelir_t_endex alias endex
//late numbering
lock master
authorization master ( instance )
//etag master <field_name>
{

  field ( readonly : update ) Uuid;
  //  create;
  //  update;
  //  delete;
}