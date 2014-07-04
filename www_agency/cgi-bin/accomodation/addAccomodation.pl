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
  open(FILE, "../../auth.txt");
      my $login;
      while (defined ($file_line = <FILE>)) {
        $login = $file_line;
        last;
      }
      close FILE;

  $login =~ s/^\s+//m;
  $login =~ s/\s+$//m;

  $db = DBI->connect('DBI:mysql:agency;host=localhost:3306', 'root', '123', { RaiseError => 1 });

  my $query = $db->prepare("select role from user where login = '$login';");
  $query->execute() or die($db->errstr);
  @row = $query->fetchrow_array();
  $role = $row[0];
  $query->finish();

  $role =~ s/^\s+//m;
  $role =~ s/\s+$//m;

  if($role eq "client"){
    print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
  }
  if($role eq "owner"){
    $date = param("date");
    $accomodation_type = param("accomodation-type");
    $type = param("type");
    $district = param("district");
    $square = param("square");
    $price = param("price");
    $chamber_count = param("chamber-count");
    $address = param("address");
    $description = param("description");

      my $query = $db->prepare("select id from user where login = '$login';");
      $query->execute() or die($db->errstr);
      @row = $query->fetchrow_array();
      $id_user = $row[0];
      $query->finish();

    my $data=$db->do("INSERT INTO accomodation (date, accomodation_type, id_user, type, district, square, price,
                        chamber_count, address, description)
                        values ('$date','$accomodation_type', $id_user, '$type', '$district', '$square', $price, $chamber_count, '$address', '$description');");

    $db->disconnect();

    print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/accomodation/getAllAccomodation.pl"></html>';
  }
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;