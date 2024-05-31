CLASS zbp_inf_ddl_i_008 DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zinf_ddl_i_008.
  PUBLIC SECTION.


    CLASS-DATA: mt_deger            TYPE TABLE OF zinf_t003,
                mt_skat             TYPE TABLE OF I_GLAccountText,
                mt_hval_l           TYPE TABLE OF zinf_t008,
                mt_main_data        TYPE TABLE OF zinf_t008,
                ms_main_data        LIKE LINE OF mt_main_data,
                mt_account_balances TYPE zinf_tt_bapi1028_4.

    CLASS-DATA mo_regulative_common TYPE REF TO zinf_regulative_common.

    TYPES: BEGIN OF mty_dmbtr,
             postingdate                 TYPE budat,
             glaccount                   TYPE belnr_d,
             ledgergllineitem            TYPE char6,
             amountincompanycodecurrency TYPE zinf_e_dmbtr,
           END OF mty_dmbtr.
*
    CLASS-DATA: mt_dmbtr TYPE TABLE OF mty_dmbtr.

    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider .

    CLASS-METHODS:
      get_data IMPORTING VALUE(iv_bukrs) TYPE bukrs
                         VALUE(iv_rldnr) TYPE zinf_t003-rldnr,

      process_data  IMPORTING VALUE(iv_bukrs) TYPE bukrs
                              VALUE(iv_gjahr) TYPE gjahr
                              VALUE(iv_rldnr) TYPE zinf_t003-rldnr
                              VALUE(iv_budat) TYPE budat
                              VALUE(iv_rtype) TYPE zinf_e_rate_type,


      set_data IMPORTING io_request  TYPE REF TO if_rap_query_request OPTIONAL
                         io_response TYPE REF TO if_rap_query_response OPTIONAL
               RAISING   cx_rap_query_prov_not_impl
                         cx_rap_query_provider,

      call_bapi IMPORTING VALUE(iv_hkont)   TYPE hkont
                          VALUE(iv_fmonth)  TYPE monat
                          VALUE(iv_fyear)   TYPE gjahr
                          VALUE(iv_rldnr)   TYPE zinf_e_rldnr
                          VALUE(iv_bukrs)   TYPE bukrs
                EXPORTING VALUE(ev_balance) TYPE zinf_e_dmbtr.
