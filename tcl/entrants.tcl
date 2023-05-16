#!/usr/bin/tclsh

package require sqlite3

set entrant_list {
    {{Dennis}   {Le Frenchman}                    {Yes}}
    {{Bob}      {Sandbagger Bob}                  {No} }
    {{Joe}      {Joey 3-Wood}                     {No} }
    {{Marshall} {Marsha,Marsha,Marsha}            {No} }
    {{Kenny}    {D-Day Kenny}                     {No} }
    {{SteveC}   {Steve Ohhh!!!}                   {No} }
    {{Seth}     {Jets Fan}                        {No} }
    {{MikeF}    {Fitzy}                           {No} }
    {{SteveL}   {Hammer}                          {No} }
};

file delete -force  "../db/rr_tourney.db";
sqlite3 db "../db/rr_tourney.db";

db eval {CREATE TABLE entrant_table(entrant_name text,entrant_nickname text,entrant_paid_up text)};
db eval {CREATE TABLE match_table(match_key text,date_played text,winning_player text)};

foreach entrant $entrant_list {
    db eval "insert into entrant_table values( \
    '[lindex $entrant 0]',
    '[lindex $entrant 1]',
    '[lindex $entrant 2]'
    )";
}

set entrant_list [db eval {select entrant_name from  entrant_table}];

foreach playerA "$entrant_list" {
    foreach playerB "$entrant_list" {
	if {$playerA != $playerB} {
	    set eval_string "select exists(select 1 from match_table where match_key = \"$playerA,$playerB\" or match_key = \"$playerB,$playerA\")";
	    puts $eval_string;
	    set does_match_exist [db eval [subst $eval_string]];
	    if {!$does_match_exist} {
		db eval "insert into match_table values( \
		    	'$playerA,$playerB',
			'00/00/0000',
			'None'
			)";
	    }
	}
    }
}

