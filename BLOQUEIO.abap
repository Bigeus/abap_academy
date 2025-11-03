*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_BLOQUEIO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0SIMOEV_R_BLOQUEIO.

START-OF-SELECTION.
  CALL FUNCTION 'ENQUEUE_E_TABLE'
   EXPORTING
*     MODE_RSTABLE       = 'E'
     TABNAME            = 'ZTT0SIMOEV_TM_TR'
*     VARKEY             =
*     X_TABNAME          = ' '
*     X_VARKEY           = ' '
*     _SCOPE             = '3'
*     _SYNCHRON          = ' '
*     _COLLECT           = ' '
            .

" Fazer processamentos e coisas

CALL FUNCTION 'DEQUEUE_E_TABLE'
* EXPORTING
*   MODE_RSTABLE       = 'E'
*   TABNAME            =
*   VARKEY             =
*   X_TABNAME          = ' '
*   X_VARKEY           = ' '
*   _SCOPE             = '3'
*   _SYNCHRON          = ' '
*   _COLLECT           = ' '
          .