  METHOD month_plus_determine.
    DATA: BEGIN OF dat,
            jjjj(4) ,
            mm(2) ,
            tt(2) ,
          END OF dat,

          BEGIN OF hdat,
            jjjj(4) ,
            mm(2) ,
            tt(2) ,
          END OF hdat,
          newmm    TYPE p,
          diffjjjj TYPE p.

    dat-jjjj =  olddate+0(4).
    dat-mm   =  olddate+4(2).
    dat-tt =  olddate+6(2).

    diffjjjj =   ( dat-mm + months - 1 ) DIV 12.
    newmm    =   ( dat-mm + months - 1 ) MOD 12 + 1.
    dat-jjjj = dat-jjjj +  diffjjjj.

    IF newmm < 10.
      dat-mm+0(1) = '0'.
      dat-mm+1(1) = newmm.
    ELSE.
      dat-mm = newmm.
    ENDIF.
    IF dat-tt > '28'.
      hdat-tt = '01'.
      newmm   = ( dat-mm  )  MOD 12 + 1.
      hdat-jjjj = dat-jjjj + ( (  dat-mm ) DIV 12 ).

      IF newmm < 10.
        hdat-mm+0(1) = '0'.
        hdat-mm+1(1) = newmm.

      ELSE.
        hdat-mm = newmm.
      ENDIF.

      IF dat-tt = '31'.
        newdate = hdat.
        newdate = newdate - 1.
      ELSE.
        IF dat-mm = '02'.
          newdate = hdat.
          newdate = newdate - 1.
        ELSE.
          newdate = dat.
        ENDIF.
      ENDIF.
    ELSE.
      newdate = dat.
    ENDIF.
  ENDMETHOD.