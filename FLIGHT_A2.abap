*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_FLIGHT_A2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_flight_a2 NO STANDARD PAGE HEADING LINE-SIZE 380.

TABLES: spfli.

TOP-OF-PAGE.
  WRITE: / sy-uline,
         / sy-vline, 2(20) 'Companhia Aérea' COLOR COL_HEADING,
           sy-vline, 24(20) 'Número Conexão' COLOR COL_HEADING,
           sy-vline, 46(20) 'País Ida' COLOR COL_HEADING,
           sy-vline, 68(20) 'Cidade Ida' COLOR COL_HEADING,
           sy-vline, 90(20) 'Aeroporto Ida' COLOR COL_HEADING,
           sy-vline, 114(20) 'País Chegada' COLOR COL_HEADING,
           sy-vline, 136(20) 'Cidade Chegada' COLOR COL_HEADING,
           sy-vline, 158(20) 'Aeroporto Dest.' COLOR COL_HEADING,

           sy-vline, 180(20) 'Duração Vôo' COLOR COL_HEADING,
           sy-vline, 202(20) 'Hora Saída' COLOR COL_HEADING,
           sy-vline, 224(20) 'Hora Chegada' COLOR COL_HEADING,
           sy-vline, 246(20) 'Distância' COLOR COL_HEADING,
           sy-vline, 268(20) 'Unidade Dist.' COLOR COL_HEADING,
           sy-vline, 290(20) 'Tipo Vôo' COLOR COL_HEADING,
           sy-vline, 312(20) 'Período' COLOR COL_HEADING,
           sy-vline,
         / sy-uline.


*--------------------------------------------------------------------*
*Elementos de Seleção
*--------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
    SELECT-OPTIONS s_compan FOR spfli-carrid NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_nconex FOR spfli-connid NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_paisid FOR spfli-countryfr NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_cidaid FOR spfli-cityfrom NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_aeroid FOR spfli-airpfrom NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_paisch FOR spfli-countryto NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_cidach FOR spfli-cityto NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_aerdes FOR spfli-airpto NO-EXTENSION NO INTERVALS.

    SELECTION-SCREEN SKIP.

    SELECT-OPTIONS s_durvo FOR spfli-fltime.
    SELECT-OPTIONS s_hrsai FOR spfli-deptime.
    SELECT-OPTIONS s_hrche FOR spfli-arrtime.
    SELECT-OPTIONS s_dist FOR spfli-distance.
    SELECT-OPTIONS s_unidi FOR spfli-distid.
    SELECT-OPTIONS s_type FOR spfli-fltype NO INTERVALS.
    SELECT-OPTIONS s_perio FOR spfli-period.

  SELECTION-SCREEN END OF BLOCK b01.

*--------------------------------------------------------------------*
*SELECT dos campos
*--------------------------------------------------------------------*

START-OF-SELECTION.
  DATA: tl_voos TYPE ztt0simoev_ct_flight.
  DATA: wl_voo TYPE  ztt0simoev_s_flight.

  SELECT carrid connid countryfr cityfrom airpfrom countryto cityto airpto fltime deptime arrtime distance distid fltype period
    FROM spfli
    INTO TABLE tl_voos
    WHERE carrid IN s_compan
      AND connid IN s_nconex
      AND countryfr IN s_paisid
      AND cityfrom IN s_cidaid
      AND airpfrom IN s_aeroid
      AND cityto IN s_cidach
      AND countryto IN s_paisch
      AND airpto IN s_aerdes

      AND fltime IN s_durvo
      AND deptime IN s_hrsai
      AND arrtime IN s_hrche
      AND distance IN s_dist
      AND distid IN s_unidi
      AND fltype IN s_type
      AND period IN s_perio.

*--------------------------------------------------------------------*
*Display Loop
*--------------------------------------------------------------------*

  LOOP AT tl_voos INTO wl_voo.
    WRITE: / sy-vline, 2(20) wl_voo-carrid,
           sy-vline, 24(20) wl_voo-connid,
           sy-vline, 46(20) wl_voo-countryfr,
           sy-vline, 68(20) wl_voo-cityfrom,
           sy-vline, 90(20) wl_voo-airpfrom,
           sy-vline, 114(20) wl_voo-countryto,
           sy-vline, 136(20) wl_voo-cityto,
           sy-vline, 158(20) wl_voo-airpto,

           sy-vline, 180(20) wl_voo-fltime,
           sy-vline, 202(20) wl_voo-deptime,
           sy-vline, 224(20) wl_voo-arrtime,
           sy-vline, 246(20) wl_voo-distance,
           sy-vline, 268(20) wl_voo-distid,
           sy-vline, 290(20) wl_voo-fltype,
           sy-vline, 312(20) wl_voo-period,
           sy-vline,
          / sy-uline.

  ENDLOOP.