CLASS zcl_inf_fixed_asset_create DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-DATA: mt_users        TYPE TABLE OF zinf_users.


    DATA  mv_service_data TYPE string.
    DATA  mv_cookies TYPE string.

    TYPES : BEGIN OF mty_service_response_json,
              code            TYPE string,
              numericSeverity TYPE char10,
              longtextUrl     TYPE string,
            END OF mty_service_response_json.

    DATA mt_service_res_json_data TYPE TABLE OF  mty_service_response_json.

    TYPES:
      BEGIN OF cookie,
        name    TYPE string,
        value   TYPE string,
        domain  TYPE string,
        path    TYPE string,
        secure  TYPE int4,
        expires TYPE string,
      END OF cookie .
    TYPES:
      cookies          TYPE STANDARD TABLE OF cookie WITH NON-UNIQUE KEY !name !path .

    DATA mt_cookies TYPE cookies.

    TYPES:
      BEGIN OF mty_success_response,
        belnr TYPE belnr_d,
      END OF mty_success_response.
    DATA ms_success_response TYPE mty_success_response.

    METHODS :
      get_service_info IMPORTING VALUE(iv_service_id) TYPE zinf_users-service_id,
      get_csrf_token  IMPORTING VALUE(request)  TYPE REF TO if_web_http_request
                                VALUE(response) TYPE REF TO if_web_http_response
                      RETURNING VALUE(rv_token) TYPE string,
      json_deserialize IMPORTING VALUE(iv_json_data) TYPE string
                       EXPORTING VALUE(rv_json_data) TYPE table.

    INTERFACES if_http_service_extension .