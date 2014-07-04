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
  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/myOrders.tmpl', option => 'value');

  open(FILE, "../../auth.txt");
    my $login;
    while (defined ($file_line = <FILE>)) {
      $login = $file_line;
      last;
    }
    close FILE;

    $login =~ s/^\s+//m;
    $login =~ s/\s+$//m;

  $db = DBI->connect('DBI:mysql:library;host=localhost:3306', 'root', '123', { RaiseError => 1 });
#  my $rows=$db->selectall_arrayref("SELECT `spectacle`.`name` as spectacle, orders.`place` as place FROM orders INNER JOIN spectacle INNER JOIN user WHERE spectacle.id = orders.`id_spectacle` AND user.login = '$login' AND user.id = orders.id_user ORDER BY spectacle, place;", {Columns=>{}});
  my $rows=$db->selectall_arrayref("select book.name, orders.date_get, orders.date_return from orders inner join user inner join book where book.id = orders.id_book and user.id = orders.id_user AND user.login = '$login';", {Columns=>{}});

  $tmpl->param(ROWS => $rows || []);
  $db->disconnect();

  print $tmpl->output;		 #вывод
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;