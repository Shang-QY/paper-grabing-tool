#!perl -w
use strict;
use LWP::UserAgent;
use LWP::Simple;

# my $page_addr = '';
# my $response = '';
# my $content = '';
# my $get_page = LWP::UserAgent -> new;
# $get_page -> timeout(10);
# $page_addr = 'https://www.usenix.org/conference/usenixsecurity22/technical-sessions';     #此处是每页的网址
# $response = $get_page -> get( $page_addr );
# $content = $response -> content;
# print OUTPUT $content;

# my $url = "https://www.usenix.org/system/files/sec22-yu-sheng.pdf";
# my $file = 'yusheng.pdf';
# my $code = getstore($url,$file);
# if ($code == 200){
#     print "secc\n";
# }

my $paper_name = '';
my $paper_addr = '';
my $pdfurl = "";
my $pdfname = "";
my $code;

open OUTPUT,'>','grab_result.txt' or die 'grab_result.txt error!';
open(INPUT, "USENIX22.html") || die("could not open USENIX22.html\n");
my $httpfile = "";
my $line = "";
while ($line = <INPUT>){
    $httpfile .= $line;
}
close(INPUT);

system("mkdir archive");

# TODO: Add download progress prompt
while ($httpfile =~ s#class="node-title">.+?href="(.+?)">(.+?)<##xs){
    $paper_addr = $1;
    $paper_name = $2;
    print "find\n";
    $pdfname = $paper_addr;
    $pdfname =~ s#/conference/usenixsecurity22/presentation/##s;
    $pdfurl = "https://www.usenix.org/system/files/sec22-" . $pdfname . ".pdf";
    $code = getstore($pdfurl, "archive/" . $pdfname . ".pdf");
    if ($code == 200){
        print "SUCCESS\n";
        print OUTPUT "SUCCESS\t";
    } else {
        print "ERROR\n";
        print OUTPUT "ERROR\t";
    }
    print OUTPUT "$paper_name\n\taddress: $paper_addr\n";
}
close OUTPUT;
