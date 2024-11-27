
CLASS lhc_t003 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR t003 RESULT result.

*    METHODS check_value FOR DETERMINE ON SAVE
*      IMPORTING keys FOR t003~check_value.

*    METHODS modify_value FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR t003~modify_value.

*    METHODS validatefields FOR VALIDATE ON SAVE
*      IMPORTING keys FOR t003~validatefields.

ENDCLASS.

CLASS lhc_t003 IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.

*  METHOD validateFields.
*
*    READ ENTITIES OF zinf_ddl_i_003 IN LOCAL MODE ENTITY t003
*      FIELDS (  Rldnr )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(entity_datas).
*
*
*    LOOP AT entity_datas INTO DATA(entity_data).
*      entity_data-rldnr = to_upper( entity_data-rldnr ).
*
*      MODIFY ENTITIES OF zinf_ddl_i_003 IN LOCAL MODE
*                 ENTITY t003
*                 UPDATE FIELDS ( rldnr )
*                 WITH VALUE #( ( %key  = entity_data-%key
*                                 blart = 'EF' ) ).
*    ENDLOOP.
*
*  ENDMETHOD.

*  METHOD check_value.
*    READ ENTITIES OF zinf_ddl_i_003 IN LOCAL MODE ENTITY t003
*      FIELDS ( Rldnr )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(entity_datas).
*
*    LOOP AT entity_datas INTO DATA(entity_data).
*      entity_data-rldnr = to_upper( entity_data-rldnr ).
*
*      MODIFY ENTITIES OF zinf_ddl_i_003 IN LOCAL MODE
*                 ENTITY t003
*                 UPDATE SET FIELDS WITH VALUE #( ( %key     = entity_data-%key
*                                                   rldnr    = to_upper( entity_data-rldnr )
*                                                   %control = VALUE #( rldnr = if_abap_behv=>mk-on ) )
*                                               ) REPORTED DATA(modify_report).
*
*
*    ENDLOOP.
*  ENDMETHOD.

*  METHOD modify_value.
*    READ ENTITIES OF zinf_ddl_i_003 IN LOCAL MODE ENTITY t003
*    FIELDS ( Rldnr )
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(entity_datas).
**
*    LOOP AT entity_datas INTO DATA(entity_data).
*      entity_data-rldnr = to_upper( entity_data-rldnr ).
*
*      MODIFY ENTITIES OF zinf_ddl_i_003 IN LOCAL MODE
*                 ENTITY t003
*                 UPDATE SET FIELDS WITH VALUE #( ( %key     = entity_data-%key
*                                                   rldnr    = to_upper( entity_data-rldnr )
*                                                   %control = VALUE #( blart = if_abap_behv=>mk-on ) )
*                                               ) REPORTED DATA(modify_report).
*
*
*    ENDLOOP.
*  ENDMETHOD.

ENDCLASS.