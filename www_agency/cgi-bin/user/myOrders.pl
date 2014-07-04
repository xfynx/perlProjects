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
  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/myDeals.tmpl', option => 'value');

  $db = DBI->connect('DBI:mysql:agency;host=localhost:3306', 'root', '123', { RaiseError => 1 });

  open(FILE, "../../auth.txt");
    my $login;
    while (defined ($file_line = <FILE>)) {
      $login = $file_line;
      last;
    }
    close FILE;
    $login =~ s/^\s+//m;
    $login =~ s/\s+$//m;

  my $query = $db->prepare("select id from user where login = '$login';");
    $query->execute() or die($db->errstr);
    @row = $query->fetchrow_array();
    $id_user = $row[0];
    $query->finish();

  my $rows=$db->selectall_arrayref("select deal.id, date, deal.id_client as idclient, deal.id_owner as idowner,
                                    (select DISTINCT user.full_name from deal join user where user.id = idclient) as client,
                                    (select DISTINCT user.full_name from deal join user where user.id = idowner) as owner
                                    from deal where deal.id_client = ".$id_user." or deal.id_owner = ".$id_user.";", {Columns=>{}});

  $tmpl->param(ROWS => $rows || []);
  $db->disconnect();

  print $tmpl->output;		 #вывод
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;