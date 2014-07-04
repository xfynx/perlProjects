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
  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/orders.tmpl', option => 'value');

  $db = DBI->connect('DBI:mysql:afisha;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  my $rows=$db->selectall_arrayref('SELECT `spectacle`.`name` as spectacle, orders.`place` as place, `user`.`login` as login
                                    FROM orders INNER JOIN spectacle INNER JOIN user
                                    WHERE spectacle.id = orders.`id_spectacle` AND user.id = orders.`id_user`
                                    ORDER BY spectacle, place;', {Columns=>{}});

  $tmpl->param(ROWS => $rows || []);
  $db->disconnect();

  print $tmpl->output;		 #вывод
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;