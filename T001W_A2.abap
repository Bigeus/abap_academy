*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_T001W_A2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0SIMOEV_R_T001W_A2 NO STANDARD PAGE HEADING.

TABLES: t001w.

TOP-OF-PAGE.
  WRITE: / sy-uline,
         / sy-vline, 2(10) 'Planta' COLOR COL_HEADING,
           sy-vline, 14(25) 'Nome Empresa' COLOR COL_HEADING,
           sy-vline, 41(20) 'Rua e nº' COLOR COL_HEADING,
           sy-vline, 63(10) 'CEP' COLOR COL_HEADING,
           sy-vline, 75(10) 'País/Região' COLOR COL_HEADING,
           sy-vline,
         / sy-uline.

*--------------------------------------------------------------------*
*Elementos de Seleção
*--------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
    SELECT-OPTIONS s_werks FOR t001w-werks NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_name1 FOR t001w-name1 no INTERVALS.
    SELECT-OPTIONS s_pstlz FOR t001w-pstlz NO INTERVALS.
    SELECT-OPTIONS s_land1 FOR t001w-land1 NO INTERVALS.
    SELECT-OPTIONS s_stras FOR t001w-stras.
  SELECTION-SCREEN END OF BLOCK b01.

*--------------------------------------------------------------------*
*SELECT dos campos
*--------------------------------------------------------------------*
START-OF-SELECTION.
  DATA: tl_sites TYPE ztt0simoev_ct_t001w,
        wl_site  TYPE LINE OF ztt0simoev_ct_t001w.

  SELECT werks name1 stras pstlz land1
    FROM t001w
    INTO TABLE tl_sites
    WHERE werks IN s_werks
      AND name1 IN s_name1
      AND stras IN s_stras
      AND pstlz IN s_pstlz
      AND land1 IN s_land1.

*--------------------------------------------------------------------*
*Display Loop
*--------------------------------------------------------------------*
  LOOP AT tl_sites INTO wl_site.
    WRITE: / sy-vline, 2(10) wl_site-werks,
           sy-vline, 14(25) wl_site-name1,
           sy-vline, 41(20) wl_site-stras,
           sy-vline, 63(10) wl_site-pstlz,
           sy-vline, 75(10) wl_site-land1,
           sy-vline,
           sy-uline.
  ENDLOOP.