REPORT ztt0simoev_r_vendas NO STANDARD PAGE HEADING LINE-SIZE 500.

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
    material TYPE ztt0simoev_tm_v1-matnr,
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
       ty_t_sum_material TYPE SORTED TABLE OF ty_s_sum_material WITH UNIQUE KEY material maktx,"sumarizar os dados por: material"
       ty_t_sum_cliente  TYPE SORTED TABLE OF ty_s_sum_cliente  WITH UNIQUE KEY kunnr.         "sumarizar os dados por: cliente"

*--------------------------------------------------------------------*
* Declaração das Tabelas Internas
*--------------------------------------------------------------------*
DATA: t_detalhado    TYPE ty_t_detalhado,
      t_sum_filial   TYPE ty_t_sum_filial,
      t_sum_material TYPE ty_t_sum_material,
      t_sum_cliente  TYPE ty_t_sum_cliente.

*--------------------------------------------------------------------*
* Declaração das Work Areas
*--------------------------------------------------------------------*
DATA: w_detalhado    TYPE ty_s_detalhado,
      w_sum_filial   TYPE ty_s_sum_filial,
      w_sum_material TYPE ty_s_sum_material,
      w_sum_cliente  TYPE ty_s_sum_cliente.

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
* Cabeçalhos
*--------------------------------------------------------------------*
TOP-OF-PAGE.
  CASE 'X'.
    WHEN p_detalh.
      WRITE: 'Relatório Detalhado'.
      SKIP.
      WRITE: / sy-uline,
             / sy-vline, 2(20) 'Núm.Ped.' COLOR COL_KEY,
               sy-vline, 24(10)'Itm' COLOR COL_KEY,
               sy-vline, 36(20)'Material',
               sy-vline, 58(20)'Descrição',
               sy-vline, 80(20)'Data Vend.',
               sy-vline, 102(20)'Empresa',
               sy-vline, 124(20)'Filial',
               sy-vline, 146(20)'Cliente',
               sy-vline, 168(20)'Valor',
               sy-vline, 190(20)'UNV',
               sy-vline, 212(20)'Quantidade',
               sy-vline,
             / sy-uline.
    WHEN p_filial.
      WRITE: 'Relatório Filial'.
      SKIP.
      WRITE: / sy-uline,
             / sy-vline, 2(20) 'Empresa' COLOR COL_GROUP,
               sy-vline, 24(20) 'Filial' COLOR COL_GROUP,
               sy-vline, 46(20) 'Filial',
               sy-vline,
             / sy-uline.

    WHEN p_materi.
      WRITE: 'Relatório Material'.
      SKIP.
      WRITE: / sy-uline,
             / sy-vline, 2(20) 'Material' COLOR COL_GROUP,
               sy-vline, 24(20) 'Descrição',
               sy-vline, 46(20) 'Valor',
               sy-vline,
             / sy-uline.
    WHEN p_client.
      WRITE: 'Relatório Cliente'.
      SKIP.
      WRITE: / sy-uline,
             / sy-vline, 2(20) 'Cliente' COLOR COL_GROUP,
               sy-vline, 24(20) 'Valor',
               sy-vline,
             / sy-uline.
    WHEN OTHERS.
  ENDCASE.

*--------------------------------------------------------------------*
* Seleção dos dados
*--------------------------------------------------------------------*
START-OF-SELECTION.
  SELECT nro item matnr maktx data_venda bukrs branch kunnr valor unv qtd
        FROM ztt0simoev_tm_v1
        INTO TABLE t_detalhado
        WHERE bukrs        IN s_bukrs
          AND branch       IN s_branch
          AND nro          IN s_nro
          AND data_venda   IN s_data
          AND kunnr        IN s_kunnr.

  CASE 'X'.
    WHEN p_detalh.
