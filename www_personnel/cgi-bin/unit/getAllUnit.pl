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
  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/unit.tmpl', option => 'value');

  $db = DBI->connect("dbi:SQLite:dbname=/var/www/db/personnel_department.sqlite","","") || die $DBI::errstr;
  my $rows=$db->selectall_arrayref('select id, name, people_count, monthly_fund, yearly_fund from unit order by people_count desc, yearly_fund;', {Columns=>{}});
  $tmpl->param(ROWS => $rows); #привязка
  $db->disconnect();

  print $tmpl->output;		 #вывод
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;