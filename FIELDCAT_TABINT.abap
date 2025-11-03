*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_FIELDCAT_TABINT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0SIMOEV_R_FIELDCAT_TABINT.

TYPES:
    BEGIN OF ty_s_alv,
      bukrs   TYPE t001-bukrs,
      branch  TYPE j_1bbranch-branch,
      name1   TYPE j_1bbranch-name,
    END OF ty_s_alv.

TYPES: ty_t_alv TYPE STANDARD TABLE OF ty_s_alv.

DATA: tl_alv TYPE ty_t_alv,
      tl_fieldcat TYPE slis_t_fieldcat_alv.

DATA: wl_descricao TYPE sydes_desc.

DESCRIBE FIELD TL_ALV INTO wl_descricao.

DATA: vl_name     TYPE ddobjname,
      vl_idx_help TYPE i.

LOOP AT wl_descricao-types INTO DATA(wl_type)
                            WHERE idx_name > 0.

  READ TABLE wl_descricao-names INTO DATA(wl_name)
                                 INDEX wl_type-idx_name.

  IF sy-subrc EQ 0.
    APPEND INITIAL LINE TO tl_fieldcat ASSIGNING FIELD-SYMBOL(<fieldcat>).
*    <fieldcat>-fieldname    = wl_name-name.
*    <fieldcat>-intlen       = wl_name-continue.
*    <fieldcat>-outputlen    = wl_name-output_length.
*    <fieldcat>-decimals_out = wl_name-decimals.
*    <fieldcat>-inttype      = wl_name-type.

    IF wl_type-idx_help_id > 0.
      CLEAR: vl_name.
      vl_idx_help = wl_type-idx_help_id.
      DO.
*        READ TABLE wl_descricao-names INTO wl_name_name INDEX wl_type-idx_help_id.
*        vl_name = vl_name && wl_name-name.
        CONCATENATE vl_name wl_name-name INTO vl_name.
        IF wl_name-continue EQ ' '.
          EXIT.
          CLEAR: wl_name.
        ENDIF.
        ADD 1 TO vl_idx_help.
        CLEAR: wl_name.
      ENDDO.

      SPLIT vl_name AT '-' INTO TABLE DATA(tl_split).
      DATA(vl_tabname) = tl_split[ 1 ].
      DATA(vl_fieldname) = tl_split[ 2 ].

*      SELECT SINGLE rollname


*      SELECT SINGLE ROLLNAME, ddtext, reptext, scrtext_s, scrtext_m, scrtext_1
*        FROM dd04t
*        INTO TABLE @DATA(tl_dd04t)
*          WHERE rollname EQ @vl_name
*          AND   ddlanguage EQ @sy-langu.
    ENDIF.
  ENDIF.

ENDLOOP.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
*   I_CALLBACK_PROGRAM                = ' '
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
   IT_FIELDCAT                       = tl_fieldcat
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
*   O_PREVIOUS_SRAL_HANDLER           =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    t_outtab                          = tl_alv
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
          .
IF sy-subrc <> 0.
  MESSAGE: 'Deu erro no grid display' TYPE 'I' DISPLAY LIKE 'E'.
ENDIF.