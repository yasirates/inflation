CLASS lhc_ZINF_CUSTOM_REVERSE_HKONT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zinf_custom_reverse_hkont RESULT result.

*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE zinf_custom_reverse_hkont.

*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE zinf_custom_reverse_hkont.

*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE zinf_custom_reverse_hkont.

    METHODS read FOR READ
      IMPORTING keys FOR READ zinf_custom_reverse_hkont RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zinf_custom_reverse_hkont.

ENDCLASS.

CLASS lhc_ZINF_CUSTOM_REVERSE_HKONT IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD create.
*  ENDMETHOD.
*
*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZINF_CUSTOM_REVERSE_HKONT DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZINF_CUSTOM_REVERSE_HKONT IMPLEMENTATION.

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