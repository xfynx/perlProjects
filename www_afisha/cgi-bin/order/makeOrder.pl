#!/usr/bin/perl -w
use HTML::Template;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use DBI;

print "Content-type: text/html\n\n";

open(FILE, "../../auth.txt");
$isLoggedIn;
while (defined ($file_line = <FILE>)) {
        if($file_line eq 'admin' || $file_line eq 'user') { $isLoggedIn=1; }
}
close FILE;

if($isLoggedIn){
  $id_spectacle = param("id_spectacle");
  $place = param("place");

  open(FILE, "../../auth.txt");
  my $login;
  while (defined ($file_line = <FILE>)) {
    $login = $file_line;
    last;
  }
  close FILE;

  $db = DBI->connect('DBI:mysql:afisha;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  $login =~ s/^\s+//m;
  $login =~ s/\s+$//m;

  my $data=$db->do("INSERT INTO orders (id_user, id_spectacle, place) select id, ".$id_spectacle.", ".$place." from user where login like '$login';");
#  print "INSERT INTO orders (id_user, id_spectacle, place) select id, ".$id_spectacle.", ".$place." from user where login like '$login';";

  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/spectacle/showSpectacle.pl?id='.$id_spectacle.'"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;