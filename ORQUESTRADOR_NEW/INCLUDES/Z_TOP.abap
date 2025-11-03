*&---------------------------------------------------------------------*
*& Include          ZTT0SIMOEV_I_ORQUESTRADOR_TOP
*&---------------------------------------------------------------------*

" Variáveis Globais
DATA: vg_ok_code TYPE sy-ucomm.

" Classes Locais - Declaração
CLASS lcl_handler_tree_9000 DEFINITION.

  PUBLIC SECTION.

  METHODS: node_double_click FOR EVENT node_double_click OF cl_simple_tree_model
    IMPORTING
      node_key.

ENDCLASS.

" Objetos Globais
DATA: o_cont_9000         TYPE REF TO cl_gui_custom_container,
      o_split_9000        TYPE REF TO cl_gui_splitter_container,
      o_cont_9000_tree    TYPE REF TO cl_gui_container,
      o_tree_9000         TYPE REF TO cl_simple_tree_model,
      o_handler_tree_9000 TYPE REF TO lcl_handler_tree_9000,
      o_cont_9000_alv     TYPE REF TO cl_gui_container,
      o_alv_9000          TYPE REF TO cl_gui_alv_grid.

" Classes Locais - Implementação
CLASS lcl_handler_tree_9000 IMPLEMENTATION.

  METHOD: node_double_click.

    DATA: tl_fieldcat TYPE lvc_t_fcat,
          tl_sp       TYPE TABLE OF ZTBSICORC_SP_PAR.

    SELECT *
      FROM ZTBSICORC_SP_PAR
      INTO TABLE tl_sp.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
     EXPORTING
*       I_BUFFER_ACTIVE              =
       I_STRUCTURE_NAME             = 'ZTBSICORC_SP_PAR'
*       I_CLIENT_NEVER_DISPLAY       = 'X'
*       I_BYPASSING_BUFFER           =
*       I_INTERNAL_TABNAME           =
      CHANGING
        ct_fieldcat                  = tl_fieldcat
     EXCEPTIONS
       INCONSISTENT_INTERFACE       = 1
       PROGRAM_ERROR                = 2
       OTHERS                       = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    CREATE OBJECT o_alv_9000
      EXPORTING
*        i_shellstyle            = 0                " Control Style
*        i_lifetime              =                  " Lifetime
        i_parent                = o_cont_9000_alv   " Parent Container
*        i_appl_events           = space            " Register Events as Application Events
*        i_parentdbg             =                  " Internal, Do not Use
*        i_applogparent          =                  " Container for Application Log
*        i_graphicsparent        =                  " Container for Graphics
*        i_name                  =                  " Name
*        i_fcat_complete         = space            " Boolean Variable (X=True, Space=False)
*        o_previous_sral_handler =
      EXCEPTIONS
        error_cntl_create       = 1                " Error when creating the control
        error_cntl_init         = 2                " Error While Initializing Control
        error_cntl_link         = 3                " Error While Linking Control
        error_dp_create         = 4                " Error While Creating DataProvider Control
        others                  = 5.
    IF SY-SUBRC <> 0.
      MESSAGE: 'Deu ruim criando o o_alv_9000' TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.

    o_alv_9000->set_table_for_first_display(
*      EXPORTING
*        i_buffer_active               =                  " Buffering Active
*        i_bypassing_buffer            =                  " Switch Off Buffer
*        i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
*        i_structure_name              =                  " Internal Output Table Structure Name
*        is_variant                    =                  " Layout
*        i_save                        =                  " Save Layout
*        i_default                     = 'X'              " Default Display Variant
*        is_layout                     =                  " Layout
*        is_print                      =                  " Print Control
*        it_special_groups             =                  " Field Groups
*        it_toolbar_excluding          =                  " Excluded Toolbar Standard Functions
*        it_hyperlink                  =                  " Hyperlinks
*        it_alv_graphics               =                  " Table of Structure DTC_S_TC
*        it_except_qinfo               =                  " Table for Exception Quickinfo
*        ir_salv_adapter               =                  " Interface ALV Adapter
      CHANGING
        it_outtab                     = tl_sp                 " Output Table
        it_fieldcatalog               = tl_fieldcat                 " Field Catalog
*        it_sort                       =                  " Sort Criteria
*        it_filter                     =                  " Filter Criteria
*      EXCEPTIONS
*        invalid_parameter_combination = 1                " Wrong Parameter
*        program_error                 = 2                " Program Errors
*        too_many_lines                = 3                " Too many Rows in Ready for Input Grid
*        others                        = 4
    ).
    IF SY-SUBRC <> 0.
      MESSAGE: 'Deu ruim no set_table_for_first_display' TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.

  ENDMETHOD.

ENDCLASS.