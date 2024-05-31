CLASS lhc_valuation DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR valuation RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ valuation RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK valuation.

    METHODS accounting FOR MODIFY
      IMPORTING keys FOR ACTION valuation~accounting.

    METHODS reverse FOR MODIFY
      IMPORTING keys FOR ACTION valuation~reverse.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE valuation.

ENDCLASS.

CLASS lhc_valuation IMPLEMENTATION.

  METHOD get_instance_authorizations.
*    SELECT * FROM zinf_t008 INTO TABLE @DATA(lt_008).
  ENDMETHOD.

  METHOD read.
*    SELECT * FROM zinf_t008 INTO TABLE @DATA(lt_008).
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD accounting.

  ENDMETHOD.

  METHOD reverse.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZINF_I_HKNT_VALUATION DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZINF_I_HKNT_VALUATION IMPLEMENTATION.

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