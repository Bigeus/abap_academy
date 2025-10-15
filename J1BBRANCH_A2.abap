*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_J1BBRANCH_A2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_j1bbranch_a2 NO STANDARD PAGE HEADING.

TABLES: j_1bbranch.

TOP-OF-PAGE.
  WRITE: / sy-uline,
         / sy-vline, 2(20) 'Código Empresa' COLOR COL_HEADING,
           sy-vline, 24(20) 'Local' COLOR COL_HEADING,
           sy-vline, 46(20) 'Nome' COLOR COL_HEADING,
           sy-vline, 68(20) 'Número Fiscal 1' COLOR COL_HEADING,
           sy-vline,
         / sy-uline.

*--------------------------------------------------------------------*
*Elementos de Seleção
*--------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
    SELECT-OPTIONS s_bukrs FOR j_1bbranch-bukrs NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_branch FOR j_1bbranch-branch NO INTERVALS.
    SELECT-OPTIONS s_name FOR j_1bbranch-name NO INTERVALS.
    SELECT-OPTIONS s_stcd1 FOR j_1bbranch-stcd1.
  SELECTION-SCREEN END OF BLOCK b01.

*--------------------------------------------------------------------*
*SELECT dos campos
*--------------------------------------------------------------------*
START-OF-SELECTION.
  DATA: tl_places TYPE ztt0simoev_ct_j1bbranch,
        wl_place  TYPE ztt0simoev_s_j1bbranch.

  SELECT bukrs branch name stcd1
    FROM j_1bbranch
    INTO TABLE tl_places
    WHERE bukrs IN s_bukrs
      AND branch IN s_branch
      AND name IN s_name
      AND stcd1 IN s_stcd1.

*--------------------------------------------------------------------*
*Display Loop
*--------------------------------------------------------------------*
  LOOP AT tl_places INTO wl_place.
    WRITE: / sy-vline, 2(20) wl_place-bukrs,
           sy-vline, 24(20) wl_place-branch,
           sy-vline, 46(20) wl_place-name,
           sy-vline, 68(20) wl_place-stcd1,
           sy-vline,
           sy-uline.
  ENDLOOP.