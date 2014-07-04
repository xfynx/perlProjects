#!/usr/bin/perl -w
use strict;
use HTML::Template;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use DBD::SQLite;

print "Content-type: text/html\n\n";

open(FILE, "../../auth.txt");
my $isAdmin;
while (defined (my $file_line = <FILE>)) {
        if($file_line eq 'admin') { $isAdmin=1; }
}
close FILE;

if($isAdmin){
  my $id = param("id");
  my $name = param("name");
  my $monthly = param("monthly");
  my $yearly = param("yearly");
  
  my $db = DBI->connect("dbi:SQLite:dbname=/var/www/db/personnel_department.sqlite","","") || die $DBI::errstr;
  
  my $data=$db->selectall_arrayref("update unit set name='$name', monthly_fund=$monthly, yearly_fund=$yearly where id=$id;");
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/unit/showUnit.pl?id='.$id.'"></html>';
}
else{
    print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;