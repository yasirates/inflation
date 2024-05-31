unmanaged implementation in class zbp_inf_custom_hknt_valuation unique;
strict ( 1 ); //Uncomment this line in order to enable strict mode 2. The strict mode has two variants (strict(1), strict(2)) and is prerequisite to be future proof regarding syntax and to be able to release your BO.

define behavior for ZINF_CUSTOM_HKNT_VALUATION alias valuation

//late numbering
lock master
authorization master ( instance )
//etag master <field_name>
{

  field ( readonly : update ) uuid;
  field ( readonly : update ) prev_date;
//  field ( readonly : update ) devir_belnr;
//  field ( readonly : update ) devir_buzei;
//  field ( readonly : update ) devir_budat;
  field ( readonly : update ) bukrs;
  field ( readonly : update ) budat;
  field ( readonly : update ) rtype;
  field ( readonly : update ) hkont;
  field ( readonly : update ) rldnr;


  //  create;
  //  update;
  //  delete;

  //  action accountingPopup parameter ZINF_ABSTRACT_HKNT_VALUATION result [1] $self;

  //  action accountingPopup parameter ZINF_ABSTRACT_HKNT_VALUATION result [0..*] $self;
  //  action reverse result [1] $self;

  //  association _save_entity { create; }

}


//define behavior for zdenek_ddl_008
//
////late numbering
//lock dependent by _save_entity
//authorization dependent by _save_entity
////etag master <field_name>
//{
//  create;
//  update;
//  delete;

//  association _save_entity { create; }
//}