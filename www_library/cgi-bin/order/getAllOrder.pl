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
  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/orders.tmpl', option => 'value');

  $db = DBI->connect('DBI:mysql:library;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  my $rows=$db->selectall_arrayref('select user.login, book.name, orders.date_get, orders.date_return from orders inner join user inner join book where book.id = orders.id_book and user.id = orders.id_user', {Columns=>{}});

  $tmpl->param(ROWS => $rows || []);
  $db->disconnect();

  print $tmpl->output;		 #вывод
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;