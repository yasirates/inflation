CLASS zcl_custom_hknt_valuation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider.
    INTERFACES if_rap_query_paging.


    CONSTANTS mc_begda TYPE datum VALUE '20000101'.


    TYPES tt_requested_elements TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA mt_requested_elements TYPE tt_requested_elements.

    TYPES : BEGIN OF mty_sum_balance ,
              " fisc_year  TYPE gjahr,
              gl_account TYPE hkont,
              balance    TYPE bapicurr_d,
            END OF mty_sum_balance.

    DATA : mt_sum_balance TYPE TABLE OF mty_sum_balance,
           ms_sum_balance TYPE mty_sum_balance.


    DATA: mt_deger            TYPE TABLE OF zinf_t003,
          ms_deger            LIKE LINE OF mt_deger,
          mt_skat             TYPE TABLE OF I_GLAccountText,
          mt_log              TYPE TABLE OF zinf_t008,
          mt_main_data        TYPE TABLE OF zinf_t008,
          ms_main_data        LIKE LINE OF mt_main_data,
          mt_account_balances TYPE zinf_tt_bapi1028_4,
          mt_t026             TYPE TABLE OF zinf_t026. "Bakiye Geçiş Tablosu


    DATA mo_regulative_common TYPE REF TO zinf_regulative_common.

    TYPES: BEGIN OF mty_dmbtr,
             postingdate                 TYPE budat,
             glaccount                   TYPE belnr_d,
             ledgergllineitem            TYPE char6,
             amountincompanycodecurrency TYPE zinf_e_dmbtr,
           END OF mty_dmbtr.
*
    DATA: mt_dmbtr                 TYPE TABLE OF mty_dmbtr,
          mt_rate_table            TYPE TABLE OF zinf_t001,
          ms_rate_table1           LIKE LINE OF mt_rate_table,
          ms_rate_table2           LIKE LINE OF mt_rate_table,
          mt_hkont                 TYPE TABLE OF hkont,
          ms_hkont                 LIKE LINE OF mt_hkont,
          mt_trial_balance_account TYPE TABLE OF hkont,
          mt_range_hkont           TYPE RANGE OF hkont.

    DATA : mv_budat     TYPE budat,
           mv_prev_date TYPE zinf_e_previous_date.

    METHODS:

      init_data IMPORTING VALUE(iv_rtype)     TYPE zinf_e_rate_type
                          VALUE(iv_budat)     TYPE budat
                          VALUE(iv_prev_date) TYPE zinf_e_previous_date,

      get_data IMPORTING VALUE(iv_bukrs) TYPE bukrs
                         VALUE(iv_rldnr) TYPE zinf_t003-rldnr
                         VALUE(iv_idate) TYPE datum
                         VALUE(it_hkont) LIKE mt_range_hkont OPTIONAL,

      process_data  IMPORTING VALUE(iv_bukrs)     TYPE bukrs
                              VALUE(iv_gjahr)     TYPE gjahr
                              VALUE(iv_rldnr)     TYPE zinf_t003-rldnr
                              VALUE(iv_budat)     TYPE budat
                              VALUE(iv_prev_date) TYPE zinf_e_previous_date
                              VALUE(iv_rtype)     TYPE zinf_e_rate_type
                    RAISING
                              cx_uuid_error,

      set_data IMPORTING io_request  TYPE REF TO if_rap_query_request OPTIONAL
                         io_response TYPE REF TO if_rap_query_response OPTIONAL
               RAISING   cx_rap_query_prov_not_impl
                         cx_rap_query_provider,

      call_trial_balance IMPORTING VALUE(iv_hkont)       TYPE hkont OPTIONAL
                                   VALUE(iv_fmonth)      TYPE monat OPTIONAL
                                   VALUE(iv_fyear)       TYPE gjahr OPTIONAL
                                   VALUE(iv_rldnr)       TYPE zinf_e_rldnr
                                   VALUE(iv_bukrs)       TYPE bukrs
                                   VALUE(iv_begda)       TYPE datum OPTIONAL
                                   VALUE(iv_endda)       TYPE datum OPTIONAL
                                   VALUE(it_hkont)       LIKE mt_hkont OPTIONAL
                                   VALUE(iv_sum_flag)    TYPE flag
                                   VALUE(iv_index_date)  TYPE datum OPTIONAL
                         EXPORTING VALUE(ev_balance)     TYPE zinf_e_dmbtr
                                   VALUE(et_balance)     TYPE zinf_tt_bapi1028_4
                                   VALUE(et_sum_balance) LIKE mt_sum_balance,

      account_decomposition IMPORTING VALUE(it_hkont) LIKE mt_hkont
                            RETURNING VALUE(rt_hkont) LIKE mt_hkont,

      fill_trial_balance IMPORTING VALUE(it_sum_balance)        LIKE mt_sum_balance OPTIONAL
                                   VALUE(it_balance)            TYPE zinf_tt_bapi1028_4 OPTIONAL
                                   VALUE(iv_prev_date)          TYPE zinf_e_previous_date OPTIONAL
                                   VALUE(iv_fmonth)             TYPE monat OPTIONAL
                                   VALUE(iv_fyear)              TYPE gjahr OPTIONAL
                                   VALUE(iv_rldnr)              TYPE zinf_e_rldnr OPTIONAL
                                   VALUE(iv_budat)              TYPE budat OPTIONAL
                                   VALUE(iv_bukrs)              TYPE bukrs OPTIONAL
                                   VALUE(iv_begda)              TYPE datum OPTIONAL
                                   VALUE(iv_endda)              TYPE datum OPTIONAL
                                   VALUE(iv_rtype)              TYPE zinf_e_rate_type
                                   VALUE(is_deger)              LIKE ms_deger OPTIONAL
                                   VALUE(iv_cancel_old_balance) TYPE flag OPTIONAL ,

      cumulative_data IMPORTING VALUE(is_deger) LIKE ms_deger OPTIONAL
                                VALUE(iv_budat) TYPE budat OPTIONAL
                                VALUE(iv_edate) TYPE datum OPTIONAL.
