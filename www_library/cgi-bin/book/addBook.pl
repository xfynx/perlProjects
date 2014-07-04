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
  $publisher = param("publisher");
  $author = param("author");
  $name = param("name");
  $date = param("date");
  $count = param("count");
  
  $db = DBI->connect('DBI:mysql:library;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  
  my $data=$db->do("INSERT INTO book (name, date, count, id_publisher, id_author)
                    values ('$name', '$date', $count,
                    (select id from publisher where name = '$publisher'),
                    (select id from author where name = '$author'));");
									
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/book/getAllBook.pl"></html>';
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;