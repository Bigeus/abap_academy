*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_ARQUIVOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_arquivos.

*--------------------------------------------------------------------*
* Declaração de Tipos
*--------------------------------------------------------------------*
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
    maktx TYPE makt-maktx,
  END OF ty_s_makt.

TYPES: ty_t_makt TYPE SORTED TABLE OF ty_s_makt WITH UNIQUE KEY matnr.

TYPES:
  BEGIN OF ty_s_kna1,
    kunnr TYPE kna1-kunnr,
    name1 TYPE kna1-name1,
  END OF ty_s_kna1.

TYPES: ty_t_kna1 TYPE SORTED TABLE OF ty_s_kna1 WITH UNIQUE KEY kunnr.

*--------------------------------------------------------------------*
* Declaração de Variáveis globais
*--------------------------------------------------------------------*
DATA: tg_alv TYPE STANDARD TABLE OF ty_t_alv.

*--------------------------------------------------------------------*
* Tela de Seleção
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  PARAMETERS: p_arq TYPE string LOWER CASE OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b01.

*--------------------------------------------------------------------*
* Eventos de Tela
*--------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_arq.

  PERFORM zf_f4_arquivo USING p_arq.

*--------------------------------------------------------------------*
* Eventos de Execução
*--------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM zf_processa_arquivo.

  PERFORM zf_apresenta_alv.


*&---------------------------------------------------------------------*
*& Form zf_f4_arquivo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ARQ
*&---------------------------------------------------------------------*
FORM zf_f4_arquivo  USING p_arq TYPE string.

  DATA: tl_file_table     TYPE filetable.
  DATA: vl_rc             TYPE i.


  cl_gui_frontend_services=>file_open_dialog(
*    EXPORTING
*      window_title            =                  " Title Of File Open Dialog
*      default_extension       =                  " Default Extension
*      default_filename        =                  " Default File Name
*      file_filter             =                  " File Extension Filter String
*      with_encoding           =                  " File Encoding
*      initial_directory       =                  " Initial Directory
*      multiselection          =                  " Multiple selections poss.
    CHANGING
      file_table              = tl_file_table     " Table Holding Selected Files
      rc                      = vl_rc             " Return Code, Number of Files or -1 If Error Occurred
*      user_action             =                  " User Action (See Class Constants ACTION_OK, ACTION_CANCEL)
*      file_encoding           =
    EXCEPTIONS
      file_open_dialog_failed = 1                " "Open File" dialog failed
      cntl_error              = 2                " Control error
      error_no_gui            = 3                " No GUI available
      not_supported_by_gui    = 4                " GUI does not support this
      OTHERS                  = 5
  ).

  IF sy-subrc EQ 0.
    READ TABLE tl_file_table INTO p_arq INDEX 1.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_processa_arquivo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_processa_arquivo.

  DATA: tl_arquivo TYPE TABLE OF string,
        tl_split   TYPE TABLE OF string.

  DATA: wl_alv  TYPE ty_s_alv,
        wl_kna1 TYPE ty_s_kna1,
        wl_makt TYPE ty_s_makt.

  DATA: vl_linha      TYPE string,
        vl_split      TYPE string,
        vl_conv_matnr TYPE c LENGTH 18,
        vl_conv_kunnr TYPE c LENGTH 10.

  DATA: tl_makt   TYPE ty_t_makt.
  DATA: tl_kna1    TYPE ty_t_kna1.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = p_arq
*     FILETYPE                = 'ASC'
*     HAS_FIELD_SEPARATOR     = ' '
*     HEADER_LENGTH           = 0
*     READ_BY_LINE            = 'X'
*     DAT_MODE                = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     CHECK_BOM               = ' '
*     VIRUS_SCAN_PROFILE      =
*     NO_AUTH_CHECK           = ' '
*   IMPORTING
*     FILELENGTH              =
*     HEADER                  =
    TABLES
      data_tab                = tl_arquivo
*   CHANGING
*     ISSCANPERFORMED         = ' '
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16.

  IF sy-subrc <> 0.
    MESSAGE: 'Deu erro' TYPE 'E'.
  ENDIF.

