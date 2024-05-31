managed implementation in class zbp_inf_ddl_i_015 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_015 //alias <alias_name>
persistent table zinf_t015
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t015
    {
      Bukrs        = bukrs;
      Afabe        = afabe;
      Blart        = blart;
      AssetTrtypG  = assettrtyp_g;
      AssetTrtypY  = assettrtyp_y;
      LedgerGroup  = ledger_group;
      AccPrinciple = acc_principle;
    }
}