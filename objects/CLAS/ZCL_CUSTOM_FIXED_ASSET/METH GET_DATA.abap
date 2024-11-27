  METHOD get_data.

    SELECT *
      FROM zinf_t001
      WHERE rate_type EQ '01'
      INTO TABLE @mt_index_table.

    SELECT *
      FROM zinf_t029
     WHERE bukrs  IN @mr_company_code
       AND anln1  IN @mr_anln1
       AND anln2  IN @mr_anln2
       AND rldnr  IN @mr_rldnr
       AND budat  IN @mr_budat
      INTO TABLE @mt_029.


    SELECT *
      FROM zinf_t030
     WHERE bukrs IN @mr_company_code
       AND anln1 IN @mr_anln1
       AND anln2 IN @mr_anln2
       AND rldnr IN @mr_rldnr
       AND val_date IN @mr_valuation_date
      INTO TABLE @mt_030.

  ENDMETHOD.