*      SELECT nro item matnr maktx data_venda bukrs branch kunnr valor unv qtd
*        FROM ztt0simoev_tm_v1
*        INTO TABLE t_detalhado
*        WHERE bukrs        IN s_bukrs
*          AND branch       IN s_branch
*          AND nro          IN s_nro
*          AND data_venda   IN s_data
*          AND kunnr        IN s_kunnr.


      " IMPRESSÃO:
      LOOP AT t_detalhado INTO w_detalhado.
        WRITE: / sy-vline, 2(20) w_detalhado-nro,
                 sy-vline, 24(10) w_detalhado-item,
                 sy-vline, 36(20) w_detalhado-matnr,
                 sy-vline, 58(20) w_detalhado-maktx,
                 sy-vline, 80(20) w_detalhado-data_venda,
                 sy-vline, 102(20) w_detalhado-bukrs,
                 sy-vline, 124(20) w_detalhado-branch,
                 sy-vline, 146(20) w_detalhado-kunnr,
                 sy-vline, 168(20) w_detalhado-valor,
                 sy-vline, 190(20) w_detalhado-unv,
                 sy-vline, 212(20) w_detalhado-qtd,
                 sy-vline,
               / sy-uline.
      ENDLOOP.
      "*****************************************************************

    WHEN p_filial.
*      SELECT bukrs branch valor
*        FROM ztt0simoev_tm_v1
*        INTO TABLE t_sum_filial
*        WHERE bukrs        IN s_bukrs
*          AND branch       IN s_branch.

*      SELECT nro item matnr maktx data_venda bukrs branch kunnr valor unv qtd
*              FROM ztt0simoev_tm_v1
*              INTO TABLE t_detalhado
*              WHERE bukrs        IN s_bukrs
*                AND branch       IN s_branch
*                AND nro          IN s_nro
*                AND data_venda   IN s_data
*                AND kunnr        IN s_kunnr.

      "Sumarizar: LOOP AT tabela bruta INTO LINHA BRUTA; Associa item a item nas tabelas menores
      LOOP AT t_detalhado INTO w_detalhado.           "Percorra a tabela bruta item a item"
        CLEAR w_sum_filial.
        w_sum_filial-bukrs = w_detalhado-bukrs.       "associe cada campo com o da sua tabela"
        w_sum_filial-branch = w_detalhado-branch.     "     ||      "
        w_sum_filial-valor = w_detalhado-valor.       "     ||      "
        COLLECT w_sum_filial INTO t_sum_filial.       " Insira a linha já organizada na sua tabela de visualização"
      ENDLOOP.

      " IMPRESSÃO:
      LOOP AT t_sum_filial INTO w_sum_filial.
        WRITE: / sy-vline, 2(20) w_sum_filial-bukrs,
                 sy-vline, 24(20) w_sum_filial-branch,
                 sy-vline, 46(20) w_sum_filial-valor,
                 sy-vline,
               / sy-uline.
      ENDLOOP.
      "*****************************************************************
    WHEN p_materi.
*      SELECT matnr maktx valor
*        FROM ztt0simoev_tm_v1
*        INTO TABLE t_sum_material.

      " SUMARIZAR
      LOOP AT t_detalhado INTO w_detalhado.
        CLEAR w_sum_material.
        w_sum_material-material = w_detalhado-matnr.
        w_sum_material-maktx = w_detalhado-maktx.
        w_sum_material-valor = w_detalhado-valor.
        COLLECT w_sum_material INTO t_sum_material.
      ENDLOOP.

      " IMPRESSÃO:
      LOOP AT t_sum_material INTO w_sum_material.
        WRITE: / sy-vline, 2(20) w_sum_material-material,
                 sy-vline, 24(20) w_sum_material-maktx,
                 sy-vline, 46(20) w_sum_material-valor,
                 sy-vline,
               / sy-uline.
      ENDLOOP.
      "*****************************************************************
    WHEN p_client.
*      SELECT kunnr valor
*        FROM ztt0simoev_tm_v1
*        INTO TABLE t_sum_cliente
*        WHERE kunnr IN s_kunnr.

      " SUMARIZAR
      LOOP AT t_detalhado INTO w_detalhado.
        CLEAR w_sum_cliente.
        w_sum_cliente-kunnr = w_detalhado-kunnr.
        w_sum_cliente-valor = w_detalhado-valor.
        COLLECT w_sum_cliente INTO t_sum_cliente.
      ENDLOOP.

      " IMPRESSÃO:
      LOOP AT t_sum_cliente INTO w_sum_cliente.
        WRITE: / sy-vline, 2(20) w_sum_cliente-kunnr,
                 sy-vline, 24(20) w_sum_cliente-valor,
                 sy-vline,
               / sy-uline.
      ENDLOOP.
      "*****************************************************************
    WHEN OTHERS.
  ENDCASE.