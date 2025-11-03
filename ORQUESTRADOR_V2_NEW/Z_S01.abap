*&---------------------------------------------------------------------*
*& Include          ZTT0SIMOEV_I_ORQUESTR_V2_S01
*&---------------------------------------------------------------------*

TABLES: ZTBSICORC_SP_PAR.

SELECTION-SCREEN BEGIN OF SCREEN 9200 AS SUBSCREEN.

SELECT-OPTIONS: s_app   FOR   ZTBSICORC_SP_PAR-id_app,
                s_type  FOR   ZTBSICORC_SP_PAR-app_type.

SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_dt_fx RADIOBUTTON GROUP gr2.
    SELECTION-SCREEN COMMENT 4(10) text-t01 FOR FIELD p_dt_fx.
    PARAMETERS: p_dt_dn RADIOBUTTON GROUP gr2.
    SELECTION-SCREEN COMMENT 20(10) text-t02 FOR FIELD p_dt_dn.
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF SCREEN 9200.