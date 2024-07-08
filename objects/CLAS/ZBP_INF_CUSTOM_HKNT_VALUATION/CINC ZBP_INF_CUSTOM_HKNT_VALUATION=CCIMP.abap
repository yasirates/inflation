CLASS lhc_valuation DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR valuation RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ valuation RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK valuation.

*    METHODS accountingpopup FOR MODIFY
*      IMPORTING keys FOR ACTION valuation~accountingpopup RESULT result.

*    METHODS reverse FOR MODIFY
*      IMPORTING keys FOR ACTION valuation~reverse RESULT result.

*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE valuation.

*    METHODS rba_save_entity FOR READ
*      IMPORTING keys_rba FOR READ valuation\_save_entity FULL result_requested RESULT result LINK association_links.

*    METHODS cba_save_entity FOR MODIFY
*      IMPORTING entities_cba FOR CREATE valuation\_save_entity.

*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE valuation.

*    METHODS read FOR READ
*      IMPORTING keys FOR READ valuation RESULT result.

*    METHODS prepare_data IMPORTING VALUE(it_data)  TYPE zinf_tt_008
*                                   VALUE(iv_budat) TYPE budat
*                         RETURNING VALUE(rs_data)  TYPE zjejournal_entry_bulk_ledger_c.

*    METHODS journal_entry_create IMPORTING VALUE(is_request) TYPE zjejournal_entry_bulk_ledger_c.
ENDCLASS.

CLASS lhc_valuation IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
*    DATA t008 LIKE result.
*
*    CHECK keys IS NOT INITIAL.
*    SELECT  *
*       FROM zinf_t008
*        FOR ALL ENTRIES IN @keys
*       WHERE uuid       EQ @keys-uuid
*      INTO CORRESPONDING FIELDS OF TABLE @t008.
*
*
*    LOOP AT t008 INTO DATA(ls_008).
*      INSERT ls_008 INTO TABLE result.
*    ENDLOOP.
  ENDMETHOD.
*
  METHOD lock.
  ENDMETHOD.

*  METHOD accountingPopup.
*    DATA: lt_main_data TYPE zinf_tt_008,
*          ls_main_data TYPE zinf_s008.
*
*    DATA(lt_keys) = keys.
*
*    READ ENTITIES OF zinf_custom_hknt_valuation
*     IN LOCAL MODE ENTITY valuation
*     ALL FIELDS WITH CORRESPONDING #( keys )
*     RESULT DATA(lt_main)
*     FAILED failed
*     REPORTED reported.
*
*    LOOP AT lt_main INTO DATA(ls_main).
*      ls_main_data = CORRESPONDING #( ls_main ).
*      APPEND ls_main_data TO lt_main_data. CLEAR ls_main_data.
*    ENDLOOP.
*
*    IF lt_main_data IS NOT INITIAL.
*      DATA(service_request) = me->prepare_data( it_data  = lt_main_data
*                                                iv_budat = VALUE #( lt_keys[ 1 ]-%key-budat OPTIONAL ) ).
*
*      IF service_request IS NOT INITIAL AND 1 = 2.
*        journal_entry_create( is_request = service_request ).
*      ENDIF.

*      DATA lt_root_entity TYPE TABLE FOR CREATE zinf_custom_hknt_valuation.
*      DATA lt_save_entity TYPE TABLE FOR CREATE zinf_custom_hknt_valuation\_save_entity.

*      LOOP AT lt_main_data ASSIGNING FIELD-SYMBOL(<lfs_main_data>).


*        CLEAR lt_save_entity.
*        lt_save_entity = VALUE #( (
*                                  uuid        = <lfs_main_data>-uuid
*                                  bukrs       = <lfs_main_data>-bukrs
*                                  budat       = <lfs_main_data>-budat
*                                  hkont       = <lfs_main_data>-hkont
*                                  rldnr       = <lfs_main_data>-rldnr
*                                  devir_budat = <lfs_main_data>-devir_budat
*                                  devir_belnr = <lfs_main_data>-devir_belnr
*                                  devir_buzei = <lfs_main_data>-devir_buzei
*                                  rtype       = <lfs_main_data>-rtype
*                                  %target     = VALUE #( (
*                                                     %cid     = 'create'
*                                                     belnr    = '321'
*                                                     gjahr    = '2024'
*                                                     %control = VALUE #(
**                                                                         uuid       = if_abap_behv=>mk-on
**                                                                         bukrs      = if_abap_behv=>mk-on
**                                                                         budat      = if_abap_behv=>mk-on
**                                                                         rtype      = if_abap_behv=>mk-on
**                                                                         hkont      = if_abap_behv=>mk-on
**                                                                         rldnr      = if_abap_behv=>mk-on
**                                                                         DevirBudat = if_abap_behv=>mk-on
**                                                                         DevirBelnr = if_abap_behv=>mk-on
**                                                                         DevirBuzei = if_abap_behv=>mk-on
*                                                                         belnr = if_abap_behv=>mk-on
*                                                                         gjahr = if_abap_behv=>mk-on
*                                                                         ) ) )
*                                  ) ).


