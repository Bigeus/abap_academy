*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_LEITURA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_leitura NO STANDARD PAGE HEADING.

TABLES: zasa0lss_tm_vend.

" Tipagem Estruturas
TYPES: BEGIN OF ty_s_vend,
         nro        TYPE zasa0lss_tm_vend-nro, "Número do Pedido de Venda
         item       TYPE zasa0lss_tm_vend-item, "Número do Item
         maktx      TYPE maktx,
         matnr      TYPE zasa0lss_tm_vend-matnr, "Material Number
         data_venda TYPE zasa0lss_tm_vend-data_venda, "Data da Venda
         bukrs      TYPE zasa0lss_tm_vend-bukrs, "Company Code
         branch     TYPE zasa0lss_tm_vend-branch, "Business Place
         name       TYPE j_1bbranch-name,
         kunnr      TYPE zasa0lss_tm_vend-kunnr, "Customer Number
         name1      TYPE kna1-name1,
         butxt      TYPE t001-butxt,
         valor      TYPE zasa0lss_tm_vend-valor, "Valor da VENDA
         unv        TYPE zasa0lss_tm_vend-unv, "Unidade de Venda
         qtd        TYPE zasa0lss_tm_vend-qtd, "Quantidade de Venda
       END   OF ty_s_vend.

"
TYPES:
  BEGIN OF ty_s_makt,
    matnr TYPE matnr,
    maktx TYPE maktx,
  END OF ty_s_makt.

TYPES:
  BEGIN OF ty_s_kna1,
    kunnr TYPE kunnr,
    name1 TYPE name1,
  END OF ty_s_kna1.

TYPES:
  BEGIN OF ty_s_t001,
    bukrs TYPE bukrs,
    butxt TYPE butxt,
  END OF ty_s_t001.

TYPES:
  BEGIN OF ty_s_j1bbranch,
    bukrs  TYPE bukrs,
    branch TYPE j_1bbranc_,
    name   TYPE name1,
  END OF ty_s_j1bbranch.

" Tipagem tabelas internas
TYPES: ty_t_makt      TYPE SORTED TABLE OF ty_s_makt        WITH UNIQUE KEY matnr.
TYPES: ty_t_kna1      TYPE SORTED TABLE OF ty_s_kna1        WITH UNIQUE KEY kunnr.
TYPES: ty_t_vend      TYPE SORTED TABLE OF ty_s_vend        WITH NON-UNIQUE KEY nro.
TYPES: ty_t_t001      TYPE SORTED TABLE OF ty_s_t001        WITH NON-UNIQUE KEY bukrs.
TYPES: ty_t_j1bbranch TYPE SORTED TABLE OF ty_s_j1bbranch   WITH UNIQUE KEY bukrs branch.     " Não usamos bupla_types pois n usa em j1bbranch

" Seleção em tela
SELECT-OPTIONS: s_matnr FOR zasa0lss_tm_vend-matnr,
                s_kunnr FOR zasa0lss_tm_vend-kunnr.

START-OF-SELECTION.
  " Tabelas internas
  DATA: tl_vend      TYPE ty_t_vend,
        tl_makt      TYPE ty_t_makt,
        tl_kna1      TYPE ty_t_kna1,
        tl_t001      TYPE ty_t_t001,
        tl_j1bbranch TYPE ty_t_j1bbranch.

  " Work Areas
  DATA: wl_makt       TYPE ty_s_makt.
  DATA: wl_kna1       TYPE ty_s_kna1.
  DATA: wl_t001       TYPE ty_s_t001.
  DATA: wl_j1bbranch  TYPE ty_s_j1bbranch.

  " Field symbol para atualizar a tabela transparente vend
  FIELD-SYMBOLS: <vend> TYPE ty_s_vend.

  " Primeiro traz todos os dados de venda com base nos filtros da tela
  SELECT nro item matnr data_venda bukrs branch kunnr valor unv qtd
    FROM zasa0lss_tm_vend
    INTO CORRESPONDING FIELDS OF TABLE tl_vend
    WHERE matnr IN s_matnr
      AND kunnr IN s_kunnr.

  " Busquei minhas vendas, agora quero juntar nessa tabela a descrição de cada material, ao invés de fazer um inner join
  " das duas no banco. Eu trago tudo do primeiro e depois


  " Caso tenha dados de venda, busque todos os materiais que estão também na tabela de vendas, agora na tabela de materiais
  IF tl_vend[] IS NOT INITIAL.
    SELECT matnr maktx
      FROM makt
      INTO TABLE tl_makt
      FOR ALL ENTRIES IN tl_vend
        WHERE matnr EQ tl_vend-matnr.

    SELECT kunnr name1
      FROM kna1
      INTO TABLE tl_kna1
      FOR ALL ENTRIES IN tl_vend
        WHERE kunnr EQ tl_vend-kunnr.

    SELECT bukrs butxt
      FROM t001
      INTO TABLE tl_t001
      FOR ALL ENTRIES IN tl_vend
        WHERE bukrs EQ tl_vend-bukrs.

    SELECT bukrs branch name
      FROM j_1bbranch
      INTO TABLE tl_j1bbranch
      FOR ALL ENTRIES IN tl_vend
        WHERE branch EQ tl_vend-branch
        AND bukrs EQ tl_vend-bukrs.
  ENDIF.

  " Vamos atualizar a tabela interna com o ponteiro, inserindo a descrição dos materiais
  LOOP AT tl_vend ASSIGNING <vend>.
    READ TABLE tl_makt INTO wl_makt WITH TABLE KEY matnr = <vend>-matnr.
    IF sy-subrc EQ 0.
      <vend>-maktx = wl_makt-maktx.
    ENDIF.

    READ TABLE tl_kna1 INTO wl_kna1 WITH TABLE KEY kunnr = <vend>-kunnr.
    IF sy-subrc EQ 0.
      <vend>-name1 = wl_kna1-name1.
    ENDIF.

    READ TABLE tl_t001 INTO wl_t001 WITH TABLE KEY bukrs = <vend>-bukrs.
    IF sy-subrc EQ 0.
      <vend>-butxt = wl_t001-butxt.
    ENDIF.

    " Isso ocorre pois a branch pode nao ser unica. Pode ter duas filiais 1001 de empresas diferentes
    READ TABLE tl_j1bbranch INTO wl_j1bbranch WITH TABLE KEY bukrs  = <vend>-bukrs
                                                             branch = <vend>-branch.
    IF sy-subrc EQ 0.
      <vend>-name = wl_j1bbranch-name.
    ENDIF.

  ENDLOOP.

  " TAREFA 1: pegar a descrição do cliente na KNA1