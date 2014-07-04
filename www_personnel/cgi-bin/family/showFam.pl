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
  $ID = param("id");
  $tmpl = HTML::Template->new(filename => '/var/www/tmpl/showFam.tmpl', option => 'value');

  $db = DBI->connect("dbi:SQLite:dbname=/var/www/db/personnel_department.sqlite","","") || die $DBI::errstr;
  my $data=$db->selectall_arrayref("select id, first_name, middle_name, last_name, birth_date from family where id = $ID;", {Columns=>{}});
  $db->disconnect();									
									
  $tmpl->param(DATA => $data);
  print $tmpl->output;
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;