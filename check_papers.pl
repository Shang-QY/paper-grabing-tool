#!perl -w
use strict;
use LWP::UserAgent;
use LWP::Simple;

my $content;
my $paper_name = '';
my $paper_addr = '';
my $filename = "";
my $dir = "archive/";
my $paper_num = 0;
my $session_num = 0;
my $ret;
my $status;

open OUTPUT,'>','check_result.txt' or die 'check_result.txt error!';
open(INPUT, "USENIX22.html") || die("could not open USENIX22.html\n");
my $httpfile = "";
my $line = "";
while ($line = <INPUT>){
    $httpfile .= $line;
}
close(INPUT);

while ($httpfile =~ s#class="node-title">(.+?)<\/h2>##xs){
    $content = $1;
    if($content =~ s#href="(.+?)">(.+?)<##xs){
        $paper_addr = $1;
        $paper_name = $2;
        $filename = $paper_addr;
        $filename =~ s#/conference/usenixsecurity22/presentation/##s;
        $filename .= ".pdf";

        $ret = system("test -e $dir$filename");
        print "test -e $dir$filename\n";
        print $ret;
        if ($ret == 0){
            $status = "EXIST";
        } else {
            $status = "NOT FIND";
        }

        print "find\n";
        $paper_num += 1;
        # recover special char of paper name in html source code
        $paper_name =~ s/\&\#039;/'/ig;
        $paper_name =~ s/\&quot;/"/ig;
        print OUTPUT "$paper_name\n\taddress: https://www.usenix.org/$paper_addr\n\tstatus: $status\n\tfilename: $filename\n";
    } else {
        print "find session\n";
        $session_num += 1;
        $content =~ s/\&amp;/&/ig;
        print OUTPUT "\nSESSION: $content\n";
    }
}

close OUTPUT;
