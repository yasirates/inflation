CLASS lhc_endex DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
    INTERFACES if_rap_query_request.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR endex RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ endex RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK endex.

ENDCLASS.

CLASS lhc_endex IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    IF 1 = 1.

    ENDIF.
  ENDMETHOD.

  METHOD if_rap_query_request~get_parameters.
    IF 1 = 1.

    ENDIF.
  ENDMETHOD.
  METHOD get_instance_authorizations.
    SELECT * FROM zinf_t012 INTO TABLE @DATA(lt_012).
*    READ ENTITIES OF zinf_i_gelir_tablo_endex IN LOCAL MODE
*                ENTITY endex
*                FIELDS ( Bukrs )
*                WITH CORRESPONDING #( keys )
*                RESULT DATA(lt_xx)
*                FAILED failed.


*    result = VALUE #( FOR ls_xx IN lt_xx
*                        ( %key = ls_xx-%key
*                        %action-accounting = COND #( WHEN ls_xx-Bukrs IS NOT INITIAL
*                                                     THEN if_abap_behv=>fc-o-disabled
*                                                     ELSE if_abap_behv=>fc-o-enabled ) ) ).

  ENDMETHOD.

  METHOD read.
    SELECT * FROM zinf_t012 INTO TABLE @DATA(lt_012).
  ENDMETHOD.

  METHOD lock.
    SELECT * FROM zinf_t012 INTO TABLE @DATA(lt_t012).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZINF_I_GELIR_TABLO_ENDEX DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZINF_I_GELIR_TABLO_ENDEX IMPLEMENTATION.

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