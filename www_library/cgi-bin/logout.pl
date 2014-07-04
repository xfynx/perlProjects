#!/usr/bin/perl -w
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);

unlink '../auth.txt';
print "Content-type: text/html\n\n";
print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
exit;