  METHOD get_methods.
*    TYPES : tstr_year     TYPE numc4.
*
*    TYPES : BEGIN OF lty_genseg ,
*              begin_date TYPE datum,
*              begin_time TYPE uzeit,
*              begin_tstp TYPE p LENGTH 15 DECIMALS 0,
*              end_date   TYPE datum,
*              end_time   TYPE uzeit,
*              end_tstp   TYPE  p LENGTH 15 DECIMALS 0,
*              breaks     TYPE p LENGTH 11 DECIMALS 0,
*              loadfactor TYPE p LENGTH 6 DECIMALS 3,
*              has_extent TYPE c LENGTH 1,
*              is_extent  TYPE c LENGTH 1,
*            END OF lty_genseg.
*
*
*    DATA: l_year_from  TYPE tstr_year,
*          l_year_to    TYPE tstr_year,
*          lv_year      TYPE tstr_year,
*          l_counter    TYPE i,          " Index for PEROD_TAB-INDEX
*          ls_ttstr     TYPE zinf_s_scscp_ttstr,
*          ls_genseg    TYPE lty_genseg,
*          ls_gensegwa  TYPE tstr_gensegyearwa,
*          lt_gensegtab TYPE tstr_gensegyeartab.
  ENDMETHOD.