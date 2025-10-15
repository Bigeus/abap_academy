REPORT ztt0simoev_r_messages MESSAGE-ID ztt0simoev_cm_test NO STANDARD PAGE HEADING.

START-OF-SELECTION.

*MESSAGE s000 WITH 'Hello World' 'Ok'.

*MESSAGE s000 WITH sy-uname DISPLAY LIKE 'E'.           DISPLAY LIKE 'E' MOSTRA COMO ERRO

*MESSAGE s001 WITH sy-uname.
*
*DATA: vl_msg TYPE string.
*
*MESSAGE s001 WITH sy-uname INTO vl_msg.
*
*write vl_msg.

*WRITE 'Teste'.

*WRITE: 'Bom dia'(t01).