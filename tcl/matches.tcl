#!/usr/bin/tclsh
package require sqlite3
set match_list {

    {{JonB,MikeA}       6/17/2023 Tie}

    {{Bob,Joe}       6/17/2023 Joe}
    {{MikeB,Joe}     6/17/2023 Joe}
    {{MikeB,Bob}     6/17/2023 Tie}

    {{Bob,Brian}     6/10/2023 Bob}
    {{Bob,Seth}      6/10/2023 Bob}
    {{Joe,Seth}      6/10/2023 Seth}
    {{Joe,Brian}     6/10/2023 Brian}
    {{Marshall,JonB} 6/10/2023 JonB}
    {{Marshall,Kenny}  6/10/2023 Marshall}
    {{JonB,SteveC}   6/10/2023 JonB}
    {{SteveC,Kenny}  6/10/2023 Kenny}
    {{MikeA,MikeF}   6/10/2023 MikeA}

    {{Bob,Dennis} 5/9/2023 Bob}
    
    {{Dennis,SteveC} 5/13/2023 Dennis}
    {{Dennis,Marshall} 5/13/2023 Dennis}
    {{Seth,MikeF} 5/13/2023 Seth}
    {{Seth,SteveL} 5/13/2023 Seth}
    {{Kenny,MikeF} 5/13/2023 Kenny}
    {{SteveL,Kenny} 5/13/2023 SteveL}

    {{Bob,Marshall} 6/3/2023 Bob}
    
}


sqlite3 db "../db/rr_tourney.db";

foreach match $match_list {
    set match_key1 [lindex $match 0];
    set match_key2 [lindex [split [lindex $match 0] ","] 1],[lindex [split [lindex $match 0] ","] 0]
    puts $match_key1;
    puts $match_key2;
    set eval_string "select exists(select 1 from match_table where match_key = \"$match_key1\")";
    set correct_key [db eval $eval_string;]
    if {$correct_key} {
	set match_key $match_key1;
    } else {
	set match_key $match_key2;
    }
    #set eval_string "select entrant_nickname from entrant_table where entrant_name=\"[lindex $match 2]\"";
    #set nickname [db eval $eval_string];
    set nickname [lindex $match 2];
    set eval_string "update match_table set date_played=\"[lindex $match 1]\", winning_player=\"$nickname\" where match_key=\"$match_key\"";
    puts $eval_string;
    db eval $eval_string;
}


#set eval_string "select entrant_nickname from entrant_table order by entrant_nickname";
#set entrant_list [db eval $eval_string];
#puts $entrant_list;
#
#source html_utilities.tcl
#set html_out [open matches.html w];
#
#set entrant_list [db eval $eval_string];
#
#
#
#
##set up initial values for table data
#set table_data(0,0) "XXXXX"
#foreach index $entrant_list {
#	set table_data(0,$index) "$index";
#	set table_data($index,0) "$index";
#}
#
#foreach indexa $entrant_list {
#    foreach indexb $entrant_list {
#	if {$indexa == $indexb} {
#	    set table_data($indexa,$indexb) "XXXXX";
#	} else {
#	    set table_data($indexa,$indexb) "     ";
#	}
#    }
#}

#html_header;
#table_header "Match Results";
#set entrant_list [linsert $entrant_list 0 0];
#puts $entrant_list;
#foreach indexa $entrant_list {
#    table_row_start;
#    foreach indexb $entrant_list {
#	puts $indexa,$indexb,$table_data($indexa,$indexb);
#	table_data $table_data($indexa,$indexb);
#    }
#    table_row_end;
#}
#table_trailer;
#html_trailer;


#html_header;
#table_header "Match Results";
#table_row_start;
#table_data PLAYER1;
#table_data PLAYER2;
#table_data "DATE PLAYED";
#table_data WINNER;
#table_row_end;
#table_spacer 4;
#foreach match $match_list {
#    set player1 [lindex [split [lindex $match 0] ","] 0]
#    set player2 [lindex [split [lindex $match 0] ","] 1]
#    set eval_string "select entrant_nickname from entrant_table where entrant_name=\"$player1\"";
#    set player1 [lindex [db eval $eval_string] 0]; 
#    set eval_string "select entrant_nickname from entrant_table where entrant_name=\"$player2\"";
#    set player2 [lindex [db eval $eval_string] 0];
#    set date_played [lindex $match 1]
#    set winner [lindex $match 2]
#    
#    table_row_start;
#    table_data $player1;
#    table_data $player2;
#    table_data $date_played;
#    table_data $winner;
#    table_row_end;
#}
#table_trailer;
#html_trailer;
