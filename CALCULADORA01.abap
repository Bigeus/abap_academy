*&--------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_CALCULADORA01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_calculadora01 MESSAGE-ID ztt0simoev_cm_test.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  PARAMETERS: p_int1 TYPE i,
              p_int2 TYPE i.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN SKIP.

*SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE text-b02.
*PARAMETERS: p_soma  RADIOBUTTON GROUP grp DEFAULT 'X',
*            p_subtr RADIOBUTTON GROUP grp,
*            p_mult  RADIOBUTTON GROUP grp,
*            p_divid RADIOBUTTON GROUP grp.
*SELECTION-SCREEN END OF BLOCK b02.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.
  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_soma RADIOBUTTON GROUP grp.
    SELECTION-SCREEN COMMENT 4(20) TEXT-c01 FOR FIELD p_soma.
    PARAMETERS: p_subtr RADIOBUTTON GROUP grp.
    SELECTION-SCREEN COMMENT 30(20) TEXT-c02 FOR FIELD p_subtr.
    PARAMETERS: p_mult RADIOBUTTON GROUP grp.
    SELECTION-SCREEN COMMENT 56(20) TEXT-c03 FOR FIELD p_mult.
    PARAMETERS: p_divid RADIOBUTTON GROUP grp.
    SELECTION-SCREEN COMMENT 79(20) TEXT-c04 FOR FIELD p_divid.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b02.


START-OF-SELECTION.
  DATA: vl_resultado TYPE i.

  CASE 'X'.
    WHEN p_soma.
      vl_resultado = p_int1 + p_int2.
    WHEN p_subtr.
      vl_resultado = p_int1 - p_int2.
    WHEN p_mult.
      vl_resultado = p_int1 * p_int2.
    WHEN p_divid.

      IF p_int2 NE 0.
        vl_resultado = p_int1 / p_int2.

      ELSEIF p_int2 EQ 0.
        MESSAGE s002 DISPLAY LIKE 'E'.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.


  IF p_divid = 'X' AND p_int2 = 0.

  ELSE.
    WRITE: / 'Resultado:', vl_resultado.
  ENDIF.