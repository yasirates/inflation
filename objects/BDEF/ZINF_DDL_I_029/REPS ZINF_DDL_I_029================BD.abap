managed implementation in class zbp_inf_ddl_i_029 unique;
//strict ( 2 );

define behavior for zinf_ddl_i_029 //alias <alias_name>
persistent table zinf_t029
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly ) Uuid;


  mapping for zinf_t029
    {
      Uuid             = uuid;
      Bukrs            = bukrs;
      Anln1            = anln1;
      Anln2            = anln2;
      Rldnr            = rldnr;
      ValuationDate    = val_date;
      DepreciationArea = depreciation_area;
      Bldat            = bldat;
      Budat            = budat;
      Rfdat            = rfdat;
      Bktxt            = bktxt;
      Shkzg            = shkzg;
      PurchaseYear     = purchase_year;
      RevalAmount      = reval_amount;
      DepreAmount      = depre_amount;
      Waers            = waers;
      Zuonr            = zuonr;
      Sgtxt            = sgtxt;
      EndexDate        = endex_date;
    }
}