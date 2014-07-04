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
  $begin_at = param("begin");
  $duration = param("duration");
  $theatre = param("theatre");
  $ticket_count = param("count");
  
  $db = DBI->connect('DBI:mysql:afisha;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  
  my $data=$db->do("INSERT INTO spectacle (name, begin_at, duration, id_theatre, ticket_count)
  									select '$name','$begin_at','$duration',
  									id, $ticket_count from theatre where name like '$theatre';");
									
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/spectacle/getAllSpectacle.pl"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;