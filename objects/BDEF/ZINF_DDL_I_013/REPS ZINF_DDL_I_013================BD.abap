managed implementation in class zbp_inf_ddl_i_013 unique;
//strict ( 2 );

define behavior for ZINF_DDL_I_013 //alias <alias_name>
persistent table zinf_t013
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  mapping for zinf_t013
    {
      Bukrs            = bukrs;
      Rspmon           = rspmon;
      AccType          = acc_type;
      Cspmon           = cspmon;
      Waers            = waers;
      StockBalance     = stock_balance;
      CostBalance      = cost_balance;
      StockTransSpeed  = stock_trans_speed;
      StockTransSpeedD = stock_trans_speed_d;
      StockTransSpeedM = stock_trans_speed_m;
    }
}