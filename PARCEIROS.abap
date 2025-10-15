*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_PARCEIROS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_parceiros.

TABLES: but000, lfa1, kna1.


" Tipos para apresentação de Dados
***************           ZTT0SIMOEV_S_PARCEIRO_NEGOC
***************           ZTT0SIMOEV_S_CLIENTE
***************           ZTT0SIMOEV_S_FORNECEDOR

*--------------------------------------------------------------------*
* Tipos de Categoria de Tabela para ALV
*--------------------------------------------------------------------*
TYPES: ty_t_parceiron TYPE STANDARD TABLE OF ztt0simoev_s_parceiro_negoc.   "WITH UNIQUE KEY partner status kunnr.
TYPES: ty_t_cliente   TYPE STANDARD TABLE OF ztt0simoev_s_cliente        ."  WITH UNIQUE KEY kunnr partner.
TYPES: ty_t_forn      TYPE STANDARD TABLE OF ztt0simoev_s_fornecedor      ." WITH UNIQUE KEY lifnr partner.
*TYPES: ty_t_alv       TYPE STANDARD TABLE OF ztt0simoev_s_parceiro_negoc WITH DEFAULT KEY.
*TYPES: ty_t_alv2      TYPE STANDARD TABLE OF ztt0simoev_s_fornencedor         WITH DEFAULT KEY.
*TYPES: ty_t_alv3      TYPE STANDARD TABLE OF ztt0simoev_s_cliente        WITH DEFAULT KEY.

*--------------------------------------------------------------------*
* Declaração de Tipo de Estrutura para processamento interno
*--------------------------------------------------------------------*
TYPES: BEGIN OF ty_s_but000,
         partner      TYPE but000-partner,
         partner_guid TYPE but000-partner_guid,
       END OF ty_s_but000.

TYPES: ty_t_but000 TYPE STANDARD TABLE OF ty_s_but000 WITH DEFAULT KEY.

TYPES: BEGIN OF ty_s_cust_link,
         partner_guid TYPE bu_partner_guid,
         customer     TYPE kunnr,
       END OF ty_s_cust_link.

TYPES: ty_t_cust_link TYPE STANDARD TABLE OF ty_s_cust_link WITH DEFAULT KEY.

TYPES: BEGIN OF ty_s_vend_link,
         partner_guid TYPE bu_partner_guid,
         vendor       TYPE lifnr,
       END OF ty_s_vend_link.

TYPES: ty_t_vend_link TYPE STANDARD TABLE OF ty_s_vend_link WITH DEFAULT KEY.

*TYPES: BEGIN OF ty_s_kna1,
*         kunnr TYPE kna1-kunnr,
*         name1 TYPE kna1-name1,
*       END OF ty_s_kna1.
TYPES: BEGIN OF ty_s_kna1,
         kunnr TYPE kna1-kunnr, "Customer Number
         name1 TYPE kna1-name1, "Name 1
         land1 TYPE kna1-land1, "Country Key
         ort01 TYPE kna1-ort01, "City
         pstlz TYPE kna1-pstlz, "Postal Code
         regio TYPE kna1-regio, "Region (State, Province, County)
         sortl TYPE kna1-sortl, "Sort field
         stras TYPE kna1-stras, "Street and House Number
         adrnr TYPE kna1-adrnr, "Address
         mcod1 TYPE kna1-mcod1, "Search term for matchcode search
         mcod3 TYPE kna1-mcod3, "Search term for matchcode search
       END   OF ty_s_kna1.

TYPES: ty_t_kna1 TYPE SORTED TABLE OF ty_s_kna1 WITH UNIQUE KEY kunnr.

TYPES: BEGIN OF ty_s_lfa1,
         lifnr TYPE lfa1-lifnr,
         name1 TYPE lfa1-name1,
         land1 TYPE lfa1-land1,
         ort01 TYPE lfa1-ort01,
         pstlz TYPE lfa1-pstlz,
         regio TYPE lfa1-regio,
         sortl TYPE lfa1-sortl,
         stras TYPE lfa1-stras,
         adrnr TYPE lfa1-adrnr,
         mcod1 TYPE lfa1-mcod1,
         mcod3 TYPE lfa1-mcod3,
       END OF ty_s_lfa1.

TYPES: ty_t_lfa1 TYPE SORTED TABLE OF ty_s_lfa1 WITH UNIQUE KEY lifnr.

TYPES: BEGIN OF ty_s_adr6,
         addrnumber TYPE adr6-addrnumber,
         smtp_addr  TYPE adr6-smtp_addr,
       END OF ty_s_adr6.

