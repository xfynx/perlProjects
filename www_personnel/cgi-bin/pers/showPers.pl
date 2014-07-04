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
  
  $tmpl = HTML::Template->new(filename => '/var/www/tmpl/showPers.tmpl', option => 'value');

  $db = DBI->connect("dbi:SQLite:dbname=/var/www/db/personnel_department.sqlite","","") || die $DBI::errstr;
  my $data=$db->selectall_arrayref("select 
									personal_data.id, personal_data.first_name, personal_data.middle_name, personal_data.last_name, 
									personal_data.address, personal_data.phone_number, personal_data.birth_date, personal_data.post, 
									personal_data.post_date, personal_data.expirience, personal_data.education, personal_data.INN, unit.name as unit,
									personal_data.SNILS
									from personal_data join unit
									where personal_data.id = $ID and unit.id like personal_data.id_unit;", {Columns=>{}});

  my $unitNames=$db->selectall_arrayref("select name from unit;", {Columns=>{}});

  my $relatives=$db->selectall_arrayref("select id, first_name, middle_name, last_name, birth_date from family where id_personal=$ID order by birth_date desc;", {Columns=>{}});
									
  $db->disconnect();									
									
  $tmpl->param(DATA => $data || [], UNITNAMES=>$unitNames, RELATIVES => $relatives || [], PERS_ID => $ID);
  print $tmpl->output;
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}

exit;