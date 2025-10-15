*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_SANDBOX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0SIMOEV_R_SANDBOX.

*--------------------------------------------------------------------*
* CALCULADORA DE SUBTRAÇÃO
* n esqueça de jogar na tela o resultado.
*--------------------------------------------------------------------*

"Declare os Parameters

"Chame seu Perform

"Defina o Form



*--------------------------------------------------------------------*
* INVERTER FRASE:
* o usuário deve escrever uma frase nos parameters e vc deve inverter
* a ordem dos textos e jogar na tela.
*--------------------------------------------------------------------*

" Declare 4 parameters tipo string.

"Chame seu Perform

"Defina o Form que vai receber os textos, invertê-los e jogar na tela.

*--------------------------------------------------------------------*
* CAIXA ELETRONICO
* Primeiro exercicio com lógica de Decisão!!!!!
* Usuario escolhe entre 2 operações: Saque e Depósito.
*--------------------------------------------------------------------*

" Declare 3 Parameters:
" 1 onde terá um valor fixo de 1000 (mil reais), esse será o saldo do usuário.
" 1 onde o usuário vai inserir um valor
" 1 onde o usuario vai decidir com RADIOBUTTON a operação. (2 botões que ele possa clicar)


" Idéia: Use uma lógica de Decisão para ver qual operação o usuário quer fazer.
" Idéia: Quer criar um ou 2 Forms? Os 2 casos são possíveis aqui.


" Chame seu PERFORM ou PERFORMs


"Defina seu FORM ou FORMs

*--------------------------------------------------------------------*
* REPETIDOR DE TEXTO
* Crie uma tela onde o usuário poderá inserir um texto e um número.
* O número irá definir quantas vezes temos que repetir o texto na tela.
*--------------------------------------------------------------------*

"Idéia: use uma estrutura de repetição para facilitar a impressão.


" Chame seu PERFORM


" Defina seu FORM.

*--------------------------------------------------------------------*
* CONTADOR DE NÚMEROS PARES:
* O usuário deve inserir um número em um PARAMETER.
* Voce deve descobrir quantos numeros pares existem até ele (não contando ele).
*--------------------------------------------------------------------*


* Idéia: use while.
* Idéia: para descobrir se um numero é par vc pode usar:
* IF p_num MOD 2 = 0..
*   " Se for par vai cair aqui
*   ELSE.
*   " Se for ímpar vai cair aqui
* ENDIF.

" Chame seu PERFORM




" Declare seu FORM