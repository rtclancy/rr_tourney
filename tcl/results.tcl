#!/usr/bin/tclsh
package require sqlite3
sqlite3 db "../db/rr_tourney.db";

set eval_string "select entrant_name from entrant_table";
set entrant_list [db eval $eval_string];
puts $entrant_list;

set eval_string "select count(*) from match_table where winning_player = \"\$entrant\"";
foreach entrant $entrant_list {
    set eval_string "select count(*) from match_table where winning_player = \"$entrant\"";
    set array_wins($entrant) [db eval [subst $eval_string]];
}
foreach entranta $entrant_list {
    set ties 0;
    set losses 0;
    foreach entrantb $entrant_list {
	#Ties
	set eval_string "select count(*) from match_table where match_key = \"$entranta,$entrantb\" and winning_player=\"Tie\"";
	#puts [db eval $eval_string];
	incr ties [db eval $eval_string];
	set eval_string "select count(*) from match_table where match_key = \"$entrantb,$entranta\" and winning_player=\"Tie\"";
	#puts [db eval $eval_string];
	incr ties [db eval $eval_string];

	#Losses
	set eval_string "select count(*) from match_table where match_key = \"$entranta,$entrantb\" and winning_player!=\"$entranta\" and winning_player!=\"None\" and winning_player!=\"Tie\"";
	#puts [db eval $eval_string];
	incr losses [db eval $eval_string];
	set eval_string "select count(*) from match_table where match_key = \"$entrantb,$entranta\" and winning_player!=\"$entranta\" and winning_player!=\"None\" and winning_player!=\"Tie\"";
	#puts [db eval $eval_string];
	incr losses [db eval $eval_string];
	
    }
    set array_ties($entranta) $ties
    set array_losses($entranta) $losses
}

foreach entrant $entrant_list {
    set total_points [expr 2 * $array_wins($entrant) + 1 * $array_ties($entrant)];
    set eval_string "update entrant_table set wins=\"$array_wins($entrant)\", losses=\"$array_losses($entrant)\", ties=$array_ties($entrant) where entrant_name=\"$entrant\"";
    db eval $eval_string;
    set eval_string "update entrant_table set total_points=\"$total_points\" where entrant_name=\"$entrant\"";
    db eval $eval_string;
}
