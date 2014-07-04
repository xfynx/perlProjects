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
  
  $ID = param("id");
  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/showSpectacle.tmpl', option => 'value');
  #$tmpl = HTML::Template->new(filename => '/var/www/tmpl/showSpectacle.tmpl', option => 'value');

  $db = DBI->connect('DBI:mysql:afisha;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  my $data=$db->selectall_arrayref("select 
									spectacle.id, spectacle.name, spectacle.begin_at, spectacle.duration, spectacle.ticket_count, spectacle.description, theatre.name as theatre
									from spectacle join theatre
									where spectacle.id = $ID and theatre.id = spectacle.id_theatre;", {Columns=>{}});

  my $THEATERS=$db->selectall_arrayref("select name from theatre;", {Columns=>{}});
  my $id=$db->selectall_arrayref("select id from `spectacle` where id=$ID;", {Columns=>{}});
  my $places=$db->selectall_arrayref("select place from `orders` where orders.id_spectacle=$ID;", {Columns=>{}});

  my $theatre_id=$db->selectall_arrayref("select id_theatre from spectacle where spectacle.id=$ID;", {Columns=>{}});
  $theatre_id=$theatre_id[0];

  my $query = $db->prepare("select id_theatre from spectacle where spectacle.id=$ID;");
  $query->execute() or die($db->errstr);
  @row = $query->fetchrow_array();
  $theatre_id = $row[0];

  my $total_place_count=$db->selectall_arrayref("select place_count from theatre where theatre.id=$theatre_id;", {Columns=>{}});

  $db->disconnect();									
									
  $tmpl->param(DATA => $data || [], THEATERS=>$THEATERS, ID=>$id || [], PLACES=>$places || [], TOTAL_COUNT=>$total_place_count);

  print $tmpl->output;
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}

exit;