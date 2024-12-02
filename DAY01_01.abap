*&---------------------------------------------------------------------*
*& Report /cpt/advent2024day01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /cpt/advent2024day01.
DATA: rc TYPE i.
DATA: files TYPE filetable.
DATA: action TYPE i.
DATA(input) = VALUE string_table( ).
cl_gui_frontend_services=>file_open_dialog( EXPORTING multiselection = abap_false CHANGING file_table = files rc = rc user_action = action ).
CHECK action = cl_gui_frontend_services=>action_ok.
cl_gui_frontend_services=>gui_upload( EXPORTING filename = CONV #( files[ 1 ]-filename ) filetype = 'ASC' CHANGING data_tab = input ).

TYPES tt_colum TYPE SORTED TABLE OF numc05  WITH NON-UNIQUE KEY table_line.

DATA(result) = REDUCE i( LET Spalte1 = VALUE tt_colum( FOR <wa1> IN input ( CONV #( <wa1>(5) ) ) )
                             Spalte2 = VALUE tt_colum( FOR <wa2> IN input ( CONV #( <wa2>+8(5) ) ) ) IN
                         INIT sum = 0
                         FOR <wa3> IN Spalte1 INDEX INTO i
                         NEXT sum = sum + COND i( WHEN <wa3> - Spalte2[ i ] > 0 THEN <wa3> - Spalte2[ i ] ELSE Spalte2[ i ] - <wa3> ) ).

WRITE result.
