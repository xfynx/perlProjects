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
  my $entry = param("id");
  
  $tmpl = HTML::Template->new(filename => '/var/www/tmpl/showTour.tmpl', option => 'value');

  $db = DBI->connect('DBI:mysql:tourist;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  my $rows=$db->selectall_arrayref("select tour.id as tour_id, hotel, hotel_info, description, city.name as city, country.name as country, price
                                    from tour join city join country
                                    where city.id = tour.id_city
                                    and tour.id = ".$entry."
                                    and country.id = city.id_country;", {Columns=>{}});
  $db->disconnect();
									
  $tmpl->param(ROWS => $rows);
  print $tmpl->output;
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;