TYPES: ty_t_adr6 TYPE SORTED TABLE OF ty_s_adr6 WITH UNIQUE KEY addrnumber.
*--------------------------------------------------------------------*
* Declaração de Estruturas
*--------------------------------------------------------------------*
DATA: wg_parceiron TYPE ztt0simoev_s_parceiro_negoc,
      wg_cliente   TYPE ztt0simoev_s_cliente,
      wg_forn      TYPE ztt0simoev_s_fornecedor.

DATA: wg_but000    TYPE ty_s_but000,
      wg_cust_link TYPE ty_s_cust_link,
      wg_vend_link TYPE ty_s_vend_link,
      wg_kna1      TYPE ty_s_kna1,
      wg_lfa1      TYPE ty_s_lfa1,
      wg_adr6      TYPE ty_s_adr6.

*--------------------------------------------------------------------*
* Declaração de Tabelas internas
*--------------------------------------------------------------------*
DATA: tg_parceiron TYPE ty_t_parceiron,
      tg_cliente   TYPE ty_t_cliente,
      tg_forn      TYPE ty_t_forn.

DATA: tg_but000    TYPE ty_t_but000,
      tg_cust_link TYPE ty_t_cust_link,
      tg_vend_link TYPE ty_t_vend_link,
      tg_kna1      TYPE ty_t_kna1,
      tg_lfa1      TYPE ty_t_lfa1,
*      tg_alv       TYPE ty_t_alv,
*      tg_alv2      TYPE ty_t_alv2,
*      tg_alv3      TYPE ty_t_alv3,
      tg_fcat      TYPE slis_t_fieldcat_alv,
      tg_adr6      TYPE ty_t_adr6.

DATA: vg_alv_struct TYPE c LENGTH 30.

DATA: tg_kunnr TYPE STANDARD TABLE OF kna1-kunnr WITH DEFAULT KEY,
      tg_lifnr TYPE STANDARD TABLE OF lfa1-lifnr WITH DEFAULT KEY.

DATA: tg_guid TYPE STANDARD TABLE OF bu_partner_guid WITH DEFAULT KEY.

FIELD-SYMBOLS: <alv> TYPE STANDARD TABLE.


*--------------------------------------------------------------------*
* Tela de seleção
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS s_partn     FOR but000-partner NO INTERVALS.
  SELECT-OPTIONS s_lifnr     FOR lfa1-lifnr     NO INTERVALS.
  SELECT-OPTIONS s_kunnr     FOR kna1-kunnr     NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.
  PARAMETERS: p_bp RADIOBUTTON GROUP grp,
              p_fn RADIOBUTTON GROUP grp,
              p_cl RADIOBUTTON GROUP grp.
SELECTION-SCREEN END OF BLOCK b02.

*--------------------------------------------------------------------*
* START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

  CASE 'X'.

    WHEN p_bp.

      " Buscar parceiros (BUT000)

      SELECT partner partner_guid
      FROM but000
      INTO TABLE tg_but000
      WHERE partner IN s_partn.

******************************************************
      " Validação Ancorada
      IF tg_but000 IS INITIAL.
        MESSAGE: 'Procura não deu resultados' TYPE 'S' DISPLAY LIKE 'E'.
        STOP.
      ENDIF.

      " Buscar vínculos com clientes
      SELECT partner_guid customer
        FROM cvi_cust_link
        INTO TABLE tg_cust_link
        FOR ALL ENTRIES IN tg_but000
        WHERE partner_guid EQ tg_but000-partner_guid
         AND customer IN s_kunnr.

      SELECT kunnr name1
        FROM kna1
        INTO CORRESPONDING FIELDS OF TABLE tg_kna1
        FOR ALL ENTRIES IN tg_cust_link
        WHERE kunnr IN s_kunnr
        AND   kunnr EQ tg_cust_link-customer.

      " Buscar vínculos com fornecedores
      SELECT partner_guid vendor
        FROM cvi_vend_link
        INTO TABLE tg_vend_link
        FOR ALL ENTRIES IN tg_but000
        WHERE vendor       IN s_lifnr
        AND   partner_guid EQ tg_but000-partner_guid.

      SELECT lifnr name1
          FROM lfa1
          INTO CORRESPONDING FIELDS OF TABLE tg_lfa1
          FOR ALL ENTRIES IN tg_vend_link
          WHERE lifnr IN s_lifnr
          AND   lifnr EQ tg_vend_link-vendor.

