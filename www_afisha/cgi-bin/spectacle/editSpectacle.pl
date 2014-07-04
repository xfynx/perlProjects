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
  $id = param("id");
  $name = param("name");
  $begin_at = param("begin");
  $duration = param("duration");
  $theatre = param("theatre");
  $ticket_count = param("count");

  $db = DBI->connect('DBI:mysql:afisha;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  my $data=$db->do("update spectacle set name='$name', begin_at='$begin_at', duration='$duration', ticket_count=$ticket_count, id_theatre=(select id from theatre where name like '$theatre') where id=$id;");
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/spectacle/showSpectacle.pl?id='.$id.'"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;