*&---------------------------------------------------------------------*
*& Report /cpt/advent2024day03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /cpt/advent2024day03.
DATA: rc TYPE i.
DATA: files TYPE filetable.
DATA: action TYPE i.
DATA(input) = VALUE string_table( ).
cl_gui_frontend_services=>file_open_dialog( EXPORTING multiselection = abap_false CHANGING file_table = files rc = rc user_action = action ).
CHECK action = cl_gui_frontend_services=>action_ok.
cl_gui_frontend_services=>gui_upload( EXPORTING filename = CONV #( files[ 1 ]-filename ) filetype = 'ASC' CHANGING data_tab = input ).

WRITE REDUCE i( LET mul = VALUE string_table( LET anzahl = count( val = concat_lines_of( input ) pcre = `(don't\(\))|(do\(\))|(mul\(\d+,\d+\))` ) IN FOR i = 1 UNTIL i > anzahl
                                            ( match( val = concat_lines_of( input ) pcre = `(don't\(\))|(do\(\))|(mul\(\d+,\d+\))` occ = i ) ) ) IN
                INIT sum = 0 status = abap_true
                FOR <wa> IN mul
                NEXT sum   += COND #( WHEN <wa>(3) EQ 'mul' AND status EQ abap_true
                                       THEN EXACT #( match( val = <wa> pcre = `\d+` occ = 1 ) ) * EXACT #( match( val = <wa> pcre = `\d+` occ = 2 ) )
                                        ELSE 0 )
                     status = SWITCH #( <wa> WHEN `do()` THEN abap_true WHEN `don't()` THEN abap_false ELSE status ) ).
