#!/usr/bin/perl -w
use HTML::Template;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use DBI;

print "Content-type: text/html\n\n";

open(FILE, "../../auth.txt");
$isAdmin;
while (defined ($file_line = <FILE>)) {
        if($file_line eq 'admin') { $isAdmin=1; }
}
close FILE;

if($isAdmin){
  $name = param("name");
  $address = param("address");
  $place_count = param("count");
  
  $db = DBI->connect('DBI:mysql:afisha;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  
  my $data=$db->do("INSERT INTO theatre (name, address, place_count) values ('$name','$address', $place_count);");
									
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/theatre/getAllTheatre.pl"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;