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

$db = DBI->connect('DBI:mysql:library;host=localhost:3306', 'root', '123', { RaiseError => 1 });
my $query = $db->do("insert into user (login, password) values ('$email', '$password');");
$db->disconnect;
#print "insert into user (login, password) values ('$email', '$password');";

print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
exit;