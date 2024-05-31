managed implementation in class zbp_inf_i_stk_to_mnl unique;
strict ( 1 );

define behavior for ZINF_I_STK_TO_MNL alias stk_mnl
persistent table zinf_t013
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

//  action ( features : instance ) setActive result [1] $self;
  determination changeField on save { field StockTransSpeedD; create;}
  validation validateField on save {  create; field StockTransSpeed; }

  field ( readonly : update ) BUKRS;
  field ( readonly : update ) RLDNR;
  field ( readonly : update ) RSPMON;
  field ( readonly : update ) ACCTYPE;
  field ( readonly : update ) CSPMON;

  field ( readonly ) StockTransSpeed;
  field ( readonly ) StockTransSpeedM;

  mapping for zinf_t013
    {
      Bukrs            = bukrs;
      Rldnr            = rldnr;
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