*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_ARQUIVOS_V2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_arquivos_v2.

*--------------------------------------------------------------------*
* Declaração de Tipos
*--------------------------------------------------------------------*
TABLES: ztt0simoev_tm_v1.

TYPES: BEGIN OF ty_s_alv,
         nro        TYPE ztt0simoev_tm_v1-nro, "Número do pedido de venda
         item       TYPE ztt0simoev_tm_v1-item, "Número do Item
         matnr      TYPE ztt0simoev_tm_v1-matnr, "Material Number
         maktx      TYPE ztt0simoev_tm_v1-maktx, "Material Description
         data_venda TYPE ztt0simoev_tm_v1-data_venda, "Data da Venda
         bukrs      TYPE ztt0simoev_tm_v1-bukrs, "Company Code
         branch     TYPE ztt0simoev_tm_v1-branch, "Branch
         kunnr      TYPE ztt0simoev_tm_v1-kunnr, "Customer Number
         valor      TYPE ztt0simoev_tm_v1-valor, "Valor da Venda
         unv        TYPE ztt0simoev_tm_v1-unv, "Unidade da Venda
         qtd        TYPE ztt0simoev_tm_v1-qtd, "Quantidade
       END   OF ty_s_alv.

TYPES: ty_t_alv TYPE ty_s_alv.

TYPES: BEGIN OF ty_s_filial,
         bukrs  TYPE ztt0simoev_tm_v1-bukrs,
         branch TYPE ztt0simoev_tm_v1-branch,
         valor  TYPE ztt0simoev_tm_v1-valor,
       END OF ty_s_filial.

TYPES: ty_t_filial TYPE ty_s_filial.

TYPES: BEGIN OF ty_s_material,
         matnr TYPE ztt0simoev_tm_v1-matnr,
         maktx TYPE ztt0simoev_tm_v1-maktx,
         valor TYPE ztt0simoev_tm_v1-valor,
       END OF ty_s_material.

TYPES: ty_t_material TYPE ty_s_material.

TYPES: BEGIN OF ty_s_cliente,
         kunnr TYPE ztt0simoev_tm_v1-kunnr,
         valor TYPE ztt0simoev_tm_v1-valor,
       END OF ty_s_cliente.

TYPES: ty_t_cliente TYPE ty_s_cliente.

*--------------------------------------------------------------------*
* Declaração de Variáveis globais
*--------------------------------------------------------------------*
DATA: tg_filial    TYPE SORTED TABLE OF ty_t_filial   WITH UNIQUE KEY bukrs branch.
DATA: tg_material  TYPE SORTED TABLE OF ty_t_material WITH UNIQUE KEY matnr maktx.
DATA: tg_cliente   TYPE SORTED TABLE OF ty_t_cliente  WITH UNIQUE KEY kunnr.
DATA: tg_detalhado TYPE SORTED TABLE OF ty_t_alv      WITH UNIQUE KEY nro item.
DATA: tg_alv       TYPE STANDARD TABLE OF ztt0simoev_tm_v1.
DATA: tg_fieldcat  TYPE slis_t_fieldcat_alv.

DATA: wg_fieldcat  TYPE slis_fieldcat_alv.
DATA: wg_layout    TYPE slis_layout_alv.

DATA: wg_detalhado TYPE ty_s_alv.
DATA: wg_material  TYPE ty_s_material.
DATA: wg_cliente   TYPE ty_s_cliente.
DATA: wg_filial    TYPE ty_s_filial.

*--------------------------------------------------------------------*
* Tela de Seleção
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS s_bukrs  FOR ztt0simoev_tm_v1-bukrs   NO INTERVALS NO-EXTENSION.
  SELECT-OPTIONS s_branch FOR ztt0simoev_tm_v1-branch  NO INTERVALS.
  SELECT-OPTIONS s_nro    FOR ztt0simoev_tm_v1-nro     NO INTERVALS.
  SELECT-OPTIONS s_dats   FOR ztt0simoev_tm_v1-data_venda.
  SELECT-OPTIONS s_kunnr  FOR ztt0simoev_tm_v1-kunnr   NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.

  PARAMETERS: p_detalh RADIOBUTTON GROUP grp,
              p_filial RADIOBUTTON GROUP grp,
              p_materi RADIOBUTTON GROUP grp,
              p_client RADIOBUTTON GROUP grp.

SELECTION-SCREEN END OF BLOCK b02.

*SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-b03.

PARAMETERS: p_arq TYPE string LOWER CASE OBLIGATORY.