************************************************************************************
      " Montar tabela final
      LOOP AT tg_but000 INTO wg_but000.

        CLEAR: wg_parceiron.
        "PARTNER"
        wg_parceiron-partner = wg_but000-partner.

        " Buscar se tem vínculo com cliente
        SORT tg_cust_link BY partner_guid.
        READ TABLE tg_cust_link INTO wg_cust_link WITH KEY partner_guid = wg_but000-partner_guid BINARY SEARCH.
        IF sy-subrc = 0.
          "KUNNR - CUSTOMER"
          wg_parceiron-kunnr = wg_cust_link-customer.

          READ TABLE tg_kna1 INTO wg_kna1 WITH TABLE KEY kunnr = wg_cust_link-customer.
          IF sy-subrc = 0.
            "NAMEK"
            wg_parceiron-namek = wg_kna1-name1.
          ENDIF.
        ENDIF.
********************
        " Buscar se tem vínculo com fornecedor
        SORT tg_vend_link BY partner_guid.
        READ TABLE tg_vend_link INTO wg_vend_link WITH KEY partner_guid = wg_but000-partner_guid BINARY SEARCH.
        IF sy-subrc = 0.
          "LINFR - VENDOR"
          wg_parceiron-lifnr = wg_vend_link-vendor.

          READ TABLE tg_lfa1 INTO wg_lfa1 WITH TABLE KEY lifnr = wg_vend_link-vendor.
          IF sy-subrc = 0.
            "NAMEL - NAME1"
            wg_parceiron-namel = wg_lfa1-name1.
          ENDIF.
        ENDIF.

***********************************************************************
        " >>> VALIDAÇÃO FINAL DE FILTRO DA TELA <<<
        IF ( s_kunnr[] IS NOT INITIAL AND wg_parceiron-kunnr IS INITIAL )
        OR ( s_lifnr[] IS NOT INITIAL AND wg_parceiron-lifnr IS INITIAL ).
          CONTINUE. " pula, não satisfaz o filtro da tela
        ENDIF.

        " Definir status
        IF wg_parceiron-kunnr IS NOT INITIAL AND wg_parceiron-lifnr IS NOT INITIAL.
          wg_parceiron-status = icon_complete.
        ELSEIF wg_parceiron-kunnr IS NOT INITIAL.
          wg_parceiron-status = icon_activity.
        ELSEIF wg_parceiron-lifnr IS NOT INITIAL.
          wg_parceiron-status = icon_activity.
        ELSE.
          wg_parceiron-status = icon_initial.
        ENDIF.

        APPEND wg_parceiron TO tg_parceiron.

      ENDLOOP.

      " Exibir os dados
      ASSIGN tg_parceiron TO <alv>.
      vg_alv_struct = 'ZTT0SIMOEV_S_PARCEIRO_NEGOC'.

***************************************************************
***************************************************************
***************************************************************

    WHEN p_fn.
      "VEND LINK
      SELECT partner_guid vendor
        FROM cvi_vend_link
        INTO TABLE tg_vend_link
        WHERE vendor IN s_lifnr.

      " Validação Ancorada
      IF tg_vend_link IS INITIAL.
        RETURN.
      ENDIF.

      "BUT000
      " Buscar parceiros que têm vínculo fornecedor
      SELECT partner partner_guid
        FROM but000
        INTO TABLE tg_but000
        FOR ALL ENTRIES IN tg_vend_link
        WHERE partner_guid EQ tg_vend_link-partner_guid
        AND   partner      IN s_partn.

      "LFA1
      " Buscar dados fornecedores para exibir
      SELECT lifnr name1 land1 ort01 pstlz regio sortl stras adrnr mcod1 mcod3
        FROM lfa1
        INTO CORRESPONDING FIELDS OF TABLE tg_lfa1
        FOR ALL ENTRIES IN tg_vend_link
        WHERE lifnr EQ tg_vend_link-vendor.

      " ADR6
      SELECT addrnumber smtp_addr
        FROM adr6
        INTO TABLE tg_adr6
        FOR ALL ENTRIES IN tg_lfa1
        WHERE addrnumber EQ tg_lfa1-adrnr.

