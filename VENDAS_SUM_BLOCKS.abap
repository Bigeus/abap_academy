*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_VENDAS_SUM_BLOCKS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0SIMOEV_R_VENDAS_SUM_BLOCKS.

TABLES: ztt0simoev_tm_v1.

*--------------------------------------------------------------------*
* Tipos de Estrutura para Work Areas
*--------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_s_detalhado,
    nro        TYPE ztt0simoev_tm_v1-nro,
    item       TYPE ztt0simoev_tm_v1-item,
    matnr      TYPE ztt0simoev_tm_v1-matnr,
    maktx      TYPE ztt0simoev_tm_v1-maktx,
    data_venda TYPE ztt0simoev_tm_v1-data_venda,
    bukrs      TYPE ztt0simoev_tm_v1-bukrs,
    branch     TYPE ztt0simoev_tm_v1-branch,
    kunnr      TYPE ztt0simoev_tm_v1-kunnr,
    valor      TYPE ztt0simoev_tm_v1-valor,
    unv        TYPE ztt0simoev_tm_v1-unv,
    qtd        TYPE ztt0simoev_tm_v1-qtd,
  END OF ty_s_detalhado.

TYPES:
  BEGIN OF ty_s_sum_filial,
    bukrs  TYPE ztt0simoev_tm_v1-bukrs,
    branch TYPE ztt0simoev_tm_v1-branch,
    valor  TYPE ztt0simoev_tm_v1-valor,
  END OF ty_s_sum_filial.

TYPES:
  BEGIN OF ty_s_sum_material,
    matnr TYPE ztt0simoev_tm_v1-matnr,
    maktx    TYPE ztt0simoev_tm_v1-maktx,
    valor    TYPE ztt0simoev_tm_v1-valor,
  END OF ty_s_sum_material.

TYPES:
  BEGIN OF ty_s_sum_cliente,
    kunnr TYPE ztt0simoev_tm_v1-kunnr,
    valor TYPE ztt0simoev_tm_v1-valor,
  END OF ty_s_sum_cliente.

*--------------------------------------------------------------------*
* Tipos de Categoria de Tabelas para Tabela Interna
*--------------------------------------------------------------------*
TYPES: ty_t_detalhado    TYPE SORTED TABLE OF ty_s_detalhado    WITH UNIQUE KEY nro item,     "armazenar os dados brutos"
       ty_t_sum_filial   TYPE SORTED TABLE OF ty_s_sum_filial   WITH UNIQUE KEY bukrs branch, "sumarizar os dados por: filial"
       ty_t_sum_material TYPE SORTED TABLE OF ty_s_sum_material WITH UNIQUE KEY matnr maktx, "sumarizar os dados por: material"
       ty_t_sum_cliente  TYPE SORTED TABLE OF ty_s_sum_cliente  WITH UNIQUE KEY kunnr,         "sumarizar os dados por: cliente"
       ty_t_alv          TYPE STANDARD TABLE OF ty_s_detalhado.

*--------------------------------------------------------------------*
* Declaração das Tabelas Internas
*--------------------------------------------------------------------*
DATA: t_detalhado    TYPE ty_t_detalhado,
      t_sum_filial   TYPE ty_t_sum_filial,
      t_sum_material TYPE ty_t_sum_material,
      t_sum_cliente  TYPE ty_t_sum_cliente,
      t_fieldcat     TYPE slis_t_fieldcat_alv,
      t_alv          TYPE ty_t_alv.

*--------------------------------------------------------------------*
* Declaração das Work Areas
*--------------------------------------------------------------------*
DATA: w_detalhado    TYPE ty_s_detalhado,
      w_sum_filial   TYPE ty_s_sum_filial,
      w_sum_material TYPE ty_s_sum_material,
      w_sum_cliente  TYPE ty_s_sum_cliente,
      w_fieldcat     TYPE slis_fieldcat_alv.

*--------------------------------------------------------------------*
* Campo de seleção
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS: s_bukrs  FOR ztt0simoev_tm_v1-bukrs NO-EXTENSION NO INTERVALS,
                  s_branch FOR ztt0simoev_tm_v1-branch NO INTERVALS,
                  s_nro    FOR ztt0simoev_tm_v1-nro NO INTERVALS,
                  s_data   FOR ztt0simoev_tm_v1-data_venda,
                  s_kunnr  FOR ztt0simoev_tm_v1-kunnr NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.
  PARAMETERS: p_detalh RADIOBUTTON GROUP grp DEFAULT 'X',
              p_filial RADIOBUTTON GROUP grp,
              p_materi RADIOBUTTON GROUP grp,
              p_client RADIOBUTTON GROUP grp.
SELECTION-SCREEN END OF BLOCK b02.

*--------------------------------------------------------------------*
* Criar o FIELDCAT pra todos os campos
*--------------------------------------------------------------------*
CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
  EXPORTING
    i_program_name         = sy-repid
    i_internal_tabname     = 'T_DETALHADO'
    i_structure_name       = 'ZTT0SIMOEV_TM_V1'
    i_inclname             = sy-repid
  CHANGING
    ct_fieldcat            = t_fieldcat
  EXCEPTIONS
    inconsistent_interface = 1
    program_error          = 2
    OTHERS                 = 3.
IF sy-subrc <> 0.
  MESSAGE: 'Algo deu ruim n sei' TYPE 'S' DISPLAY LIKE 'E'.
