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
  $ID = param("id");
  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/showRequest.tmpl', option => 'value');

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

  my $rows=$db->selectall_arrayref('select request.id, date, request_type, user.full_name as full_name, user.phone as phone,
                                      type, district, square, price_from, price_to, chamber_count, status
                                      from request join user where user.id = request.id_user and request.id = '.$ID.';', {Columns=>{}});

  my $query = $db->prepare('select user.id from request join user where user.id = request.id_user and request.id = '.$ID.';');
  $query->execute() or die($db->errstr);
  @row = $query->fetchrow_array();
  $userid = $row[0];
  $query->finish();

  my $query = $db->prepare("select id from user where login = '$login';");
  $query->execute() or die($db->errstr);
  @row = $query->fetchrow_array();
  $id_user = $row[0];
  $query->finish();
  $db->disconnect();

  if($userid eq $id_user){
#    $qqq=$db->selectall_arrayref("select id from user where login = '$login';", {Columns=>{}});
    $tmpl->param(ROWS => $rows, USERID=> $userid);
  }

  $tmpl->param(ROWS => $rows);
  print $tmpl->output;
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;