REPORT ztt0simoev_r_t001_types NO STANDARD PAGE HEADING LINE-SIZE 120.

TABLES: t001.

*--------------------------------------------------------------------*
* Tipo de estrutura para work area
*--------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_s_t001,
    bukrs    TYPE t001-bukrs,   " Código da empresa
    butxt    TYPE t001-butxt,   " Nome da empresa
    ort01     TYPE t001-ort01,   " Cidade
    spras TYPE t001-spras,   " Idioma
  END OF ty_s_t001.

*--------------------------------------------------------------------*
* Tipo de categoria de tabela para tabela interna
*--------------------------------------------------------------------*
TYPES: ty_t_empresas TYPE SORTED TABLE OF ty_s_t001 WITH UNIQUE KEY bukrs.

*--------------------------------------------------------------------*
* Campos de seleção
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS s_bukrs FOR t001-bukrs NO-EXTENSION NO INTERVALS.
  SELECT-OPTIONS s_butxt FOR t001-butxt.
  SELECT-OPTIONS s_ort01 FOR t001-ort01.
  SELECT-OPTIONS s_spras FOR t001-spras NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b01.

*--------------------------------------------------------------------*
* Tabelas internas e variáveis de trabalho
*--------------------------------------------------------------------*
DATA: tl_empresas TYPE ty_t_empresas,
      wl_empresa  TYPE ty_s_t001.

*--------------------------------------------------------------------*
* Seleção dos dados
*--------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT bukrs butxt ort01 spras
    FROM t001
    INTO TABLE tl_empresas
    WHERE bukrs IN s_bukrs
      AND butxt IN s_butxt
      AND ort01 IN s_ort01
      AND spras IN s_spras.

*--------------------------------------------------------------------*
* Cabeçalho da página
*--------------------------------------------------------------------*
TOP-OF-PAGE.
  WRITE: / sy-uline,
         / sy-vline, 2(20) 'Comp Code' COLOR COL_GROUP,
           sy-vline, 24(20) 'Name Cod' COLOR COL_GROUP,
           sy-vline, 46(20) 'City',
           sy-vline, 68(20) 'Language',
           sy-vline,
         / sy-uline.

*--------------------------------------------------------------------*
* Exibição dos dados
*--------------------------------------------------------------------*
LOOP AT tl_empresas INTO wl_empresa.
  WRITE: / sy-vline, 2(20) wl_empresa-bukrs,
           sy-vline, 24(20) wl_empresa-butxt,
           sy-vline, 46(20) wl_empresa-ort01,
           sy-vline, 68(20) wl_empresa-spras,
           sy-vline,
         / sy-uline.
ENDLOOP.