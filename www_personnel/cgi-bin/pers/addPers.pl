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
  
  my $data=$db->selectall_arrayref("INSERT INTO personal_data (first_name,middle_name,last_name,address,phone_number,birth_date,post,
									post_date,expirience,education,INN,SNILS,id_unit) 
									select '$first','$middle','$last','$address','$phone','$birth','$post','$post_date',$expirience,'$education',
									$inn,$snils,
									id from unit where name like '$unitname';");
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/pers/getAllPers.pl"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;