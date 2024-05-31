CLASS lhc_ZINF_DDL_I_025 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zinf_ddl_i_025 RESULT result.

ENDCLASS.

CLASS lhc_ZINF_DDL_I_025 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.