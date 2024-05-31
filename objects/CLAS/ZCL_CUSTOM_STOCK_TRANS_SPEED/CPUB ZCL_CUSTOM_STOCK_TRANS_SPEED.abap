CLASS zcl_custom_stock_trans_speed DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC INHERITING FROM cx_rap_query_provider
  .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider .

    DATA : mo_regulative_common TYPE REF TO zinf_regulative_common,
           mt_business_data     TYPE TABLE OF zinf_t013,
           mt_account_balance   TYPE zinf_tt_bapi1028_4,
           mt_stock_balance     TYPE zinf_tt_bapi1028_4,
           mt_display_data      TYPE TABLE OF zinf_custom_stock_trans_speed,
           mt_hkont             TYPE TABLE OF hkont,
           ms_hkont             LIKE LINE OF mt_hkont,
           mt_stock             TYPE TABLE OF zinf_t007,
           mt_cost              TYPE TABLE OF zinf_t009,
           mv_waers             TYPE I_CompanyCode-Currency,
           mt_005               TYPE TABLE OF zinf_t005.


    METHODS :
      get_data IMPORTING VALUE(iv_bukrs)    TYPE bukrs
                         VALUE(iv_rspmon)   TYPE fins_fyearperiod
                         VALUE(iv_cspmon)   TYPE fins_fyearperiod
                         VALUE(iv_rldnr)    TYPE zinf_e_rldnr
                         VALUE(io_request)  TYPE REF TO if_rap_query_request  OPTIONAL
                         VALUE(io_response) TYPE REF TO if_rap_query_response OPTIONAL,

      process_data IMPORTING VALUE(iv_bukrs)  TYPE bukrs
                             VALUE(iv_rldnr)  TYPE zinf_e_rldnr
                             VALUE(iv_rspmon) TYPE fins_fyearperiod
                             VALUE(iv_cspmon) TYPE fins_fyearperiod,

      set_data IMPORTING io_request  TYPE REF TO if_rap_query_request OPTIONAL
                         io_response TYPE REF TO if_rap_query_response OPTIONAL
               RAISING   cx_rap_query_prov_not_impl
                         cx_rap_query_provider,


      call_trial_balance IMPORTING VALUE(iv_hkont)   TYPE hkont OPTIONAL
                                   VALUE(iv_fmonth)  TYPE monat
                                   VALUE(iv_fyear)   TYPE gjahr
                                   VALUE(iv_rldnr)   TYPE zinf_e_rldnr
                                   VALUE(iv_bukrs)   TYPE bukrs
                                   VALUE(it_hkont)   LIKE mt_hkont OPTIONAL
                         EXPORTING VALUE(ev_balance) TYPE zinf_e_dmbtr
                                   VALUE(et_balance) TYPE zinf_tt_bapi1028_4.
