unmanaged implementation in class zbp_inf_custom_stock_trans_spe unique;
//strict ( 2 ); //Uncomment this line in order to enable strict mode 2. The strict mode has two variants (strict(1), strict(2)) and is prerequisite to be future proof regarding syntax and to be able to release your BO.

define behavior for ZINF_CUSTOM_STOCK_TRANS_SPEED alias stockReport
//late numbering
lock master
authorization master ( instance )
//etag master <field_name>
{
//  create;
//  update;
//  delete;

}