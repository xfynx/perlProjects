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
  $id_tour = param("id");

  open(FILE, "../../auth.txt");
  my $login;
  while (defined ($file_line = <FILE>)) {
    $login = $file_line;
    last;
  }
  close FILE;

  $db = DBI->connect('DBI:mysql:tourist;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  $login =~ s/^\s+//m;
  $login =~ s/\s+$//m;

  my $data=$db->do("INSERT INTO permit (id_user, id_tour, date) select id, ".$id_tour.", '2014-09-12' from user where login like '$login';");

  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/permit/getAllDeal.pl"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;