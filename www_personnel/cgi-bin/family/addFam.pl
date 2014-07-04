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
  $persId = param("pers-id");
  $first = param("first");
  $middle = param("middle");
  $last = param("last");
  $birth = param("birth");
  
  $db = DBI->connect("dbi:SQLite:dbname=/var/www/db/personnel_department.sqlite","","") || die $DBI::errstr;
  
  my $data=$db->selectall_arrayref("INSERT INTO family (id_personal, first_name, middle_name, last_name, birth_date) values ($persId, '$first', '$middle', '$last', '$birth');");
									
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/pers/showPers.pl?id='.$persId.'"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;