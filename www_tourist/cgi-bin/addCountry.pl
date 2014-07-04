#!/usr/bin/perl -w
use HTML::Template;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use DBI;

print "Content-type: text/html\n\n";

open(FILE, "../auth.txt");
$isAdmin;
while (defined ($file_line = <FILE>)) {
        if($file_line eq 'admin') { $isAdmin=1; }
}
close FILE;

if($isAdmin){
  $name = param("name");

  $db = DBI->connect('DBI:mysql:tourist;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  
  my $data=$db->do("INSERT INTO country (name) values ('$name');");
									
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/city/getAllCity.pl"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;