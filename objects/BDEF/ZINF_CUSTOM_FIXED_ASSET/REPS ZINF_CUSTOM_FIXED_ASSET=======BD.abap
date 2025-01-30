unmanaged implementation in class zbp_inf_custom_fixed_asset unique;
//strict ( 2 ); //Uncomment this line in order to enable strict mode 2. The strict mode has two variants (strict(1), strict(2)) and is prerequisite to be future proof regarding syntax and to be able to release your BO.

define behavior for zinf_custom_fixed_asset //alias <alias_name>

lock master
authorization master ( instance )
//etag master <field_name>
{


//create;
//update;
//delete;

  //field ( readonly ) uuid, bukrs, anln1, anln2, rldnr, valuation_date, index_date;
}