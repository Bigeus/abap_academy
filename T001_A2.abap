*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_T001_A2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_t001_a2 NO STANDARD PAGE HEADING LINE-SIZE 90.

TABLES: t001.

TOP-OF-PAGE.
  WRITE: / sy-uline,
         / sy-vline, 2(10) 'Empresa' COLOR COL_HEADING,
           sy-vline, 14(25) 'Nome Empresa' COLOR COL_HEADING,
           sy-vline, 41(20) 'Cidade' COLOR COL_HEADING,
           sy-vline, 63(10) 'Moeda' COLOR COL_HEADING,
           sy-vline, 75(10) 'Idioma' COLOR COL_HEADING,
           sy-vline,
         / sy-uline.

*--------------------------------------------------------------------*
*Elementos de Seleção
*--------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
    SELECT-OPTIONS s_bukrs FOR t001-bukrs NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_butxt FOR t001-butxt.
    SELECT-OPTIONS s_ort01 FOR t001-ort01.
    SELECT-OPTIONS s_waers FOR t001-waers NO INTERVALS.
    SELECT-OPTIONS s_spras FOR t001-spras NO INTERVALS.
  SELECTION-SCREEN END OF BLOCK b01.

*--------------------------------------------------------------------*
*SELECT dos campos
*--------------------------------------------------------------------*
START-OF-SELECTION.
  DATA: tl_empresas TYPE ztt0simoev_ct_t001,
        wl_empresa  TYPE LINE OF ztt0simoev_ct_t001.

  SELECT bukrs butxt ort01 waers spras
    FROM t001
    INTO TABLE tl_empresas
    WHERE bukrs IN s_bukrs
      AND butxt IN s_butxt
      AND ort01 IN s_ort01
      AND waers IN s_waers
      AND spras IN s_spras.

*--------------------------------------------------------------------*
*Display Loop
*--------------------------------------------------------------------*
  LOOP AT tl_empresas INTO wl_empresa.
    WRITE: / sy-vline, 2(10) wl_empresa-bukrs,
           sy-vline, 14(25) wl_empresa-butxt,
           sy-vline, 41(20) wl_empresa-ort01,
           sy-vline, 63(10) wl_empresa-waers,
           sy-vline, 75(10) wl_empresa-spras,
           sy-vline,
           sy-uline.
  ENDLOOP.