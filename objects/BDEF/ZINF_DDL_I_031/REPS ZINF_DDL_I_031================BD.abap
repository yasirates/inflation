managed implementation in class zbp_inf_ddl_i_031 unique;
strict ( 2 );

define behavior for ZINF_DDL_I_031 //alias <alias_name>
persistent table zinf_t031
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
//  field ( readonly ) Amountinglobalcurrency, Amountinfreedefinedcurrency1;
}