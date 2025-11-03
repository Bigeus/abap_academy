*&---------------------------------------------------------------------*
*& Include          Z_TOP
*&---------------------------------------------------------------------*
DATA: vg_ok_code TYPE sy-ucomm.

TYPES:
    BEGIN OF ty_scr_0101,
      arquivo   TYPE string,
      servidor  TYPE c LENGTH 1,
      usuario   TYPE c LENGTH 1,
    END OF ty_scr_0101.

DATA: scr_0101 TYPE ty_scr_0101.

TABLES: makt, mara, vbak, vbap, kna1.

TYPES:
  BEGIN OF ty_s_alv,
    vbeln    TYPE vbak-vbeln,
    posnr    TYPE vbap-posnr,
    matnr    TYPE mara-matnr,
*    matnr    TYPE c LENGTH 18,
    maktx    TYPE makt-maktx,
    menge    TYPE vbap-zmeng,
    meins    TYPE vbap-meins,
    vlr_tot  TYPE p LENGTH 8 DECIMALS 2,
    vlr_unit TYPE p LENGTH 8 DECIMALS 2,
    kunnr    TYPE kna1-kunnr,
    name1    TYPE kna1-name1,
  END OF ty_s_alv.

TYPES: ty_t_alv TYPE ty_s_alv.

TYPES:
  BEGIN OF ty_s_makt,
    matnr TYPE makt-matnr,
*    matnr TYPE c LENGTH 18,
    maktx TYPE makt-maktx,
  END OF ty_s_makt.

TYPES: ty_t_makt TYPE SORTED TABLE OF ty_s_makt WITH UNIQUE KEY matnr.

TYPES:
  BEGIN OF ty_s_kna1,
    kunnr TYPE kna1-kunnr,
    name1 TYPE kna1-name1,
  END OF ty_s_kna1.

TYPES: ty_t_kna1 TYPE SORTED TABLE OF ty_s_kna1 WITH UNIQUE KEY kunnr.

DATA: wg_var TYPE disvariant.

*--------------------------------------------------------------------*
* Declaração de Variáveis globais
*--------------------------------------------------------------------*
DATA: tg_alv TYPE STANDARD TABLE OF ty_t_alv.