*******************************************************************************
      LOOP AT tg_but000 INTO wg_but000.

        CLEAR wg_forn.
        "Pegando Campos da but000
        wg_forn-partner = wg_but000-partner.

        " Buscar vínculo cliente para este parceiro
        SORT tg_vend_link BY partner_guid.
        READ TABLE tg_vend_link INTO wg_vend_link WITH KEY partner_guid = wg_but000-partner_guid BINARY SEARCH.
        IF sy-subrc = 0.
          " Pegando os campos da cust_link
          wg_forn-lifnr = wg_vend_link-vendor.

          READ TABLE tg_lfa1 INTO wg_lfa1 WITH TABLE KEY lifnr = wg_vend_link-vendor.
          IF sy-subrc = 0.
            "Pegando Campos da kna1
            wg_forn-name1 = wg_lfa1-name1.
            wg_forn-land1 = wg_lfa1-land1.
            wg_forn-ort01 = wg_lfa1-ort01.
            wg_forn-pstlz = wg_lfa1-pstlz.
            wg_forn-regio = wg_lfa1-regio.
            wg_forn-sortl = wg_lfa1-sortl.
            wg_forn-stras = wg_lfa1-stras.
            wg_forn-mcod1 = wg_lfa1-mcod1.
            wg_forn-mcod3 = wg_lfa1-mcod3.
          ENDIF.
        ENDIF.

        " Buscar e-mail

        READ TABLE tg_adr6 ASSIGNING FIELD-SYMBOL(<adr6>) WITH TABLE KEY addrnumber = wg_lfa1-adrnr.
        IF sy-subrc = 0.
          wg_forn-smtp_addr = <adr6>-smtp_addr.
        ENDIF.

        APPEND wg_forn TO tg_forn.
      ENDLOOP.

      ASSIGN tg_forn TO <alv>.
      " Exibir os dados
      vg_alv_struct = 'ZTT0SIMOEV_S_FORNECEDOR'.
***************************************************************
***************************************************************
***************************************************************

    WHEN p_cl.
      "CUST LINK
      SELECT partner_guid customer
        FROM cvi_cust_link
        INTO TABLE tg_cust_link
        WHERE customer IN s_kunnr.

      "Validação Ancorada
      IF tg_cust_link IS INITIAL.
        RETURN.
      ENDIF.

      "BUT000
      " Buscar parceiros que têm vínculo cliente
      SELECT partner partner_guid
        FROM but000
        INTO TABLE tg_but000
        FOR ALL ENTRIES IN tg_cust_link
        WHERE partner_guid EQ tg_cust_link-partner_guid
        AND   partner      IN s_partn.

      "KNA1
      " Buscar dados clientes para exibir
      SELECT kunnr name1 land1 ort01 pstlz regio sortl stras adrnr mcod1 mcod3
        FROM kna1
        INTO CORRESPONDING FIELDS OF TABLE tg_kna1
        FOR ALL ENTRIES IN tg_cust_link
        WHERE kunnr EQ tg_cust_link-customer.

      " ADR6
      SELECT addrnumber smtp_addr
        FROM adr6
        INTO TABLE tg_adr6
        FOR ALL ENTRIES IN tg_kna1
        WHERE addrnumber EQ tg_kna1-adrnr.

*******************************************************************************
      LOOP AT tg_but000 INTO wg_but000.

        CLEAR wg_cliente.
        "Pegando Campos da but000
        wg_cliente-partner = wg_but000-partner.

        " Buscar vínculo cliente para este parceiro
        SORT tg_cust_link BY partner_guid.
        READ TABLE tg_cust_link INTO wg_cust_link WITH KEY partner_guid = wg_but000-partner_guid BINARY SEARCH.
        IF sy-subrc = 0.
          " Pegando os campos da cust_link
          wg_cliente-kunnr = wg_cust_link-customer.

          READ TABLE tg_kna1 INTO wg_kna1 WITH TABLE KEY kunnr = wg_cust_link-customer.
          IF sy-subrc = 0.
            "Pegando Campos da kna1
            wg_cliente-name1 = wg_kna1-name1.
            wg_cliente-land1 = wg_kna1-land1.
            wg_cliente-ort01 = wg_kna1-ort01.
            wg_cliente-pstlz = wg_kna1-pstlz.
            wg_cliente-regio = wg_kna1-regio.
            wg_cliente-sortl = wg_kna1-sortl.
            wg_cliente-stras = wg_kna1-stras.
            wg_cliente-mcod1 = wg_kna1-mcod1.
            wg_cliente-mcod3 = wg_kna1-mcod3.
          ENDIF.
        ENDIF.

        " Buscar e-mail
        READ TABLE tg_adr6 ASSIGNING FIELD-SYMBOL(<adr66>) WITH TABLE KEY addrnumber = wg_kna1-adrnr.
        IF sy-subrc = 0.
          wg_cliente-smtp_addr = <adr66>-smtp_addr.
        ENDIF.

        " Não inserir a work area com o nome 044494949494944
        IF wg_kna1-mcod3 = '044494949494944'.
          CONTINUE. " Pula essa iteração do loop
        ENDIF.

        APPEND wg_cliente TO tg_cliente.
      ENDLOOP.

      " Exibir os dados
      ASSIGN tg_cliente TO <alv>.
      vg_alv_struct = 'ZTT0SIMOEV_S_CLIENTE'.

  ENDCASE.


  PERFORM create_fieldcat USING vg_alv_struct.

  IF <alv> IS ASSIGNED.
    PERFORM present_alv.
  ELSE.
    MESSAGE 'Nenhum dado para exibir' TYPE 'S'.
  ENDIF.


