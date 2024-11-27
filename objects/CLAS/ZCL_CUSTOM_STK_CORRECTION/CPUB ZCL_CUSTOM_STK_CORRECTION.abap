CLASS zcl_custom_stk_correction DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider .

    DATA : mv_company_code     TYPE bukrs,
           mv_period           TYPE fins_fyearperiod,
           mv_rldnr            TYPE zinf_e_rldnr,
           mv_rtype            TYPE zinf_e_rate_type,
           mv_avarage_method   TYPE char6,
           mv_stock_hkont      TYPE zinf_e_saknr,
           mt_stock            TYPE TABLE OF zinf_t007,
           mr_stock_hkont      TYPE RANGE OF zinf_e_saknr,
           ms_bank_report      TYPE zinf_t001,
           ms_bank_trans       TYPE zinf_t001,
           ms_bank_bort        TYPE zinf_t001,
           mt_stspe            TYPE TABLE OF zinf_t013,
           mt_corr_log         TYPE TABLE OF zinf_t002,
           mt_log              TYPE TABLE OF zinf_t002,
           ms_log              TYPE zinf_t002,
           mt_acc_val          TYPE TABLE OF ddcds_customer_domain_value_t,
           gv_date1            TYPE datum,
           mt_skat             TYPE TABLE OF I_GLAccountText,
           mt_hkont            TYPE TABLE OF hkont,
           ms_hkont            LIKE LINE OF mt_hkont,
           mt_account_balances TYPE zinf_tt_bapi1028_4,
           mt_t001             TYPE TABLE OF zinf_t001.

    DATA mo_regulative_common TYPE REF TO zinf_regulative_common.
    METHODS:

      get_filter_parameter IMPORTING VALUE(io_request) TYPE REF TO if_rap_query_request,

      get_data,

      process_data,

      set_data IMPORTING io_request  TYPE REF TO if_rap_query_request OPTIONAL
                         io_response TYPE REF TO if_rap_query_response OPTIONAL
               RAISING   cx_rap_query_prov_not_impl
                         cx_rap_query_provider.
