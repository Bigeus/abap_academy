*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_SKAT_A2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_skat_a2 NO STANDARD PAGE HEADING LINE-SIZE 600.

TABLES: skat.

TOP-OF-PAGE.

  WRITE: / sy-uline,
           / sy-vline, 2(20)   'Idioma'             COLOR COL_HEADING,
             sy-vline, 24(20)  'Plano Contas'       COLOR COL_HEADING,
             sy-vline, 46(20) 'Conta Contábil'     COLOR COL_HEADING,
             sy-vline, 68(20) 'Descrição Curta'    COLOR COL_HEADING,
             sy-vline, 90(40) 'Descrição Longa'    COLOR COL_HEADING,
             sy-vline, 132(20)'Termo Pesquisa'     COLOR COL_HEADING,
             sy-vline,
           / sy-uline.


*--------------------------------------------------------------------*
*Elementos de Seleção
*--------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
    SELECT-OPTIONS s_spras FOR skat-spras NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_ktopl FOR skat-ktopl NO INTERVALS.
    SELECT-OPTIONS s_saknr FOR skat-saknr NO INTERVALS.
    SELECT-OPTIONS s_txt20 FOR skat-txt20 NO INTERVALS.
    SELECT-OPTIONS s_txt50 FOR skat-txt50 NO INTERVALS.
    SELECT-OPTIONS s_mcod1 FOR skat-mcod1 NO INTERVALS.
  SELECTION-SCREEN END OF BLOCK b01.

*--------------------------------------------------------------------*
*SELECT dos campos
*--------------------------------------------------------------------*
START-OF-SELECTION.
  DATA: tl_contas TYPE ztt0simoev_ct_skat,
        wl_conta  TYPE LINE OF ztt0simoev_ct_skat.

  SELECT spras ktopl saknr txt20 txt50 mcod1
    FROM skat
    INTO TABLE tl_contas
    WHERE spras IN s_spras
      AND ktopl IN s_ktopl
      AND saknr IN s_saknr
      AND txt20 IN s_txt20
      AND txt50 IN s_txt50
      AND mcod1 IN s_mcod1.

*--------------------------------------------------------------------*
*Display Loop
*--------------------------------------------------------------------*
  LOOP AT tl_contas INTO wl_conta.

    WRITE: / sy-vline, 2(20)   wl_conta-spras,
             sy-vline, 24(20)   wl_conta-ktopl,
             sy-vline, 46(20)  wl_conta-saknr,
             sy-vline, 68(20)  wl_conta-txt20,
             sy-vline, 90(40)  wl_conta-txt50,
             sy-vline, 132(20) wl_conta-mcod1,
             sy-vline,
             sy-uline.

  ENDLOOP.