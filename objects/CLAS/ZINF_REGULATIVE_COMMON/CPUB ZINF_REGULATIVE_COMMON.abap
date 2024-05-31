CLASS zinf_regulative_common DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF mty_xml_node,
             node_type  TYPE string,
             prefix     TYPE string,
             name       TYPE string,
             nsuri      TYPE string,
             value_type TYPE string,
             value      TYPE string,
           END OF mty_xml_node,
           mty_xml_nodes TYPE TABLE OF mty_xml_node WITH EMPTY KEY,
           mty_hash      TYPE c LENGTH 32.


    TYPES : BEGIN OF mty_bapi1028_4,
              comp_code       TYPE bukrs,
              gl_account      TYPE hkont,
              fisc_year       TYPE gjahr,
              fis_period      TYPE monat,
              debits_per      TYPE bapicurr_d,
              credit_per      TYPE bapicurr_d,
              per_sales       TYPE bapicurr_d,
              balance         TYPE bapicurr_d,
              currency        TYPE waers,
              currency_iso    TYPE char3,
              debits_per_long TYPE bapicurext31,
              credit_per_long TYPE bapicurext31,
              per_sales_long  TYPE bapicurext31,
              balance_long    TYPE bapicurext31,
            END OF mty_bapi1028_4.

    DATA mt_account_balances TYPE TABLE OF mty_bapi1028_4.

    CLASS-METHODS :
      rp_last_day_of_months IMPORTING  VALUE(day_in)            TYPE datum
                            EXPORTING  VALUE(last_day_of_month) TYPE datum
                            EXCEPTIONS day_in_no_date,

      month_plus_determine IMPORTING VALUE(months)  TYPE char10
                                     VALUE(olddate) TYPE datum
                           RETURNING VALUE(newdate) TYPE datum,

      get_methods IMPORTING VALUE(i_datuv)  TYPE datum
                            VALUE(i_datub)  TYPE datum
                  RETURNING VALUE(et_dates) TYPE zinf_tt_scscp_period_str.

    CLASS-METHODS parse_xml
      IMPORTING
        iv_xml_string  TYPE string
      RETURNING
        VALUE(rt_data) TYPE mty_xml_nodes.
    CLASS-METHODS get_node_type
      IMPORTING
        node_type_int           TYPE i
      RETURNING
        VALUE(node_type_string) TYPE string.
    CLASS-METHODS get_value_type
      IMPORTING
        value_type_int           TYPE i
      RETURNING
        VALUE(value_type_string) TYPE string.
    CLASS-METHODS unzip_file_single
      IMPORTING
        !iv_zipped_file_str  TYPE string OPTIONAL
        !iv_zipped_file_xstr TYPE xstring OPTIONAL
      EXPORTING
        ev_output_data_str   TYPE string
        ev_output_data_xstr  TYPE xstring.
    CLASS-METHODS calculate_hash_for_raw
      IMPORTING
        !iv_raw_data              TYPE xstring
      RETURNING
        VALUE(rv_calculated_hash) TYPE string.
    CLASS-METHODS get_api_url
      RETURNING
        VALUE(rv_url) TYPE string.
    CLASS-METHODS get_ui_url
      RETURNING
        VALUE(rv_url) TYPE string.
