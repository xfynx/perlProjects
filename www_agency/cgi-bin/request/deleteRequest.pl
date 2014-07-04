#!/usr/bin/perl -w
use HTML::Template;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use DBI;

print "Content-type: text/html\n\n";

open(FILE, "../../auth.txt");
my $isAdmin;
while (defined (my $file_line = <FILE>)) {
        if($file_line eq 'admin') { $isAdmin=1; }
}
close FILE;

if($isAdmin){
  $enrty = param("id");

  $db = DBI->connect('DBI:mysql:agency;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  $db->do("delete from request where id=$enrty;", {Columns=>{}});
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/request/getAllRequest.pl"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;