*SELECTION-SCREEN END OF BLOCK b03.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_arq.
  PERFORM zf_f4_arquivo USING p_arq.

*--------------------------------------------------------------------*
* Eventos de Execução
*--------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM zf_processa_arquivo.
  PERFORM zf_filtrar_dados_tela.
  PERFORM zf_monta_alv.
  PERFORM zf_sumarizar_dados.
  PERFORM zf_apresenta_alv.









***************************************************************************
*&---------------------------------------------------------------------*
*& Form zf_f4_arquivo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ARQ
*&---------------------------------------------------------------------*
FORM zf_f4_arquivo  USING p_arq TYPE string.

  DATA: tl_file_table    TYPE filetable.
  DATA: vl_rc            TYPE i.

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
       file_table              =  tl_file_table    " Table Holding Selected Files
       rc                      =  vl_rc            " Return Code, Number of Files or -1 If Error Occurred
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
    MESSAGE: 'LEU O ARQUIVO CORRETAMENTE' TYPE 'S'.
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
FORM zf_processa_arquivo .

  DATA: tl_arquivo TYPE TABLE OF string,
        tl_split   TYPE TABLE OF string.      " Tabela para salvar os valores separados com ponto e vírgula

  DATA: vl_linha      TYPE string,
        vl_split      TYPE string.

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
* IMPORTING
*     FILELENGTH              =
*     HEADER                  =
    TABLES
      data_tab                = tl_arquivo
* CHANGING
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
    MESSAGE: 'Deu erro fazendo o upload do arquivo' TYPE 'E'.
  ENDIF.

  LOOP AT tl_arquivo INTO vl_linha.

    IF sy-tabix EQ 1.                               " Validação para pular a linha do cabeçalho do csv
      CONTINUE.
    ENDIF.

    SPLIT vl_linha AT ';' INTO TABLE tl_split.      " Separar os itens por ; do formato csv

    " TODO: nro e kunnr tem rotina de conversão? preciso mudar pro filtro pegar;
*    wg_detalhado-nro   = tl_split[ 1 ].
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = tl_split[ 1 ]
      IMPORTING
        output = wg_detalhado-nro.

    wg_detalhado-item  = tl_split[ 2 ].
    wg_detalhado-matnr = tl_split[ 3 ].
    wg_detalhado-maktx = tl_split[ 4 ].

*   wl_alv-data_venda = tl_split[ 5 ].
    vl_split = tl_split[ 5 ].
    REPLACE ALL OCCURRENCES OF '/' IN vl_split WITH ''.
    wg_detalhado-data_venda = |{ vl_split+4(4) }{ vl_split+2(2) }{ vl_split(2) }|.
    CLEAR vl_split.

    wg_detalhado-bukrs  = tl_split[ 6 ].
    wg_detalhado-branch = tl_split[ 7 ].

*    wg_detalhado-kunnr  = tl_split[ 8 ].
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input     =     tl_split[ 8 ]
      IMPORTING
        output    =     wg_detalhado-kunnr.

