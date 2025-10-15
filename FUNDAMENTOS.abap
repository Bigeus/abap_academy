*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_FUNDAMENTOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0SIMOEV_FUNDAMENTOS.

DATA: vl_name TYPE c LENGTH 8, vl_surname TYPE string,
      vl_height_integer TYPE i.
DATA: vl_height_decimal TYPE p LENGTH 2 DECIMALS 2.
DATA: vl_uf TYPE c LENGTH 2, vl_city TYPE c LENGTH 5.
DATA: vl_birth_date TYPE d, vl_age TYPE integer.

vl_name = 'Vinicius'.
vl_surname = 'Simões'.
vl_height_integer = 170.
vl_height_decimal = '1.70'.
vl_uf = 'SP'.
vl_city = 'Tatuí'.
vl_birth_date = '20030829'.
vl_age = 22.

WRITE:
  / 'Nome: ', vl_name,
  / 'Sobrenome: ', vl_surname,
  / 'Altura Inteiro: ', vl_height_integer,
  / 'Altura Decimal: ', vl_height_decimal,
  / 'Estado :', vl_uf,
  / 'Cidade :', vl_city,
  / 'Data de nascimento: ', vl_birth_date,
  / 'Idade :', vl_age.