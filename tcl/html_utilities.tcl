proc table_spacer {lines} {
    puts $::html_out "<br>";
}

proc html_header {{image 1}} {
    puts $::html_out "<html>"
    puts $::html_out "<body>";
    ##__     if {$image == 1} {
    ##__ 	puts $::html_out "<body background=\"https://www.eteamz.com/guilfordhighschoolsoccer/files/G.gif\">";
    ##__ #	puts $::html_out "<body background=\"files/G.gif\">";
    ##__     } else {
    ##__     puts $::html_out "<body background=\"https://www.eteamz.com/guilfordhighschoolsoccer/files/hs.jpg\">";
    ##__ #    puts $::html_out "<body background=\"files/hs.jpg\">";
    ##__     }
    

}
proc html_trailer {} {
    puts $::html_out "</body>";
    puts $::html_out "</html>";
}

#style=\"
#    position: fixed;
#    top: 0;
#    left: 0;
#    width: 300px;\"

proc table_header {title {alignment left}} {
    puts $::html_out "<table 
bgcolor=\"#000000\" border=\"5\"
align=\"$alignment\"
>";
    puts $::html_out "<tbody>"
    puts $::html_out "<tr>";
    puts $::html_out "<td style=\"color:white\"><b>$title</td>";
    puts $::html_out "</tr>";

}

proc table_trailer {} {
    puts $::html_out "</tbody>";
    puts $::html_out "</table>";
}

#width:200px;
proc table_data {data {bold 0}} {
    if {$bold} {
	puts $::html_out "<td style=\"color:white\"><b>$data</td>";
    } else {
	puts $::html_out "<td style=\"color:white\">$data</td>";
    }
}
proc table_row_start {} {
    puts $::html_out "<tr>";
}
proc table_row_end {} {
    puts $::html_out "<tr>";
}

