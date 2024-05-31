CLASS lhc_stk_mnl DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR stk_mnl RESULT result.

*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR stk_mnl RESULT result.

*    METHODS setactive FOR MODIFY
*      IMPORTING keys FOR ACTION stk_mnl~setactive RESULT result.

    METHODS changefield FOR DETERMINE ON SAVE
      IMPORTING keys FOR stk_mnl~changefield.

    METHODS validatefield FOR VALIDATE ON SAVE
      IMPORTING keys FOR stk_mnl~validatefield.

ENDCLASS.

CLASS lhc_stk_mnl IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD get_instance_features.
*  ENDMETHOD.

  METHOD changeField.
    DATA lv_rspmon TYPE datum.
    DATA lv_cspmon TYPE datum.
    DATA lv_stock_trans_speed TYPE zinf_e_stck_trans_speed.
    DATA lv_stock_trans_speedm TYPE fins_fyearperiod.
*
    READ ENTITIES OF zinf_i_stk_to_mnl IN LOCAL MODE
           ENTITY stk_mnl
           FIELDS ( StockTransSpeedD ) WITH CORRESPONDING #( keys )
           RESULT DATA(members).
*
    LOOP AT members INTO DATA(member).
      CLEAR : lv_stock_trans_speed , lv_stock_trans_speedm, lv_rspmon , lv_cspmon.

      IF member-StockTransSpeedD IS NOT INITIAL.

        CHECK member-Rspmon IS NOT INITIAL AND member-Cspmon IS NOT INITIAL.
        lv_rspmon = member-Rspmon(4) && member-Rspmon+5(2) && '01'.
        zinf_regulative_common=>rp_last_day_of_months(
          EXPORTING
            day_in            = lv_rspmon
          IMPORTING
            last_day_of_month = lv_rspmon
          EXCEPTIONS
            day_in_no_date    = 1
            OTHERS            = 2
        ).

        lv_cspmon = member-Cspmon(4) && member-Cspmon+5(2) && '01'.
        zinf_regulative_common=>rp_last_day_of_months(
          EXPORTING
            day_in            = lv_cspmon
          IMPORTING
            last_day_of_month = lv_cspmon
          EXCEPTIONS
            day_in_no_date    = 1
            OTHERS            = 2
        ).

        lv_stock_trans_speed = ( lv_rspmon - lv_cspmon ) / member-StockTransSpeedD.


        DATA lv_date TYPE datum.
        lv_date = lv_rspmon - member-StockTransSpeedD.
         lv_stock_trans_speedm = lv_date(4) && '0' && lv_date+4(2).

        MODIFY ENTITIES OF zinf_i_stk_to_mnl IN LOCAL MODE
                ENTITY stk_mnl
                    UPDATE
                    FIELDS ( StockTransSpeed  )
                    WITH VALUE #( ( %tky             = member-%tky
                                    StockTransSpeed  = lv_stock_trans_speed ) ).

        MODIFY ENTITIES OF zinf_i_stk_to_mnl IN LOCAL MODE
                ENTITY stk_mnl
                UPDATE
                FIELDS (  StockTransSpeedM )
                WITH VALUE #( ( %tky             = member-%tky
                                StockTransSpeedM = lv_stock_trans_speedm ) ).

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateField.

*    READ ENTITIES OF zinf_i_stk_to_mnl IN LOCAL MODE
*         ENTITY stk_mnl
*         FIELDS ( StockTransSpeed ) WITH CORRESPONDING #( keys )
*         RESULT DATA(members).
*
*
*    LOOP AT members INTO DATA(member).
**      APPEND VALUE #(  %tky = member-%tky ) TO failed-stk_mnl.
*      MODIFY ENTITIES OF zinf_i_stk_to_mnl IN LOCAL MODE
*           ENTITY stk_mnl
*           UPDATE
*           FIELDS ( StockTransSpeed )
*           WITH VALUE #( ( %tky             = member-%tky
*                           StockTransSpeedM = 555 ) ).
*    ENDLOOP.

  ENDMETHOD.

ENDCLASS.