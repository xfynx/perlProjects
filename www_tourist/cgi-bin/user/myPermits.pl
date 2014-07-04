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
  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/deal.tmpl', option => 'value');

  open(FILE, "../../auth.txt");
    my $login;
    while (defined ($file_line = <FILE>)) {
      $login = $file_line;
      last;
    }
    close FILE;

    $login =~ s/^\s+//m;
    $login =~ s/\s+$//m;

  $db = DBI->connect('DBI:mysql:tourist;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  my $rows=$db->selectall_arrayref("select permit.id_tour as id_tour, user.full_name, user.phone, permit.date, country.name as country, city.name as city, tour.hotel, tour.price
                                      from permit join user join country join city join tour
                                      where user.id = permit.id_user
                                      and tour.id = permit.id_tour
                                      and city.id = tour.id_city
                                      and country.id = city.id_country
                                      and user.login like '$login' ", {Columns=>{}});

  $tmpl->param(ROWS => $rows || []);
  $db->disconnect();

  print $tmpl->output;
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;