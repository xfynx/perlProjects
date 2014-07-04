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

  $id_accomodation = param("id");

  open(FILE, "../../auth.txt");
  my $login;
  while (defined ($file_line = <FILE>)) {
    $login = $file_line;
    last;
  }
  close FILE;

  $db = DBI->connect('DBI:mysql:agency;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  $login =~ s/^\s+//m;
  $login =~ s/\s+$//m;

$current_date = "%Y-%m-%d";
$current_date = substr($current_date,0,-1);

  my $data=$db->do("INSERT INTO deal (id, id_client) select ".$id_accomodation.", user.id from user where login like '$login';");
  $db->do("update deal set date='2014-06-10', id_owner=(select user.id from user join accomodation where accomodation.id = $id_accomodation and user.id = accomodation.id_user) where deal.id = $id_accomodation;");
  $db->do("update accomodation set status = 'inactive' where id=$id_accomodation;");
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/deal/getAllDeal.pl"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;