*&---------------------------------------------------------------------*
*& Form create_fieldcat
*&---------------------------------------------------------------------*
FORM create_fieldcat USING vg_alv_struct.
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_structure_name       = vg_alv_struct
      i_inclname             = sy-repid
    CHANGING
      ct_fieldcat            = tg_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE: 'Deu ruim no merge' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.


  CASE 'X'.
    WHEN p_bp.
      READ TABLE tg_fcat ASSIGNING FIELD-SYMBOL(<fcat>) WITH KEY fieldname = 'PARTNER'.
      IF sy-subrc EQ 0.
        <fcat>-key = 'X'.
        <fcat>-hotspot = 'X'.
      ENDIF.

      READ TABLE tg_fcat ASSIGNING <fcat> WITH KEY fieldname = 'STATUS'.
      IF sy-subrc EQ 0.
        <fcat>-key = 'X'.
      ENDIF.

      READ TABLE tg_fcat ASSIGNING <fcat> WITH KEY fieldname = 'KUNNR'.
      IF sy-subrc EQ 0.
*        <fcat>-key = 'X'.
        <fcat>-hotspot = 'X'.
      ENDIF.

      READ TABLE tg_fcat ASSIGNING <fcat> WITH KEY fieldname = 'LIFNR'.
      IF sy-subrc EQ 0.
        <fcat>-hotspot = 'X'.
      ENDIF.

    WHEN p_fn.
      READ TABLE tg_fcat ASSIGNING <fcat> WITH KEY fieldname = 'PARTNER'.
      IF sy-subrc EQ 0.
        <fcat>-key = 'X'.
        <fcat>-hotspot = 'X'.
      ENDIF.

      READ TABLE tg_fcat ASSIGNING <fcat> WITH KEY fieldname = 'LIFNR'.
      IF sy-subrc EQ 0.
        <fcat>-key = 'X'.
        <fcat>-hotspot = 'X'.
      ENDIF.

    WHEN p_cl.
      READ TABLE tg_fcat ASSIGNING <fcat> WITH KEY fieldname = 'PARTNER'.
      IF sy-subrc EQ 0.
        <fcat>-key = 'X'.
        <fcat>-hotspot = 'X'.
      ENDIF.

      READ TABLE tg_fcat ASSIGNING <fcat> WITH KEY fieldname = 'KUNNR'.
      IF sy-subrc EQ 0.
        <fcat>-key = 'X'.
        <fcat>-hotspot = 'X'.
      ENDIF.
  ENDCASE.

  READ TABLE tg_fcat ASSIGNING <fcat> WITH KEY fieldname = 'STATUS'.
  IF sy-subrc EQ 0.
    <fcat>-icon = 'X'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form present_alv
*&---------------------------------------------------------------------*
FORM present_alv.

  DATA: wl_layout TYPE slis_layout_alv.

  wl_layout-zebra = 'X'.
  wl_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program        = sy-repid
      it_fieldcat               = tg_fcat
      is_layout                 = wl_layout
      i_callback_user_command   = 'USER_COMMAND'
      i_callback_pf_status_set  = 'SET_PF'
    TABLES
      t_outtab           = <alv>
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE: 'Deu ruim mostrando o alv' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
FORM set_pf USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'STATUS_RELATORIO'.

ENDFORM.
FORM user_command USING ucomm LIKE sy-ucomm
                        selfield TYPE slis_selfield.

DATA: vl_answer TYPE C.

IF ucomm EQ 'CREATE'.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question = 'Deseja criar um BP?'
      text_button_1 = 'Sim'
      text_button_2 = 'Não'
    IMPORTING
      answer        = vl_answer.
ELSE.

CASE selfield-fieldname.
  WHEN 'PARTNER'.
    SET PARAMETER ID 'BPA' FIELD selfield-value.
    CALL TRANSACTION 'BP' AND SKIP FIRST SCREEN.
  WHEN 'LIFNR'.
    SET PARAMETER ID 'LIF' FIELD selfield-value.
    CALL TRANSACTION 'XK03' AND SKIP FIRST SCREEN.

  WHEN 'KUNNR'.
    SET PARAMETER ID 'KUN' FIELD selfield-value.
    CALL TRANSACTION 'XD03' AND SKIP FIRST SCREEN.
ENDCASE.
ENDIF.

ENDFORM.