*        READ ENTITIES OF zinf_custom_hknt_valuation
*            ENTITY valuation
*            BY \_save_entity
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT DATA(lt_rba)
*            FAILED failed
*            REPORTED reported.

*        MODIFY ENTITIES OF zinf_custom_hknt_valuation
*         IN LOCAL MODE ENTITY valuation "CREATE FROM lt_root_entity
*                 CREATE BY \_save_entity FROM lt_save_entity
**                 AUTO FILL CID
**                 FIELDS (  belnr gjahr )
**                 WITH VALUE #( ( uuid    = <lfs_main_data>-uuid
**                                 %target = VALUE #( ( belnr = '321' gjahr = '321' ) ) ) )
*                 MAPPED DATA(lt_xmapped)
*                 FAILED DATA(lt_xfailed)
*                 REPORTED DATA(lt_xreported).


*        MODIFY ENTITIES OF  zinf_custom_hknt_valuation ENTITY valuation
*        CREATE BY \_save_entity
*        FROM VALUE #( ( uuid        = <lfs_main_data>-uuid
*                        bukrs       = <lfs_main_data>-bukrs
*                        budat       = <lfs_main_data>-budat
*                        hkont       = <lfs_main_data>-hkont
*                        rldnr       = <lfs_main_data>-rldnr
*                        devir_budat = <lfs_main_data>-devir_budat
*                        devir_belnr = <lfs_main_data>-devir_belnr
*                        devir_buzei = <lfs_main_data>-devir_buzei
*                        rtype       = <lfs_main_data>-rtype
*                        %target     = VALUE #( (
*                                         %cid       = 'create'
*                                         uuid       = <lfs_main_data>-uuid
*                                         bukrs      = <lfs_main_data>-bukrs
*                                         budat      = <lfs_main_data>-budat
*                                         hkont      = <lfs_main_data>-hkont
*                                         rldnr      = <lfs_main_data>-rldnr
*                                         devirbudat = <lfs_main_data>-devir_budat
*                                         devirbelnr = <lfs_main_data>-devir_belnr
*                                         devirbuzei = <lfs_main_data>-devir_buzei
*                                         rtype      = <lfs_main_data>-rtype
*                                         belnr      = '321'
*                                         gjahr      = '2024'
*                                         %control   = VALUE #(
**                                                                         uuid       = if_abap_behv=>mk-on
**                                                                         bukrs      = if_abap_behv=>mk-on
**                                                                         budat      = if_abap_behv=>mk-on
**                                                                         rtype      = if_abap_behv=>mk-on
**                                                                         hkont      = if_abap_behv=>mk-on
**                                                                         rldnr      = if_abap_behv=>mk-on
**                                                                         DevirBudat = if_abap_behv=>mk-on
**                                                                         DevirBelnr = if_abap_behv=>mk-on
**                                                                         DevirBuzei = if_abap_behv=>mk-on
*                                                             belnr = if_abap_behv=>mk-on
*                                                             gjahr = if_abap_behv=>mk-on )
*                                         ) )
*
*                      ) )
*                 MAPPED DATA(lt_xmapped)
*                 FAILED DATA(lt_xfailed)
*                 REPORTED DATA(lt_xreported).
*
*        IF lt_xfailed IS INITIAL.
*
*        ENDIF.

*      ENDLOOP.
*    ENDIF.

*    APPEND VALUE #( %tky = <lfs_mainxx>-%key
*                    %msg = new_message( id       = 'ZINF'
*                                        number   = '001'
*                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-valuation.


*
*                      %msg           = new_message_with_text(
*                      severity = if_abap_behv_message=>severity-error
*                      text     = 'Deneme'
*                      )
*                      %element-Budat = if_abap_behv=>mk-on ) TO reported-valuation.

*  ENDMETHOD.

*  METHOD reverse.
*  ENDMETHOD.

