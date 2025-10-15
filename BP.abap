*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_BP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_bp NO STANDARD PAGE HEADING.

TABLES: but000.

" Tipos Estrutura
TYPES: BEGIN OF ty_s_but000,
         partner      TYPE but000-partner, "Business Partner Number
         partner_guid TYPE but000-partner_guid, "Business Partner GUID
       END   OF ty_s_but000.

TYPES: BEGIN OF ty_s_cust,
         partner_guid TYPE cvi_cust_link-partner_guid, "Business Partner GUID
         customer     TYPE cvi_cust_link-customer, "Customer Number
       END   OF ty_s_cust.

TYPES: BEGIN OF ty_s_vend,
         partner_guid TYPE cvi_vend_link-partner_guid, "Business Partner GUID
         vendor       TYPE cvi_vend_link-vendor, "Account Number of Supplier
       END   OF ty_s_vend.

TYPES: BEGIN OF ty_s_bp,
         partner  TYPE but000-partner,
         customer TYPE cvi_cust_link-customer,
         vendor   TYPE cvi_vend_link-vendor,
         status   TYPE icon_d,
       END OF ty_s_bp.

" Definição de Tipo de Tabela
TYPES: ty_t_but000 TYPE SORTED TABLE OF ty_s_but000 WITH UNIQUE KEY partner,
       ty_t_cust   TYPE SORTED TABLE OF ty_s_cust   WITH UNIQUE KEY partner_guid,
       ty_t_vend   TYPE SORTED TABLE OF ty_s_vend   WITH UNIQUE KEY partner_guid,
       ty_t_bp     TYPE SORTED TABLE OF ty_s_bp     WITH UNIQUE KEY partner,
       ty_t_alv    TYPE STANDARD TABLE OF ty_s_bp   WITH NON-UNIQUE KEY partner.

START-OF-SELECTION.

  " Declaração do field symbol pro BUT000
*FIELD-SYMBOLS: <but> TYPE ty_s_but000.

  " Declaração das tabelas internas
  DATA: tl_but000 TYPE ty_t_but000,
        tl_cust   TYPE ty_t_cust,
        tl_vend   TYPE ty_t_vend,
        tl_bp     TYPE ty_t_bp,
        tl_alv    TYPE ty_t_alv.

  " Declaração das work areas
  DATA: wl_cust   TYPE ty_s_cust,
        wl_vend   TYPE ty_s_vend,
        wl_bp     TYPE ty_s_bp,
        wl_but000 TYPE ty_s_but000.

  " Trazer os dados selecionados de cada tabela (3 select)
  " but000
  SELECT partner partner_guid
    FROM but000
    INTO CORRESPONDING FIELDS OF TABLE tl_but000.

  IF tl_but000[] IS NOT INITIAL.
    " cust
    SELECT partner_guid customer
      FROM cvi_cust_link
      INTO TABLE tl_cust
      FOR ALL ENTRIES IN tl_but000
        WHERE partner_guid EQ tl_but000-partner_guid.

    " vend
    SELECT partner_guid vendor
      FROM cvi_vend_link
      INTO TABLE tl_vend
      FOR ALL ENTRIES IN tl_but000
        WHERE partner_guid EQ tl_but000-partner_guid.
  ENDIF.

  " Buscar dados correspondentes em vend e cust presentes em but. IF TRUE
  LOOP AT tl_but000 INTO wl_but000.
    " Atribui o campo à work area de bp qnd achar a igualdade
    READ TABLE tl_cust INTO wl_cust WITH TABLE KEY partner_guid = wl_but000-partner_guid.
    IF sy-subrc EQ 0.
      wl_bp-customer = wl_cust-customer.
    ENDIF.

    " Atribui o campo à work area de bp qnd achar a igualdade
    READ TABLE tl_vend INTO wl_vend WITH TABLE KEY partner_guid = wl_but000-partner_guid.
    IF sy-subrc EQ 0.
      wl_bp-vendor = wl_vend-vendor.
    ENDIF.

    " Atribui o campo que já está dentro do loop a work area
    wl_bp-partner = wl_but000-partner.

    "PS: verificação pra adicionar o ícone de OKAY caso tenha vendor e customer
    IF wl_bp-customer  IS NOT INITIAL
      AND wl_bp-vendor IS NOT INITIAL.
      wl_bp-status = icon_okay.
    ENDIF.

      " Finalmente atribui a work area na tabela
      INSERT wl_bp INTO TABLE tl_bp.

      CLEAR wl_bp.

  ENDLOOP.

  tl_alv[] = tl_bp[].

  " Impressão da tl_bp com ALV
  DATA: tl_fieldcat TYPE slis_t_fieldcat_alv.

  DATA: wl_fieldcat TYPE slis_fieldcat_alv.

  wl_fieldcat-fieldname = 'PARTNER'.
  wl_fieldcat-seltext_s = 'Part.'.
  wl_fieldcat-seltext_m = 'Partner'.
  wl_fieldcat-seltext_l = 'Código Partner'.
  APPEND wl_fieldcat TO tl_fieldcat.
  CLEAR wl_fieldcat.

  wl_fieldcat-fieldname = 'CUSTOMER'.
  wl_fieldcat-rollname = 'KUNNR'.
  APPEND wl_fieldcat TO tl_fieldcat.
  CLEAR wl_fieldcat.

  wl_fieldcat-fieldname = 'VENDOR'.
  wl_fieldcat-rollname = 'LIFNR'.
  APPEND wl_fieldcat TO tl_fieldcat.
  CLEAR wl_fieldcat.

  wl_fieldcat-fieldname = 'STATUS'.
  wl_fieldcat-rollname = 'ICON_D'.
  wl_fieldcat-icon = abap_true.           "ps: pode usar 'X' que tbm significa TRUE
  wl_fieldcat-seltext_s = 'Sts.BP'.
  wl_fieldcat-seltext_m = 'Status BP'.
  wl_fieldcat-seltext_l = 'Status Business Partner'.
  APPEND wl_fieldcat TO tl_fieldcat.
  CLEAR wl_fieldcat.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
*     I_CALLBACK_PROGRAM                = ' '
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
*     IS_LAYOUT   =
      it_fieldcat = tl_fieldcat
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT     =
*     IT_FILTER   =
*     IS_SEL_HIDE =
*     I_DEFAULT   = 'X'
*     I_SAVE      = ' '
*     IS_VARIANT  =
*     IT_EVENTS   =
*     IT_EVENT_EXIT                     =
*     IS_PRINT    =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER           =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab    = tl_alv
* EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS      = 2
    .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.