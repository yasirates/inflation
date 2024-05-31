CLASS lhc_Valuation DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Valuation RESULT result.

    METHODS accountingPopup FOR MODIFY
      IMPORTING keys FOR ACTION Valuation~accountingPopup RESULT result.

    METHODS reversePopup FOR MODIFY
      IMPORTING keys FOR ACTION Valuation~reversePopup RESULT result.

ENDCLASS.

CLASS lhc_Valuation IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD accountingPopup.
  ENDMETHOD.

  METHOD reversePopup.
  ENDMETHOD.

ENDCLASS.