* DELETE tl_arquivo INDEX 1.

  LOOP AT tl_arquivo INTO vl_linha.

    IF sy-tabix EQ 1.
      CONTINUE.
    ENDIF.

    SPLIT vl_linha AT ';' INTO TABLE tl_split.

    wl_alv-vbeln = tl_split[ 1 ].
    wl_alv-posnr = tl_split[ 2 ].

*    vl_split = tl_split[ 3 ].
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = tl_split[ 3 ]
      IMPORTING
        output = wl_alv-matnr.

*    wl_alv-matnr = vl_conv_matnr.

    vl_split = tl_split[ 4 ].
    TRANSLATE vl_split USING '. '.
    TRANSLATE vl_split USING ',.'.
    CONDENSE vl_split NO-GAPS.

    wl_alv-menge = vl_split.
    wl_alv-meins = tl_split[ 5 ].

*    wl_alv-kunnr = tl_split[ 6 ].
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = tl_split[ 6 ]
      IMPORTING
        output = wl_alv-kunnr.

*    wl_alv-kunnr  = vl_conv_kunnr.

    APPEND wl_alv TO tg_alv.

  ENDLOOP.

" Todo: material não está vindo no alv
  SELECT matnr maktx
      FROM makt
      INTO TABLE tl_makt
      FOR ALL ENTRIES IN tg_alv
      WHERE matnr = tg_alv-matnr.

  SELECT kunnr name1
    FROM kna1
    INTO TABLE tl_kna1
    FOR ALL ENTRIES IN tg_alv
    WHERE kunnr = tg_alv-kunnr.

  "Loopar a tg_alv com field-symbol e ir preenchendo com 2 read-table? deve dar pra fazer direto no select

  LOOP AT tg_alv ASSIGNING FIELD-SYMBOL(<alv>).

    READ TABLE tl_makt INTO wl_makt WITH KEY matnr = <alv>-matnr.
    IF sy-subrc EQ 0.
      <alv>-maktx = wl_makt-maktx.
    ENDIF.

    READ TABLE tl_kna1 INTO wl_kna1 WITH KEY kunnr = <alv>-kunnr.
    IF sy-subrc EQ 0.
      <alv>-name1 = wl_kna1-name1.
    ENDIF.

  ENDLOOP.

ENDFORM.
FORM zf_apresenta_alv.

  DATA: tl_fieldcat TYPE slis_t_fieldcat_alv.
  DATA: wl_fieldcat TYPE slis_fieldcat_alv.
  DATA: wl_layout TYPE slis_layout_alv.

  wl_layout-zebra = 'X'.
  wl_layout-colwidth_optimize = 'X'.

  CLEAR wl_fieldcat.
  wl_fieldcat-fieldname = 'VBELN'.
  wl_fieldcat-rollname  = 'VBELN_VA'.
  wl_fieldcat-key = 'X'.
  APPEND wl_fieldcat TO tl_fieldcat.

  CLEAR wl_fieldcat.
  wl_fieldcat-fieldname = 'POSNR'.
  wl_fieldcat-rollname = 'POSNR_VA'.
  wl_fieldcat-key = 'X'.
  APPEND wl_fieldcat TO tl_fieldcat.

  CLEAR wl_fieldcat.
  wl_fieldcat-fieldname = 'MATNR'.
  wl_fieldcat-rollname = 'MATNR'.
  wl_fieldcat-no_zero = 'X'.
  APPEND wl_fieldcat TO tl_fieldcat.

  CLEAR wl_fieldcat.
  wl_fieldcat-fieldname = 'MAKTX'.
  wl_fieldcat-rollname = 'MAKTX'.
  APPEND wl_fieldcat TO tl_fieldcat.

  CLEAR wl_fieldcat.
  wl_fieldcat-fieldname = 'MENGE'.
  wl_fieldcat-rollname = 'DZMENG'.
  APPEND wl_fieldcat TO tl_fieldcat.

  CLEAR wl_fieldcat.
  wl_fieldcat-fieldname = 'MEINS'.
  wl_fieldcat-rollname = 'MEINS'.
  APPEND wl_fieldcat TO tl_fieldcat.

  CLEAR wl_fieldcat.
  wl_fieldcat-fieldname = 'VLR_TOT'.
  wl_fieldcat-seltext_s = 'Vlr.Tot.'.
  wl_fieldcat-seltext_m = 'Valor Tot.'.
  wl_fieldcat-seltext_l = 'Valor Total'.
