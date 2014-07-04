#!/usr/bin/perl -w
use HTML::Template;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use DBI;

print "Content-type: text/html\n\n";

open(FILE, "../../auth.txt");
@data = <FILE>;
$isNotAdminOrUser = 1;
while (defined ($file_line = <FILE>)) {
        if($file_line eq 'admin') { $isNotAdminOrUser = 0; }
        if($file_line eq 'user') { $isNotAdminOrUser = 0; }
}
close FILE;

if($isNotAdminOrUser){
  $ID = param("id");
  
  $tmpl = HTML::Template->new(filename => '/var/www/tmpl/showUnit.tmpl', option => 'value');

  $db = DBI->connect("dbi:SQLite:dbname=/var/www/db/personnel_department.sqlite","","") || die $DBI::errstr;
  $db->selectall_arrayref("update unit set people_count=(select count(id) from personal_data where id_unit=$ID) where unit.id=$ID;"); #для обновления количества людей
  my $data=$db->selectall_arrayref("select id, name, people_count, monthly_fund, yearly_fund from unit where id = $ID;", {Columns=>{}});
  $db->disconnect();									
									
  $tmpl->param(DATA => $data);
  print $tmpl->output;
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;