*    wl_alv-valor = tl_split[ 9 ].
    vl_split = tl_split[ 9 ].
    TRANSLATE vl_split USING '. '.
    TRANSLATE vl_split USING ',.'.
    CONDENSE vl_split NO-GAPS.
    wg_detalhado-valor  = vl_split.
    CLEAR vl_split.

    wg_detalhado-qtd = tl_split[ 10 ].
    wg_detalhado-unv = tl_split[ 11 ].

    APPEND wg_detalhado TO tg_detalhado.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_monta_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_monta_alv .

  CASE 'X'.
    WHEN p_detalh.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'NRO'.
      wg_fieldcat-seltext_s = 'Nm.Ped'.
      wg_fieldcat-seltext_m = 'Num Pedido'.
      wg_fieldcat-seltext_l = 'Numero do Pedido'.
      wg_fieldcat-no_zero  = 'X'.
      wg_fieldcat-key = 'X'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'ITEM'.
      wg_fieldcat-seltext_s = 'Item'.
      wg_fieldcat-seltext_m = 'Item'.
      wg_fieldcat-seltext_l = 'Item'.
      wg_fieldcat-key = 'X'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'MATNR'.
      wg_fieldcat-rollname  = 'MATNR'.
      wg_fieldcat-ref_tabname = 'ZTT0SIMOEV_TM_V1'.
      wg_fieldcat-tabname     = 'TG_DETALHADO'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'MAKTX'.
      wg_fieldcat-rollname  = 'MAKTX'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'DATA_VENDA'.
      wg_fieldcat-seltext_s = 'Dt.Vend'.
      wg_fieldcat-seltext_m = 'Data de venda'.
      wg_fieldcat-seltext_l = 'Data de venda'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'BUKRS'.
      wg_fieldcat-rollname  = 'BUKRS'.
      wg_fieldcat-ref_tabname = 'ZTT0SIMOEV_TM_V1'.
      wg_fieldcat-tabname     = 'TG_DETALHADO'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'BRANCH'.
      wg_fieldcat-rollname  = 'BRANCH_KK'.
      wg_fieldcat-ref_tabname = 'ZTT0SIMOEV_TM_V1'.
      wg_fieldcat-tabname     = 'TG_DETALHADO'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'KUNNR'.
      wg_fieldcat-rollname  = 'KUNNR'.
      wg_fieldcat-ref_tabname = 'ZTT0SIMOEV_TM_V1'.
      wg_fieldcat-tabname     = 'TG_DETALHADO'.
      wg_fieldcat-no_zero   = 'X'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'VALOR'.
      wg_fieldcat-seltext_s = 'Valor'.
      wg_fieldcat-seltext_m = 'Valor'.
      wg_fieldcat-seltext_l = 'Valor'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'UNV'.
      wg_fieldcat-seltext_s = 'Uni.vend'.
      wg_fieldcat-seltext_m = 'Unid.vend'.
      wg_fieldcat-seltext_l = 'Unidade de venda'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'QTD'.
      wg_fieldcat-seltext_s = 'Qtd'.
      wg_fieldcat-seltext_m = 'Qtd'.
      wg_fieldcat-seltext_l = 'Quantidade'.
      APPEND wg_fieldcat TO tg_fieldcat.

****************************************************************************************
    WHEN p_client.
      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'KUNNR'.
      wg_fieldcat-rollname  = 'KUNNR'.
      wg_fieldcat-no_zero   = 'X'.
      wg_fieldcat-ref_tabname = 'ZTT0SIMOEV_TM_V1'.
      wg_fieldcat-tabname     = 'TG_CLIENTE'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'VALOR'.
      wg_fieldcat-seltext_s = 'Valor'.
      wg_fieldcat-seltext_m = 'Valor'.
      wg_fieldcat-seltext_l = 'Valor'.
      APPEND wg_fieldcat TO tg_fieldcat.
****************************************************************************************
    WHEN p_filial.
      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'BUKRS'.
      wg_fieldcat-rollname  = 'BUKRS'.
      wg_fieldcat-ref_tabname = 'ZTT0SIMOEV_TM_V1'.
      wg_fieldcat-tabname     = 'TG_FILIAL'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'BRANCH'.
      wg_fieldcat-rollname  = 'BRANCH_KK'.
      wg_fieldcat-ref_tabname = 'ZTT0SIMOEV_TM_V1'.
      wg_fieldcat-tabname     = 'TG_FILIAL'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'VALOR'.
      wg_fieldcat-seltext_s = 'Valor'.
      wg_fieldcat-seltext_m = 'Valor'.
      wg_fieldcat-seltext_l = 'Valor'.
      APPEND wg_fieldcat TO tg_fieldcat.

*****************************************************************************************
    WHEN p_materi.
      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname   = 'MATNR'.
      wg_fieldcat-rollname    = 'MATNR'.
      wg_fieldcat-ref_tabname = 'ZTT0SIMOEV_TM_V1'.
      wg_fieldcat-tabname     = 'TG_MATERIAL'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'MAKTX'.
      wg_fieldcat-rollname  = 'MAKTX'.
      APPEND wg_fieldcat TO tg_fieldcat.

      CLEAR wg_fieldcat.
      wg_fieldcat-fieldname = 'VALOR'.
      wg_fieldcat-seltext_s = 'Valor'.
      wg_fieldcat-seltext_m = 'Valor'.
      wg_fieldcat-seltext_l = 'Valor'.
      APPEND wg_fieldcat TO tg_fieldcat.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_filtrar_dados_tela
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_filtrar_dados_tela .

  DELETE  tg_detalhado
    WHERE branch      NOT IN s_branch
    OR    bukrs       NOT IN s_bukrs
    OR    data_venda  NOT IN s_dats
    OR    kunnr       NOT IN s_kunnr
    OR    nro         NOT IN s_nro.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_apresenta_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_user_command USING r_ucomm LIKE sy-ucomm
                           rs_selfield TYPE slis_selfield.

  DATA: vl_msg    TYPE string.
  DATA: vl_answer TYPE string.
  DATA: wl_insere TYPE ztt0simoev_tm_v1,
        wl_alv    TYPE ty_s_alv.
  DATA: tl_insere TYPE TABLE OF ztt0simoev_tm_v1.

  CASE r_ucomm.
    WHEN 'SAVE'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          text_question         = 'Deseja salvar os dados na tabela ZTT0SIMOEV_TM_V1 ?'
          text_button_1         = 'Sim'
          text_button_2         = 'Não'
          display_cancel_button = ''
        IMPORTING
          answer        = vl_answer.

      "  montar a tabela interna pra... ***EU preciso do loop?
      IF vl_answer EQ 1.