*  METHOD prepare_data.
*    DATA: lt_header       TYPE zjejournal_entry_create_re_tab,
*          ls_header       TYPE zjejournal_entry_create_reques,
*          lt_item         TYPE zjejournal_entry_create_r_tab1,
*          ls_item         TYPE zjejournal_entry_create_reque3,
*          lv_currencyCode TYPE I_CompanyCode-Currency.
*
*    LOOP AT it_data INTO DATA(ls_data).
*      IF lv_currencyCode IS INITIAL.
*        SELECT SINGLE Currency
*          FROM I_CompanyCode
*         WHERE CompanyCode EQ @ls_data-bukrs
*          INTO @lv_currencyCode.
*      ENDIF.
*      ls_header-journal_entry = VALUE #( company_code              = ls_data-bukrs
*                                         document_date             = ls_data-budat
*                                         accounting_document       = ls_data-belnr
*                                         business_transaction_type = 'RFBU'
*                                         posting_date              = ls_data-budat
*                                         posting_fiscal_period     = iv_budat+4(2)
*                                       ).
*
*
*      ls_item-glaccount-content                            = ls_data-correct_hkont_bs.
*      ls_item-amount_in_transaction_currency-content       = ls_data-correct_balance.
*      ls_item-amount_in_transaction_currency-currency_code = lv_currencyCode.
*      ls_item-amount_in_company_code_currenc-content       = ls_data-correct_balance.
*      ls_item-amount_in_company_code_currenc-currency_code = lv_currencyCode.
*      ls_item-document_item_text                           = 'ENFLASYON-DÜZELTME'.
*      "ls_item-account_assignment
*      ls_item-debit_credit_code  = COND #( WHEN ls_data-correct_balance LT 0 THEN 'H'
*                                           WHEN ls_data-correct_balance GE 0 THEN 'S').
*
*
*      APPEND ls_item TO ls_header-journal_entry-item. CLEAR ls_item.
*
*      ls_item-glaccount-content                            = ls_data-correct_hkont_pl.
*      ls_item-amount_in_transaction_currency-content       = ls_data-correct_balance.
*      ls_item-amount_in_transaction_currency-currency_code = lv_currencyCode.
*      ls_item-amount_in_company_code_currenc-content       = ls_data-correct_balance.
*      ls_item-amount_in_company_code_currenc-currency_code = lv_currencyCode.
*      ls_item-document_item_text                           = 'ENFLASYON-DÜZELTME'.
*      "ls_item-account_assignment
*      ls_item-debit_credit_code  = COND #( WHEN ls_data-correct_balance LT 0 THEN 'H'
*                                           WHEN ls_data-correct_balance GE 0 THEN 'S').
*
*      APPEND ls_item TO ls_header-journal_entry-item. CLEAR ls_item.
*      APPEND ls_header TO lt_header. CLEAR ls_header.
*
*    ENDLOOP.
*
*    rs_data-journal_entry_bulk_ledger_crea-journal_entry_create_request = lt_header.
*  ENDMETHOD.

*  METHOD journal_entry_create.
*    DATA lo_journal_entry TYPE REF TO zjeco_journal_entry_bulk_ledge.
*
*    TRY.
*
*        lo_journal_entry = NEW #( ).
*        lo_journal_entry->journal_entry_bulk_ledger_crea( input = is_request ).
*
*      CATCH  cx_ai_system_fault INTO DATA(cx_system_fault).
*
*    ENDTRY.
*
*  ENDMETHOD.

*  METHOD update.
*    DATA lt_008 TYPE TABLE OF zinf_t008.
*    lt_008 = CORRESPONDING #( entities ).
*    MODIFY zinf_t008 FROM TABLE @lt_008.
*  ENDMETHOD.

*  METHOD rba_Save_entity.
*    DATA t008 LIKE result.
*
*    CHECK keys_rba IS NOT INITIAL.
*    SELECT  *
*       FROM zinf_t008
*        FOR ALL ENTRIES IN @keys_rba
*       WHERE uuid       EQ @keys_rba-uuid
*      INTO CORRESPONDING FIELDS OF TABLE @t008.
*
*
*    LOOP AT t008 INTO DATA(ls_008).
*      INSERT ls_008 INTO TABLE result.
**      reported-zdenek_ddl_008 = VALUE #( ( %cid    = 'read'
**                                           uuid    = ls_008-Uuid
**                                           %key    = CORRESPONDING #( ls_008 )
**                                           %update = if_abap_behv=>mk-on
**                                       ) ).
*    ENDLOOP.
*  ENDMETHOD.

*  METHOD cba_Save_entity.
*
**    DATA(ls_val) = VALUE #( entities_cba[ 1 ] OPTIONAL ).
*
*    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<lfs_cba>).
*      LOOP AT <lfs_cba>-%target ASSIGNING FIELD-SYMBOL(<lfs_target>).
*        mapped-valuation      = VALUE #( (
*                                         %cid = <lfs_target>-%cid
*                                         %key = CORRESPONDING #( <lfs_target>-%key MAPPING devir_belnr = DevirBelnr
*                                                                                           devir_budat = DevirBudat
*                                                                                           devir_buzei = DevirBuzei ) ) ).
*        mapped-zdenek_ddl_008 = VALUE #( (
*                                         %cid = <lfs_target>-%cid
*                                         %key = CORRESPONDING #( <lfs_target>-%key ) ) ).
*      ENDLOOP.
*    ENDLOOP.
*
*  ENDMETHOD.

*  METHOD create.
*  ENDMETHOD.

*  METHOD read.
*  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZINF_CUSTOM_HKNT_VALUATION DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZINF_CUSTOM_HKNT_VALUATION IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.