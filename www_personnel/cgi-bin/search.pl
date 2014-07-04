#!/usr/bin/perl -w
use HTML::Template;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use DBI;

print "Content-type: text/html\n\n";

open(FILE, "../auth.txt");
$isLoggedIn;
while (defined ($file_line = <FILE>)) {
        if($file_line eq 'admin' || $file_line eq 'user') { $isLoggedIn=1; }
}
close FILE;

if($isLoggedIn){

  $word = param("keyword");

  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/pers.tmpl', option => 'value');

  $db = DBI->connect("dbi:SQLite:dbname=/var/www/db/personnel_department.sqlite","","") || die $DBI::errstr;

  my $rows=$db->selectall_arrayref("select
									personal_data.id, personal_data.first_name, personal_data.middle_name, personal_data.last_name, 
									personal_data.address, personal_data.phone_number, personal_data.birth_date, personal_data.post, 
									personal_data.post_date, personal_data.expirience, personal_data.education, personal_data.INN, 
									personal_data.SNILS, unit.name 
									from personal_data join unit
									where
									personal_data.last_name like '$word%' and
									unit.id like personal_data.id_unit order by unit.name, personal_data.last_name;", {Columns=>{}});
									
  my $unitNames=$db->selectall_arrayref("select name from unit;", {Columns=>{}});
  $tmpl->param(ROWS => $rows || [], UNITNAMES=>$unitNames);
  $db->disconnect();
  print $tmpl->output;
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;