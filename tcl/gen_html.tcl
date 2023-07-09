#!/usr/bin/tclsh
package require sqlite3
sqlite3 db "../db/rr_tourney.db";

set eval_string "select entrant_nickname from entrant_table order by entrant_name";
set entrant_list_nickname [db eval $eval_string];
puts $entrant_list_nickname;
set eval_string "select entrant_name from entrant_table order by entrant_name";
set entrant_list_name [db eval $eval_string];
puts $entrant_list_name;

source html_utilities.tcl
set html_out [open ../html/matches.html w];

#set up initial values for table data
set table_data(0,0) "XXXXX"
set table_data(0,pts_totals) "Point Totals";
foreach index $entrant_list_nickname {
    set table_data(0,$index) "$index";
    set table_data($index,0) "$index";
    set table_data($index,pts_totals) 0;
}

foreach indexa $entrant_list_nickname {
    foreach indexb $entrant_list_nickname {
	if {$indexa == $indexb} {
	    set table_data($indexa,$indexb) "XXXXX";
	} else {
	    set table_data($indexa,$indexb) "     ";
	}
    }
}

#replace date with results
foreach indexa $entrant_list_nickname {
    foreach indexb $entrant_list_nickname {
	set eval_string "select entrant_name from entrant_table where entrant_nickname=\"$indexa\"";
	set player1 [db eval $eval_string];
	set eval_string "select entrant_name from entrant_table where entrant_nickname=\"$indexb\"";
	set player2 [db eval $eval_string];
	#set player1 $indexa;
	#set player2 $indexb;
	if {$indexa == $indexb} {
	    set table_data($indexa,$indexb) "XXXXX";
	} else {
	    set match_key1 "$player1,$player2";
	    set match_key2 "$player2,$player1";
	    set eval_string "select exists(select 1 from match_table where match_key = \"$match_key1\")";
	    set correct_key [db eval $eval_string;]
	    if {$correct_key} {
		set match_key $match_key1;
	    } else {
		set match_key $match_key2;
	    }
	    set eval_string "select winning_player from match_table where match_key=\"$match_key\"";
	    set winner [lindex [lindex  [db eval $eval_string] 0] 0];
	    set eval_string "select date_played from match_table where match_key=\"$match_key\"";
	    set date [db eval $eval_string];
	    set eval_string "select venue from match_table where match_key=\"$match_key\"";
	    set venue [db eval $eval_string];
	    if {$venue == "unknown"} {set venue " ";}
	    regsub {\{} $venue {} venue;
	    regsub {\}} $venue {} venue;
	    #puts $venue;
	    if {$winner != "None"} {
		if {$winner != "Tie"} {
		    set eval_string "select entrant_nickname from entrant_table where entrant_name=\"$winner\"";
		    set winner [db eval $eval_string];
		    set winner [lindex $winner 0];
		}
		set table_data($indexa,$indexb) $winner<br>$date<br>$venue;
	    }
 	}
    }
}

set table_data(0,wins) "Wins";
set table_data(0,losses) "Losses";
set table_data(0,ties) "Ties";
set table_data(0,total_points) "Total Points";
foreach entrant $entrant_list_nickname {
    set eval_string "select wins from entrant_table where entrant_nickname=\"$entrant\"";
    set table_data($entrant,wins) [db eval $eval_string];
    set eval_string "select losses from entrant_table where entrant_nickname=\"$entrant\"";
    set table_data($entrant,losses) [db eval $eval_string];
    set eval_string "select ties from entrant_table where entrant_nickname=\"$entrant\"";
    set table_data($entrant,ties) [db eval $eval_string];
    set eval_string "select total_points from entrant_table where entrant_nickname=\"$entrant\"";
    set table_data($entrant,total_points) [db eval $eval_string];
}



html_header;
table_header "Sandbagger Invitational 2023 Match Results" center [expr [llength $entrant_list_name] + 5];
set eval_string "select entrant_nickname from entrant_table order by total_points desc";
set entrant_list_nickname [db eval $eval_string];
puts $entrant_list_nickname;
set entrant_list_nickname [linsert $entrant_list_nickname 0 0];
set entrant_list_nickname2 [linsert $entrant_list_nickname end total_points];
set entrant_list_nickname2 [linsert $entrant_list_nickname2 end wins];
set entrant_list_nickname2 [linsert $entrant_list_nickname2 end losses];
set entrant_list_nickname2 [linsert $entrant_list_nickname2 end ties];
puts $entrant_list_nickname;
foreach indexa $entrant_list_nickname {
    table_row_start;
    foreach indexb $entrant_list_nickname2 {
	puts $indexa,$indexb,$table_data($indexa,$indexb);
	if {$indexa != 0 && $indexb == 0} {
	    set eval_string "select entrant_paid_up from entrant_table where entrant_nickname = \"$indexa\"";
	    set paid_up [db eval $eval_string];
	    if {[regexp -nocase {yes} $paid_up]} {
		table_data $table_data($indexa,$indexb) 0 green white;
	    } else {
		table_data $table_data($indexa,$indexb) 0 black white
	    }
	} else {
	    if {[regexp -nocase {XXXX} $table_data($indexa,$indexb)]} {
		table_data $table_data($indexa,$indexb) 0 RED RED
	    } else {
		table_data $table_data($indexa,$indexb) 0 black white;
	    }
	}
    }
    table_row_end;
}
table_trailer;
html_trailer;


