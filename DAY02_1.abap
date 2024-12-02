*&---------------------------------------------------------------------*
*& Report /cpt/advent2024day02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /cpt/advent2024day02.
DATA: rc TYPE i.
DATA: files TYPE filetable.
DATA: action TYPE i.
DATA(input) = VALUE string_table( ).
cl_gui_frontend_services=>file_open_dialog( EXPORTING multiselection = abap_false CHANGING file_table = files rc = rc user_action = action ).
CHECK action = cl_gui_frontend_services=>action_ok.
cl_gui_frontend_services=>gui_upload( EXPORTING filename = CONV #( files[ 1 ]-filename ) filetype = 'ASC' CHANGING data_tab = input ).

DATA(result) = REDUCE i( INIT sum = 0
                         FOR <wa> IN input
                         NEXT sum += REDUCE i( LET line = VALUE string_table( LET numbers = count( val = <wa> pcre = `\d+` ) IN FOR i = 1 UNTIL i > numbers ( match( val = <wa> pcre = `\d+` occ = i ) ) ) IN
                                                INIT save = 1
                                                FOR <wa2> IN line INDEX INTO i
                                                NEXT save = COND #( WHEN save EQ 0
                                                                      THEN 0
                                                                     ELSE SWITCH #( i
                                                                                    WHEN 1 THEN 1
                                                                                    WHEN 2 THEN COND i( WHEN <wa2> EQ line[ i - 1 ]
                                                                                                          OR abs( <wa2> - line[ i - 1 ] ) > 3 THEN 0 ELSE Save )
                                                                                    ELSE        COND i( WHEN <wa2> EQ line[ i - 1 ]
                                                                                                          OR abs( <wa2> - line[ i - 1 ] ) > 3
                                                                                                          OR ( <wa2> < line[ i - 2 ] AND <wa2> > line[ i - 1 ] )
                                                                                                          OR ( <wa2> > line[ i - 2 ] AND <wa2> < line[ i - 1 ] ) THEN 0 ELSE Save ) ) ) ) ).

WRITE result.
