CLASS zinf_trial_balance_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : BEGIN OF mty_service_data,
              CompanyCode                    TYPE bukrs,
              GLAccount                      TYPE hkont,
              DebitCreditCode                TYPE shkzg,
              FiscalYearPeriod               TYPE fins_fyearperiod,
              StartingBalanceAmtInCoCodeCrcy TYPE zinf_t005-dmbtr,
              DebitAmountInCoCodeCrcy        TYPE zinf_t005-dmbtr,
              DebitAmountInCoCodeCrcy_E      TYPE waers,
              CreditAmountInCoCodeCrcy       TYPE zinf_t005-dmbtr,
              CreditAmountInCoCodeCrcy_E     TYPE waers,
              EndingBalanceAmtInCoCodeCrcy   TYPE zinf_t005-dmbtr,
              EndingBalanceAmtInCoCodeCrcy_E TYPE waers,
            END OF mty_service_data.


    TYPES : BEGIN OF lty_reverse_hkont ,
              bukrs TYPE bukrs,
              hkont TYPE hkont,
              rldnr TYPE zinf_e_rldnr,
              statu TYPE zinf_e_statu,
            END  OF lty_reverse_hkont.


    DATA : mt_reverse_hkont TYPE TABLE OF lty_reverse_hkont.
    DATA : mt_deger TYPE TABLE OF  zinf_t003.
    CLASS-DATA: mt_service_data TYPE TABLE OF mty_service_data,
                mt_users        TYPE TABLE OF zinf_users.

    DATA lt_hkont TYPE TABLE OF hkont.
    CLASS-METHODS :
      trigger_trial_balance_service IMPORTING VALUE(iv_company_code) TYPE bukrs
                                              VALUE(iv_ledger)       TYPE char2
                                              VALUE(iv_gjahr)        TYPE gjahr OPTIONAL
                                              VALUE(iv_hkont)        TYPE hkont OPTIONAL
                                              VALUE(it_hkont)        LIKE lt_hkont OPTIONAL
                                              VALUE(iv_beg_spmon)    TYPE datum OPTIONAL
                                              VALUE(iv_end_spmon)    TYPE datum OPTIONAL
                                              VALUE(iv_begda)        TYPE datum OPTIONAL
                                              VALUE(iv_endda)        TYPE datum OPTIONAL
                                    RETURNING VALUE(rt_balance)      TYPE zinf_tt_bapi1028_4,


      trigger_trial_balance_service2 IMPORTING VALUE(iv_company_code) TYPE bukrs
                                               VALUE(iv_ledger)       TYPE char2
                                               VALUE(iv_gjahr)        TYPE gjahr OPTIONAL
                                               VALUE(iv_hkont)        TYPE hkont OPTIONAL
                                               VALUE(it_hkont)        LIKE lt_hkont OPTIONAL
                                               VALUE(iv_beg_spmon)    TYPE datum OPTIONAL
                                               VALUE(iv_end_spmon)    TYPE datum OPTIONAL
                                               VALUE(iv_begda)        TYPE datum OPTIONAL
                                               VALUE(iv_endda)        TYPE datum OPTIONAL
                                     RETURNING VALUE(rt_balance)      TYPE zinf_tt_bapi1028_4,


      reverse_trial_balance IMPORTING VALUE(iv_company_code) TYPE bukrs
                                      VALUE(iv_ledger)       TYPE char2
                                      VALUE(iv_gjahr)        TYPE gjahr OPTIONAL
                                      VALUE(iv_hkont)        TYPE hkont OPTIONAL
                                      VALUE(it_hkont)        LIKE lt_hkont OPTIONAL
                                      VALUE(it_deger)        LIKE mt_deger
                                      VALUE(iv_beg_spmon)    TYPE datum OPTIONAL
                                      VALUE(iv_end_spmon)    TYPE datum OPTIONAL
                                      VALUE(iv_begda)        TYPE datum OPTIONAL
                                      VALUE(iv_endda)        TYPE datum OPTIONAL
                            RETURNING VALUE(rt_balance)      TYPE zinf_tt_bapi1028_4,

      get_service_info.