*      LOOP AT tg_detalhado INTO wl_alv.
*        wl_insere-nro        = wl_alv-nro.
*        wl_insere-item       = wl_alv-item.
*        wl_insere-matnr      = wl_alv-matnr.
*        wl_insere-maktx      = wl_alv-maktx.
*        wl_insere-data_venda = wl_alv-data_venda.
*        wl_insere-bukrs      = wl_alv-bukrs.
*        wl_insere-branch     = wl_alv-branch.
*        wl_insere-kunnr      = wl_alv-kunnr.
*        wl_insere-valor      = wl_alv-valor.
*        wl_insere-unv        = wl_alv-unv.
*        wl_insere-qtd        = wl_alv-qtd.
*
*        APPEND wl_insere TO tl_insere.
*      ENDLOOP.

        MOVE-CORRESPONDING tg_detalhado[] TO tl_insere[].

        IF tl_insere[] IS NOT INITIAL.
          TRY.
              INSERT ztt0simoev_tm_v1 FROM TABLE tl_insere.
              IF sy-subrc EQ 0.
                COMMIT WORK.
                MESSAGE: |{ sy-dbcnt } linhas foram atualizadas no banco. | TYPE 'I' DISPLAY LIKE 'S'.
              ELSE.
                ROLLBACK WORK.
                MESSAGE: 'Erro ao inserir dados na tabela transparente.' TYPE 'I' DISPLAY LIKE 'E'.
              ENDIF.
            CATCH cx_sy_open_sql_db.
              MESSAGE: 'Erro ao inserir linhas duplicadas' TYPE 'I' DISPLAY LIKE 'E'.
          ENDTRY.
        ENDIF.

****************************************************************************
      ELSE.
        MESSAGE: 'Operação Cancelada' TYPE 'I'.
      ENDIF.
  ENDCASE.
ENDFORM.
FORM zf_apresenta_alv .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'SET_PF'
      i_callback_user_command  = 'ZF_USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE   = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
*     I_GRID_SETTINGS          =
*     IS_LAYOUT                = wl_layout
      it_fieldcat              = tg_fieldcat
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
    MESSAGE: 'DEU RUIM NO GRID DISPLAY' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_sumarizar_dados
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_sumarizar_dados .

  CASE 'X'.
    WHEN p_detalh.
      MOVE-CORRESPONDING tg_detalhado[] TO tg_alv[].

************************************************************
    WHEN p_client.

      LOOP AT tg_detalhado INTO wg_detalhado.
        CLEAR wg_cliente.
        wg_cliente-kunnr  = wg_detalhado-kunnr.
        wg_cliente-valor  = wg_detalhado-valor.
        COLLECT wg_cliente INTO tg_cliente.
      ENDLOOP.

      MOVE-CORRESPONDING tg_cliente[] TO tg_alv[].
******************************************************
    WHEN p_filial.

      LOOP AT tg_detalhado INTO wg_detalhado.
        CLEAR wg_filial.
        wg_filial-branch = wg_detalhado-branch.
        wg_filial-bukrs  = wg_detalhado-bukrs.
        wg_filial-valor  = wg_detalhado-valor.
        COLLECT wg_filial INTO tg_filial.
      ENDLOOP.

      MOVE-CORRESPONDING tg_filial[] TO tg_alv[].
*******************************************************
    WHEN p_materi.
      LOOP AT tg_detalhado INTO wg_detalhado.
        CLEAR wg_material.
        wg_material-matnr = wg_detalhado-matnr.
        wg_material-maktx = wg_detalhado-maktx.
        wg_material-valor  = wg_detalhado-valor.
        COLLECT wg_material INTO tg_material.
      ENDLOOP.

      MOVE-CORRESPONDING tg_material[] TO tg_alv[].
  ENDCASE.
ENDFORM.
FORM set_pf USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'STANDARD_FULLSCREEN'.

ENDFORM.