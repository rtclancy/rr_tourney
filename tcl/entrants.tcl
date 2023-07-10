#!/usr/bin/tclsh

package require sqlite3

set entrant_list {
    {{Dennis}   {Le Frenchman}                    {Yes}}
    {{Bob}      {Sandbagger Bob}                  {Yes}}
    {{Joe}      {Joey 3Wood  }                    {Yes}}
    {{Marshall} {Marsha,Marsha,Marsha}            {Yes} }
    {{Kenny}    {D-Day Kenny}                     {No} }
    {{SteveC}   {Steve Ohhh!!!}                   {No} }
    {{Seth}     {Jets Fan}                        {No} }
    {{MikeF}    {Fitzy}                           {No} }
    {{SteveL}   {Hammer}                          {No} }
    {{Brian}    {The Lemonator}                   {Yes} }
    {{JonB}     {Plastic Santa}                   {No} }
    {{MikeA}    {Mikey}                           {No} }
    {{MikeB}    {Bunker Buster Belden}            {No} }
    {{Dean}     {Deano Tomato Mozzarella}         {Yes} }
};

file delete -force  "../db/rr_tourney.db";
sqlite3 db "../db/rr_tourney.db";

db eval {CREATE TABLE entrant_table(entrant_name text,entrant_nickname text,entrant_paid_up text,total_points int,wins int,losses int,ties int)};
db eval {CREATE TABLE match_table(match_key text,date_played text,winning_player text,venue text)};

foreach entrant $entrant_list {
    db eval "insert into entrant_table values( \
    '[lindex $entrant 0]',
    '[lindex $entrant 1]',
    '[lindex $entrant 2]',
    0,
    0,
    0,
    0
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
			'None',
			'Unknown'
			)";
	    }
	}
    }
}

