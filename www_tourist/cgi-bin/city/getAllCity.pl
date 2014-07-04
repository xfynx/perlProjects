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
  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/city.tmpl', option => 'value');

  $db = DBI->connect('DBI:mysql:tourist;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  my $rows=$db->selectall_arrayref('select city.id, city.name as name, country.name as country from city join country where country.id=city.id_country;', {Columns=>{}});
  my $countries=$db->selectall_arrayref("select name from country;", {Columns=>{}});

  $tmpl->param(ROWS => $rows || [], COUNTRIES=> $countries || []);
  $db->disconnect();

  print $tmpl->output;
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;