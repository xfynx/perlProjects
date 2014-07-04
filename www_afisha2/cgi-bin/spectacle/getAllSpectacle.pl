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
  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/spectacle.tmpl', option => 'value');

  $db = DBI->connect('DBI:mysql:afisha;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  my $rows=$db->selectall_arrayref('select spectacle.id, spectacle.name, spectacle.duration, theatre.name as theatre, spectacle.ticket_count, spectacle.begin_at from spectacle join theatre where theatre.id = spectacle.id_theatre;', {Columns=>{}});
  my $THEATERS=$db->selectall_arrayref('select name from theatre', {Columns=>{}});
  $tmpl->param(ROWS => $rows || [], THEATERS => $THEATERS);
  $db->disconnect();

  print $tmpl->output;		 #вывод
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;