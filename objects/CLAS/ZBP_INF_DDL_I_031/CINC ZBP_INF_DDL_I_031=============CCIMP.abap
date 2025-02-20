CLASS lhc_ZINF_DDL_I_031 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zinf_ddl_i_031 RESULT result.

ENDCLASS.

CLASS lhc_ZINF_DDL_I_031 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.