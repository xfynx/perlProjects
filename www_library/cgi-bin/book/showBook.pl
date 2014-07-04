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
  $book_id = param("book_id");
  
  $tmpl = HTML::Template->new(filename => '/var/www/tmpl/showBook.tmpl', option => 'value');

  $db = DBI->connect('DBI:mysql:library;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  my $data=$db->selectall_arrayref("select book.id, publisher.name as publisher,author.name as author, book.name, book.date,book.count from book join publisher join author where book.id = ".$book_id." and publisher.id = book.id_publisher and author.id = book.id_author order by author.name, book.name, publisher.name;", {Columns=>{}});
  my $authors=$db->selectall_arrayref('select name from author', {Columns=>{}});
  my $publishers=$db->selectall_arrayref('select name from publisher', {Columns=>{}});
  my $id=$db->selectall_arrayref("select id from `book` where id=$book_id;", {Columns=>{}});

  $db->disconnect();

  $tmpl->param(DATA => $data || [], AUTHORS => $authors || [], PUBLISHERS => $publishers || [], ID => $id);
  print $tmpl->output;
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;