ENDIF.

*--------------------------------------------------------------------*
* Retirar o mandante      EDIT: nem precisava, a função MERGE já exclui sozinha
*--------------------------------------------------------------------*
READ TABLE t_fieldcat INTO w_fieldcat WITH KEY fieldname = 'MANDT'.
IF sy-subrc EQ 0.
  w_fieldcat-tech = 'X'.
  MESSAGE: 'Conseguiu tirar o mandante' TYPE 'S' DISPLAY LIKE 'I'.
ELSE.
  MESSAGE: 'Deu errado não tirou o mandante' TYPE 'S' DISPLAY LIKE 'E'.
ENDIF.

*--------------------------------------------------------------------*
* Seleção dos dados
*--------------------------------------------------------------------*
START-OF-SELECTION.

  FIELD-SYMBOLS: <clean> TYPE slis_fieldcat_alv.

  CASE 'X'.
    WHEN p_detalh.

      SELECT nro item matnr maktx data_venda bukrs branch kunnr valor unv qtd
            FROM ztt0simoev_tm_v1
            INTO TABLE t_detalhado
            WHERE bukrs        IN s_bukrs
              AND branch       IN s_branch
              AND nro          IN s_nro
              AND data_venda   IN s_data
              AND kunnr        IN s_kunnr.

      t_alv[] = t_detalhado[].

      " IMPRESSÃO
      PERFORM present_alv USING t_alv.

      "*****************************************************************
    WHEN p_filial.
      SELECT bukrs branch SUM( valor ) AS valor
        FROM ztt0simoev_tm_v1
        INTO TABLE t_sum_filial
        WHERE bukrs        IN s_bukrs
          AND branch       IN s_branch
        GROUP BY bukrs branch.

      " Limpando o fieldcat para cada caso
      LOOP AT t_fieldcat ASSIGNING <clean> WHERE fieldname = 'NRO'
                                              OR fieldname = 'ITEM'
                                              OR fieldname = 'MATNR'
                                              OR fieldname = 'MAKTX'
                                              OR fieldname = 'DATA_VENDA'
*                                             OR fieldname = 'BUKRS'
*                                             OR fieldname = 'BRANCH'
                                              OR fieldname = 'KUNNR'
*                                             OR fieldname = 'VALOR'
                                              OR fieldname = 'UNV'
                                              OR fieldname = 'QTD'.
        <clean>-tech = 'X'.
      ENDLOOP.

*     t_alv[] = t_sum_filial[].         " Dessa maneira não dá pelos campos serem diferentes
      MOVE-CORRESPONDING t_sum_filial[] TO t_alv[].

      UNASSIGN <clean>.

      " IMPRESSÃO:
      PERFORM present_alv USING t_alv.

      "*****************************************************************
    WHEN p_materi.
      SELECT matnr maktx SUM( valor ) AS valor
        FROM ztt0simoev_tm_v1
        INTO TABLE t_sum_material
        GROUP BY matnr maktx.

      LOOP AT t_fieldcat ASSIGNING <clean> WHERE fieldname = 'NRO'
                                              OR fieldname = 'ITEM'
*                                             OR fieldname = 'MATNR'
                                              OR fieldname = 'MATERIAL'
*                                             OR fieldname = 'MAKTX'
                                              OR fieldname = 'DATA_VENDA'
                                              OR fieldname = 'BUKRS'
                                              OR fieldname = 'BRANCH'
                                              OR fieldname = 'KUNNR'
*                                             OR fieldname = 'VALOR'
                                              OR fieldname = 'UNV'
                                              OR fieldname = 'QTD'.
        <clean>-tech = 'X'.
      ENDLOOP.

*     t_alv[] = t_sum_material[].
      MOVE-CORRESPONDING t_sum_material[] TO t_alv[].

      UNASSIGN <clean>.

*  BREAK-POINT.

      " IMPRESSÃO:
      PERFORM present_alv USING t_alv.

      "*****************************************************************
    WHEN p_client.
      SELECT kunnr SUM( valor )
        FROM ztt0simoev_tm_v1
        INTO TABLE t_sum_cliente
        WHERE kunnr IN s_kunnr
        GROUP BY kunnr.

      LOOP AT t_fieldcat ASSIGNING <clean> WHERE fieldname = 'NRO'
                                              OR fieldname = 'ITEM'
                                              OR fieldname = 'MATNR'
                                              OR fieldname = 'MAKTX'
                                              OR fieldname = 'DATA_VENDA'
                                              OR fieldname = 'BUKRS'
                                              OR fieldname = 'BRANCH'
*                                             OR fieldname = 'KUNNR'
*                                             OR fieldname = 'VALOR'
                                              OR fieldname = 'UNV'
                                              OR fieldname = 'QTD'.
        <clean>-tech = 'X'.
      ENDLOOP.

*     t_alv[] = t_sum_material[].
      MOVE-CORRESPONDING t_sum_cliente[] TO t_alv[].

      UNASSIGN <clean>.

      " IMPRESSÃO:
      PERFORM present_alv USING t_alv.

      "*****************************************************************
    WHEN OTHERS.
  ENDCASE.
*&---------------------------------------------------------------------*
*& Form present_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM present_alv USING t_alv TYPE ty_t_alv.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = t_fieldcat
    TABLES
      t_outtab           = t_alv
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE: 'Erro no alv do detalhado' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.