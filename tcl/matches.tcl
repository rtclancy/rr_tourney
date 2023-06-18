#!/usr/bin/tclsh
package require sqlite3
proc divider {} {
    puts "***************************************************";
}
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
    #puts $match_key1;
    #puts $match_key2;
    set eval_string "select exists(select 1 from match_table where match_key = \"$match_key1\")";
    set correct_key [db eval $eval_string;]
    if {$correct_key} {
	set match_key $match_key1;
    } else {
	set match_key $match_key2;
	set eval_string "select exists(select 1 from match_table where match_key = \"$match_key2\")";
	set correct_key [db eval $eval_string;]
    }
    if {!$correct_key} {
	divider;
	puts "Match not found";
	divider;
	exit;
    }
    #set eval_string "select entrant_nickname from entrant_table where entrant_name=\"[lindex $match 2]\"";
    #set nickname [db eval $eval_string];
    set nickname [lindex $match 2];
    set eval_string "update match_table set date_played=\"[lindex $match 1]\", winning_player=\"$nickname\" where match_key=\"$match_key\"";
    #puts $eval_string;
    db eval $eval_string;
}


