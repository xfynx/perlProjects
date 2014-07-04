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

my $phone = param("phone");
my $full_name = param("full-name");
my $passport_info = param("passport-info");
my $birth_date = param("birth");

$db = DBI->connect('DBI:mysql:tourist;host=localhost:3306', 'root', '123', { RaiseError => 1 });
my $query = $db->do("insert into user (login, password, full_name, birth_date, phone, passport_info) values
                    ('$email', '$password', '$full_name', '$birth_date', '$phone', '$passport_info');");
$db->disconnect;

print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
exit;