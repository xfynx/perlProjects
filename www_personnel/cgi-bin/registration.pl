#!/usr/bin/perl -w
use HTML::Template;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use DBI;
use Digest::MD5 qw(md5_hex);

print "Content-type: text/html\n\n";

my $email = param("login");
my $password = param("password");
$password = md5_hex($password);

$db = DBI->connect("dbi:SQLite:dbname=../db/personnel_department.sqlite","","") || die $DBI::errstr;
my $query = $db->do("insert into auth (email, password) values ('$email', '$password');");
$db->disconnect;
#print "insert into user (login, password) values ('$email', '$password');";

print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
exit;