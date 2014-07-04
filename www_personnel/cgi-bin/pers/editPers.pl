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
  $id = param("id");
  $first = param("first");
  $middle = param("middle");
  $last = param("last");
  $address = param("address");
  $phone = param("phone");
  $birth = param("birth");
  $post = param("post");
  $post_date = param("post_date");
  $expirience = param("expirience");
  $education = param("education");
  $inn = param("inn");
  $snils = param("snils");
  $unitname = param("unitname");

  $db = DBI->connect("dbi:SQLite:dbname=/var/www/db/personnel_department.sqlite","","") || die $DBI::errstr;
  my $data=$db->selectall_arrayref("update personal_data set first_name='$first',middle_name='$middle',last_name='$last', address='$address',phone_number='$phone',birth_date='$birth',post='$post', post_date='$post_date',expirience='$expirience',education='$education',INN='$inn', SNILS='$snils', id_unit=(select id from unit where name like '$unitname') where id=$id;");
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/pers/showPers.pl?id='.$id.'"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;