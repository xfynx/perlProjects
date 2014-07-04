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

  $id_book = param("id_book");

  open(FILE, "../../auth.txt");
  my $login;
  while (defined ($file_line = <FILE>)) {
    $login = $file_line;
    last;
  }
  close FILE;

  $db = DBI->connect('DBI:mysql:library;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  $login =~ s/^\s+//m;
  $login =~ s/\s+$//m;
 #сделать вставку ещё и сегодняшней даты
  my $data=$db->do("INSERT INTO orders (id_user, id_book) select user.id, ".$id_book." from user where login like '$login';");

  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/book/showBook.pl?book_id='.$id_book.'"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;