#!perl -w
use strict;
use LWP::UserAgent;
use LWP::Simple;

my $content = '';
my $paper_name = '';
my $paper_addr = '';
my $paper_num = 0;
my $session_num = 0;

open OUTPUT,'>','statistic_result.txt' or die 'open statistic_result.txt error!';
open(INPUT, "USENIX22.html") || die("could not open USENIX22.html\n");
my $httpfile = "";
my $line = "";
while ($line = <INPUT>){
    $httpfile .= $line;
}
close(INPUT);

# find sessions and papers
while ($httpfile =~ s#class="node-title">(.+?)<\/h2>##xs){
    $content = $1;
    if($content =~ s#href="(.+?)">(.+?)<##xs){
        $paper_addr = $1;
        $paper_name = $2;
        print "find\n";
        $paper_num += 1;
        # recover special char of paper name in html source code
        $paper_name =~ s/\&\#039;/'/ig;
        $paper_name =~ s/\&quot;/"/ig;
        print OUTPUT "$paper_name\thttps://www.usenix.org$paper_addr\n";
    } else {
        print "find session\n";
        $session_num += 1;
        $content =~ s/\&amp;/&/ig;
        print OUTPUT "\n$content\n";
    }
}

print OUTPUT "\npaper number: $paper_num, session number: $session_num\n";

close OUTPUT;