*  wl_fieldcat-rollname = 'VBELN'.
  APPEND wl_fieldcat TO tl_fieldcat.

  CLEAR wl_fieldcat.
  wl_fieldcat-fieldname = 'VLR_UNIT'.
  wl_fieldcat-seltext_s = 'Vlr.Unit.'.
  wl_fieldcat-seltext_m = 'Valor Unit.'.
  wl_fieldcat-seltext_l = 'Valor Unitário'.
*  wl_fieldcat-rollname = 'VBELN'.
  APPEND wl_fieldcat TO tl_fieldcat.

  CLEAR wl_fieldcat.
  wl_fieldcat-fieldname = 'KUNNR'.
  wl_fieldcat-rollname = 'KUNNR'.
  wl_fieldcat-no_zero = 'X'.
  APPEND wl_fieldcat TO tl_fieldcat.

  CLEAR wl_fieldcat.
  wl_fieldcat-fieldname = 'NAME1'.
  wl_fieldcat-rollname = 'NAME1_GP'.
  APPEND wl_fieldcat TO tl_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'SET_PF'
      I_CALLBACK_USER_COMMAND  = 'ZF_USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE   = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
*     I_GRID_SETTINGS          =
      is_layout                = wl_layout
      it_fieldcat              = tl_fieldcat
*     IT_EXCLUDING             =
*     IT_SPECIAL_GROUPS        =
*     IT_SORT                  =
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
*     I_SAVE                   = ' '
*     IS_VARIANT               =
*     IT_EVENTS                =
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER  =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = tg_alv
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE: 'Deu erro no ALV_DISPLAY' TYPE 'E'.
  ENDIF.


ENDFORM.
FORM zf_user_command USING r_ucomm LIKE sy-ucomm
                           rs_selfield TYPE slis_selfield.

DATA: tl_vend TYPE TABLE OF ztt0simoev_tm_v1.
DATA: wl_alv  TYPE ty_s_alv,
      wl_vend TYPE ztt0simoev_tm_v1.

DATA: vl_msg TYPE string.
DATA: vl_answer TYPE string.

CASE r_ucomm.
  WHEN 'SAVE'.

   CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question = 'Deseja salvar os dados na tabela ZTT0SIMOEV_TM_V1 ?'
      text_button_1 = 'Sim'
      text_button_2 = 'Não'
    IMPORTING
      answer        = vl_answer.

    CASE vl_answer.
      WHEN 1.
    LOOP AT tg_alv INTO wl_alv.

      wl_vend-nro   = wl_alv-vbeln.
      wl_vend-item  = wl_alv-posnr+3(3).          " tamanho da tabela tem 3 caracteres a menos então preciso incrementar aqui
      wl_vend-matnr = wl_alv-matnr.
      wl_vend-maktx = wl_alv-maktx.
      wl_vend-kunnr = wl_alv-kunnr.
      wl_vend-unv   = wl_alv-meins.
      wl_vend-qtd   = wl_alv-menge.

      APPEND wl_vend TO tl_vend.

    ENDLOOP.

    IF tl_vend[] IS NOT INITIAL.
      TRY.
      INSERT ztt0simoev_tm_v1 FROM TABLE tl_vend.
      IF sy-subrc EQ 0.
        COMMIT WORK.
        MESSAGE: |{ sy-dbcnt } linhas foram atualizadas no banco. | TYPE 'I' DISPLAY LIKE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE: 'Erro ao inserir dados na tabela transparente.' TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
      CATCH cx_sy_open_sql_db.
        MESSAGE: 'Erro ao inserir linhas duplicadas' TYPE 'I' DISPLAY LIKE 'E'. " Excessão de erro de inserção de linhas duplicadas
      ENDTRY.
    ENDIF.

************************************************************
      WHEN 2.
        MESSAGE: 'Operação Cancelada' TYPE 'I'.
    ENDCASE.
ENDCASE.

ENDFORM.
FORM set_pf USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'STANDARD_FULLSCREEN'.

ENDFORM.