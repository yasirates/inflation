CLASS zcl_custom_fixed_asset DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider.
    INTERFACES if_rap_query_paging.
    TYPES: BEGIN OF ty_range_option,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE string,
             high   TYPE string,
           END OF ty_range_option,
           tt_range_option TYPE STANDARD TABLE OF ty_range_option WITH EMPTY KEY.

    DATA : mt_029            TYPE TABLE OF zinf_t029,
           mt_030            TYPE TABLE OF zinf_t030,
           mr_anln1          TYPE tt_range_option,
           mr_anln2          TYPE tt_range_option,
           mr_rldnr          TYPE tt_range_option,
           mr_depr_area      TYPE tt_range_option,
           mr_company_code   TYPE tt_range_option,
           mr_budat          TYPE tt_range_option,
           mr_valuation_date TYPE tt_Range_option,
           mr_index_date     TYPE tt_range_option,
           mt_out_data       TYPE TABLE OF zinf_custom_fixed_asset,
           ms_out_data       TYPE zinf_custom_fixed_asset,
           mt_index_table    TYPE TABLE OF zinf_t001.

    DATA mo_regulative_common TYPE REF TO zinf_regulative_common.

    METHODS :
      get_data,
      prepare_data,
      prepare_date,
      set_data IMPORTING io_request  TYPE REF TO if_rap_query_request OPTIONAL
                         io_response TYPE REF TO if_rap_query_response OPTIONAL
               RAISING   cx_rap_query_prov_not_impl
                         cx_rap_query_provider.

